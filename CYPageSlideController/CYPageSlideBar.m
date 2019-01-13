//
//  CYPageSlideBar.m
//  PageSlideControllerDemo
//
//  Created by Chen Yiliang on 12/14/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CYPageSlideBar.h"

@interface CYPageSlideBar ()

@property (nonatomic, strong, readwrite) UIScrollView *scrollView;
@property (nonatomic, strong, readwrite) UIView *indicatorView;
@property (nonatomic, strong, readwrite) UIView *seperatorView;

@end

@implementation CYPageSlideBar

#pragma mark - Getters & Setters

- (void)setFrame:(CGRect)frame {
    CGRect originalFrame = self.frame;
    [super setFrame:frame];
    
    if (!CGSizeEqualToSize(frame.size, originalFrame.size)) {
        [self reloadSubviews];
    }
}

- (void)setLayoutStyle:(CYPageSlideBarLayoutStyle)layoutStyle {
    if (_layoutStyle != layoutStyle) {
        _layoutStyle = layoutStyle;
        [self layoutButtons];
        [self setSelectedItem:_selectedItem alwaysReset:YES];
    }
    
    if (layoutStyle == CYPageSlideBarLayoutStyleTite) {
        self.scrollView.scrollEnabled = NO;
        self.scrollView.bounces = NO;
    } else {
        self.scrollView.scrollEnabled = YES;
        self.scrollView.bounces = YES;
        self.scrollView.alwaysBounceHorizontal = YES;
    }
}

- (void)setAccessoryView:(UIView *)accessoryView {
    CGSize contentSize = _scrollView.contentSize;
    if (_accessoryView != nil && [_accessoryView superview] != nil) {
        contentSize.width -= CGRectGetWidth(_accessoryView.bounds);
        [_accessoryView removeFromSuperview];
    }
    
    if (accessoryView != nil) {
        contentSize.width += CGRectGetWidth(accessoryView.bounds);
        accessoryView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:accessoryView];
        
        NSDictionary *views = @{ @"accessoryView": accessoryView };
        NSDictionary *metrics = @{ @"width": @(accessoryView.frame.size.width) };
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[accessoryView(width)]-(-1)-|" options:0 metrics:metrics views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[accessoryView]|" options:0 metrics:metrics views:views]];
    }
    
    _accessoryView = accessoryView;
    _scrollView.contentSize = contentSize;
}

- (void)setItems:(NSArray<CYPageSlideBarItem *> *)items {
    _items = [items copy];
    
    [self layoutButtons];
}

- (void)setSelectedItem:(CYPageSlideBarItem *)selectedItem {
    [self setSelectedItem:selectedItem alwaysReset:NO];
}

- (void)setSelectedItem:(CYPageSlideBarItem *)selectedItem alwaysReset:(BOOL)alwaysReset {
    if (_selectedItem != selectedItem || alwaysReset) {
        NSInteger preSelectedIndex = [self.items indexOfObject:_selectedItem];
        if (preSelectedIndex >= 0 && preSelectedIndex < self.items.count) {
            CYPageSlideBarButton *preSelectedButton = [self.scrollView viewWithTag:preSelectedIndex + 100];
            preSelectedButton.selected = NO;
            preSelectedButton.titleLabel.font = self.titleFont;
            [preSelectedButton setTitleColor:_selectedItem.titleColor forState:UIControlStateNormal];
        }
        
        _selectedItem = selectedItem;
        NSInteger selectedIndex  = [self.items indexOfObject:selectedItem];
        if (selectedIndex >= 0 && selectedIndex < self.items.count) {
            CYPageSlideBarButton *selectedButton = [self.scrollView viewWithTag:selectedIndex + 100];
            selectedButton.selected = YES;
            selectedButton.titleLabel.font = self.selectedTitleFont ?: self.titleFont;
            [selectedButton setTitleColor:selectedItem.selectedTitleColor ?: self.tintColor forState:UIControlStateSelected];
            
            CGRect frame = self.indicatorView.frame;
            frame.origin.x = selectedButton.frame.origin.x;
            frame.origin.y = selectedButton.frame.size.height - frame.size.height;
            frame.size.width = selectedButton.frame.size.width;
            self.indicatorView.frame = frame;
//            self.indicatorView.backgroundColor = selectedItem.selectedTitleColor ?: self.tintColor;
            
            if (self.layoutStyle == CYPageSlideBarLayoutStyleNormal) {
                CGFloat offsetX = 0.0;
                if (self.scrollView.bounds.size.width > 0.0) {
                    CGFloat halfWidth = CGRectGetWidth(self.scrollView.bounds) / 2;
                    if (selectedButton.center.x < halfWidth) {
                        offsetX = 0.0;
                    } else {
                        CGFloat maxOffsetX = self.scrollView.contentSize.width - CGRectGetWidth(self.scrollView.bounds);
                        if (maxOffsetX < 0.0) {
                            offsetX = 0.0;
                        }  else {
                            offsetX = selectedButton.center.x - halfWidth;
                            offsetX = MIN(offsetX, maxOffsetX);
                        }
                    }
                }
                
                CGPoint contentOffset = self.scrollView.contentOffset;
                if (contentOffset.x != offsetX) {
                    contentOffset.x = offsetX;
                    [self.scrollView setContentOffset:contentOffset animated:YES];
                }
            }
        }
    }
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
    return _scrollView;
}

- (UIView *)seperatorView {
    if (_seperatorView == nil) {
        _seperatorView = [[UIView alloc] initWithFrame:CGRectZero];
        _seperatorView.translatesAutoresizingMaskIntoConstraints = NO;
        _seperatorView.backgroundColor  = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0];
    }
    
    return _seperatorView;
}

- (UIView *)indicatorView {
    if (_indicatorView == nil) {
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, PAGE_SLIDE_BAR_INDECATOR_VIEW_HEIGHT)];
        _indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        _indicatorView.backgroundColor = self.tintColor;
    }
    
    return _indicatorView;
}

- (CGFloat)indicatorViewHeight {
    return self.indicatorView.frame.size.height;
}

- (void)setIndicatorViewHeight:(CGFloat)indicatorViewHeight {
    CGRect frame = self.indicatorView.frame;
    frame.origin.y -= indicatorViewHeight - frame.size.height;
    frame.size.height = indicatorViewHeight;
    self.indicatorView.frame = frame;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[CYPageSlideBarButton class]]) {
            CYPageSlideBarButton *button = (CYPageSlideBarButton *)view;
            if (!button.selected || self.selectedTitleFont == nil) {
                button.titleLabel.font = titleFont;
            }
        }
    }
}

- (void)setSelectedTitleFont:(UIFont *)selectedTitleFont {
    _selectedTitleFont = selectedTitleFont;
    [self setSelectedItem:self.selectedItem alwaysReset:YES];
}

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithLayoutStyle:(CYPageSlideBarLayoutStyle)layoutStyle {
    self = [self initWithFrame:CGRectZero];
    if (self != nil) {
        self.layoutStyle = layoutStyle;
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self commonInit];
}

- (void)commonInit {
    self.titleFont = PAGE_SLIDE_BAR_TITLE_FONT;
    self.tintColor = PAGE_SLIDE_BAR_TINT_COLOR;
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.scrollView];
    [self addSubview:self.seperatorView];
    [self.scrollView addSubview:self.indicatorView];
    
    [self setupLayoutConstraints];
}

- (void)setupLayoutConstraints {
    NSDictionary *views = @{ @"scrollView": self.scrollView,
                             @"seperatorView": self.seperatorView,
                             @"indicatorView": self.indicatorView };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[seperatorView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[seperatorView(0.5)]|" options:0 metrics:nil views:views]];
}

#pragma mark -

- (void)layoutButtons {
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[CYPageSlideBarButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (self.items.count == 0) return;
    
    CGFloat offsetX = self.layoutStyle == CYPageSlideBarLayoutStyleTite ? 0.0 : PAGE_SLIDE_BAR_ITEMS_GAP;
    for (int i = 0; i < self.items.count; i++) {
        CYPageSlideBarItem *item = self.items[i];
        CYPageSlideBarButton *button = nil;
        if ([self.dataSource respondsToSelector:@selector(pageSlideBar:buttonForItem:atIndex:)]) {
            button = [self.dataSource pageSlideBar:self buttonForItem:item atIndex:@(i)];
        } else {
            button = [CYPageSlideBarButton buttonWithType:UIButtonTypeCustom item:item];
            button.backgroundColor = [UIColor clearColor];
            button.titleLabel.font = self.titleFont;
            [button setTitleColor:item.titleColor forState:UIControlStateNormal];
            [button setTitleColor:item.selectedTitleColor ?: self.tintColor forState:UIControlStateSelected];
        }
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [button sizeToFit];
        CGRect frame = button.frame;
        frame.origin.x = offsetX;
        if (self.layoutStyle == CYPageSlideBarLayoutStyleTite) {
            frame.size.width = floorf(self.frame.size.width / self.items.count);
        }
        frame.size.height = self.frame.size.height;
        button.frame = frame;
        button.tag = i + 100;
        [self.scrollView addSubview:button];
        
        offsetX += self.layoutStyle == CYPageSlideBarLayoutStyleTite ? frame.size.width : frame.size.width + PAGE_SLIDE_BAR_ITEMS_GAP;
        
        if ([self.delegate respondsToSelector:@selector(pageSlideBar:didLoadButton:atIndex:)]) {
            [self.delegate pageSlideBar:self didLoadButton:button atIndex:@(i)];
        }
    }
    
    CGSize contentSize = self.scrollView.contentSize;
    contentSize.width = offsetX + self.accessoryView.frame.size.width;
    self.scrollView.contentSize = contentSize;
}

- (IBAction)buttonPressed:(id)sender {
    CYPageSlideBarItem *selectedItem = nil;
    if (sender != nil) {
        CYPageSlideBarButton *button = (CYPageSlideBarButton *)sender;
        selectedItem = self.items[button.tag - 100];
    } else {
        selectedItem = self.items.firstObject;
    }
    
    if ([self.delegate respondsToSelector:@selector(pageSlideBar:didSelectItem:)]) {
        [self.delegate pageSlideBar:self didSelectItem:selectedItem];
    }
}

#pragma mark - Public Mehtods

- (void)reloadSubviews {
    [self layoutButtons];
    [self setSelectedItem:self.selectedItem alwaysReset:YES];
}

- (void)moveToIndex:(NSInteger)index progress:(CGFloat)progress {
    if ([self.dataSource respondsToSelector:@selector(pageSlideBar:buttonForItem:atIndex:)]) return;
    
    CGFloat n_r, n_g, n_b = 0.0;
    CYPageSlideBarItem *item = self.items[index];
    [item.titleColor getRed:&n_r green:&n_g blue:&n_b alpha:NULL];
    CGFloat h_r, h_g, h_b = 0.0;
    UIColor *selectedTitleColor = item.selectedTitleColor ?: self.tintColor;
    [selectedTitleColor getRed:&h_r green:&h_g blue:&h_b alpha:NULL];
    
    CGFloat offset_r = progress * (h_r - n_r);
    CGFloat offset_g = progress * (h_g - n_g);
    CGFloat offset_b = progress * (h_b - n_b);
    
    CYPageSlideBarButton *nextButton = [self.scrollView viewWithTag:index + 100];
    [nextButton setTitleColor:[UIColor colorWithRed:n_r + offset_r green:n_g + offset_g blue:n_b + offset_b alpha:1.0] forState:UIControlStateNormal];
    
    NSInteger selectedIndex  = [self.items indexOfObject:self.selectedItem];
    CYPageSlideBarButton *selectedButton = [self.scrollView viewWithTag:selectedIndex + 100];
    [selectedButton setTitleColor:[UIColor colorWithRed:h_r - offset_r green:h_g - offset_g blue:h_b - offset_b alpha:1.0] forState:UIControlStateSelected];
}

@end
