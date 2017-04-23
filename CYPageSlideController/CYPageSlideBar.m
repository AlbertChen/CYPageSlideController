//
//  CYPageSlideBar.m
//  PageSlideControllerDemo
//
//  Created by Chen Yiliang on 12/14/16.
//  Copyright © 2016 CYYUN. All rights reserved.
//

#import "CYPageSlideBar.h"

@interface CYPageSlideBar ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong, readwrite) UIView *indicatorView;
@property (nonatomic, strong, readwrite) UIView *seperatorView;

@end

@implementation CYPageSlideBar

#pragma mark - Getters & Setters

- (void)setLayoutStyle:(CYPageSlideBarLayoutStyle)layoutStyle {
    if (_layoutStyle != layoutStyle) {
        _layoutStyle = layoutStyle;
        [self layoutButtons];
    }
}

- (void)setItems:(NSArray<CYPageSlideBarItem *> *)items {
    _items = [items copy];
    
    [self layoutButtons];
}

- (void)setSelectedItem:(CYPageSlideBarItem *)selectedItem {
    if (_selectedItem != selectedItem) {
        NSInteger preSelectedIndex = [self.items indexOfObject:_selectedItem];
        if (preSelectedIndex >= 0 && preSelectedIndex < self.items.count) {
            CYPageSlideBarButton *preSelectedButton = [self.scrollView viewWithTag:preSelectedIndex + 100];
            preSelectedButton.selected = NO;
        }
        
        _selectedItem = selectedItem;
        NSInteger selectedIndex  = [self.items indexOfObject:selectedItem];
        if (selectedIndex >= 0 && selectedIndex < self.items.count) {
            CYPageSlideBarButton *selectedButton = [self.scrollView viewWithTag:selectedIndex + 100];
            selectedButton.selected = YES;
            
            CGRect frame = self.indicatorView.frame;
            frame.origin.x = selectedButton.frame.origin.x;
            frame.origin.y = selectedButton.frame.size.height - frame.size.height;
            frame.size.width = selectedButton.frame.size.width;
            self.indicatorView.frame = frame;
            self.indicatorView.backgroundColor = selectedItem.selectedTitleColor != nil ? selectedItem.selectedTitleColor : self.tintColor;
            
            if (self.layoutStyle == CYPageSlideBarLayoutStyleInOrder) {
                CGFloat offsetX = selectedButton.center.x - CGRectGetMidX(self.scrollView.bounds);
                if (offsetX < 0.0) {
                    offsetX = 0.0;
                } else if (offsetX > self.scrollView.contentSize.width - CGRectGetWidth(self.scrollView.bounds)) {
                    offsetX = self.scrollView.contentSize.width - CGRectGetWidth(self.scrollView.bounds);
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
    frame.size.height = indicatorViewHeight;
    self.indicatorView.frame = frame;
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
    
    CGFloat offsetX = 0.0;
    for (int i = 0; i < self.items.count; i++) {
        CYPageSlideBarItem *item = self.items[i];
        CYPageSlideBarButton *button = nil;
        if ([self.dataSource respondsToSelector:@selector(pageSlideBar:buttonForItem:atIndex:)]) {
            button = [self.dataSource pageSlideBar:self buttonForItem:item atIndex:@(i)];
        } else {
            button = [CYPageSlideBarButton buttonWithType:UIButtonTypeCustom item:item];
            if (self.titleFont != nil) {
                button.titleLabel.font = self.titleFont;
            }
            [button setTitleColor:item.titleColor forState:UIControlStateNormal];
            [button setTitleColor:item.selectedTitleColor == nil ? self.tintColor : item.selectedTitleColor forState:UIControlStateSelected];
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
        
        offsetX += frame.size.width;
        
        if ([self.delegate respondsToSelector:@selector(pageSlideBar:didLoadButton:atIndex:)]) {
            [self.delegate pageSlideBar:self didLoadButton:button atIndex:@(i)];
        }
    }
    
    [self buttonPressed:nil];
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

@end
