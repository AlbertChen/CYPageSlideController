//
//  TabSlideController.m
//  CYPageSlideControllerDemo
//
//  Created by Chen Yiliang on 12/14/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CYPageSlideController.h"
#import <objc/runtime.h>

@interface CYPageSlideController ()

@end

@implementation CYPageSlideController

#pragma mark - Getters & Setters

- (CYPageSlideBar *)pageSlideBar {
    if (_pageSlideBar == nil) {
        _pageSlideBar = [[CYPageSlideBar alloc] initWithLayoutStyle:self.pageSlideBarLayoutStyle];
        _pageSlideBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _pageSlideBar.dataSource = self;
        _pageSlideBar.delegate = self;
    }
    
    return _pageSlideBar;
}

- (void)setPageSlideBarHeight:(CGFloat)pageSlideBarHeight {
    if (_pageSlideBar == nil) {
        _pageSlideBarHeight = pageSlideBarHeight;
    } else {
        CGFloat changedHeight = pageSlideBarHeight - _pageSlideBarHeight;
        CGRect frame = _pageSlideBar.frame;
        frame.size.height = pageSlideBarHeight;
        _pageSlideBar.frame = frame;
        
        frame = _scrollView.frame;
        frame.origin.y += changedHeight;
        frame.size.height -= changedHeight;
        _scrollView.frame = frame;
        
        _pageSlideBarHeight = pageSlideBarHeight;
    }
}

- (void)setPageSlideBarLayoutStyle:(CYPageSlideBarLayoutStyle)pageSlideBarLayoutStyle {
    _pageSlideBarLayoutStyle = pageSlideBarLayoutStyle;
    
    if (_pageSlideBar != nil) {
        _pageSlideBar.layoutStyle = pageSlideBarLayoutStyle;
    }
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    
    return _scrollView;
}

- (void)setViewControllers:(NSArray *)viewControllers {
    _viewControllers = [viewControllers copy];
    
    [self updateSubviews];
}

#pragma mark - Lifecycle

- (void)commonInit {
    _pageSlideBarHeight = PAGE_SLIDE_BAR_HEIGHT;
    _pageSlideBarLayoutStyle = CYPageSlideBarLayoutStyleTite;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithViewControllers:(NSArray *)viewControllers barLayoutStyle:(CYPageSlideBarLayoutStyle)barLayoutStyle {
    self = [self init];
    if (self != nil) {
        _pageSlideBarLayoutStyle = barLayoutStyle;
        _viewControllers = [viewControllers copy];
    }
    
    return self;
}

#pragma mark - View Lifecycle

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_pageSlideBar == nil || _pageSlideBar.superview == nil) {
        CGRect frame = self.pageSlideBar.frame;
        frame.size.width = self.view.frame.size.width;
        frame.size.height = self.pageSlideBarHeight;
        self.pageSlideBar.frame = frame;
        [self.view addSubview:self.pageSlideBar];
    }
    
    if (_scrollView == nil || _scrollView.superview == nil) {
        CGRect frame = self.scrollView.frame;
        frame.origin.y = self.pageSlideBarHeight;
        frame.size.width = self.view.frame.size.width;
        frame.size.height = self.view.frame.size.height - self.pageSlideBarHeight;
        self.scrollView.frame = frame;
        [self.view addSubview:self.scrollView];
    }
    
    [self updateSubviews];
}

- (void)updateSubviews {
    if (_scrollView == nil) return;
    
    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    NSMutableArray *barItems = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.viewControllers.count; i++) {
        UIViewController *viewController = self.viewControllers[i];
        if (viewController.pageSlideBarItem == nil) {
            viewController.pageSlideBarItem = [[CYPageSlideBarItem alloc] initWithTitle:viewController.title titleColor:nil selectedTitleColor:nil];
        }
        [barItems addObject:viewController.pageSlideBarItem];
        
        CGRect frame = _scrollView.bounds;
        frame.origin.x = i * self.view.frame.size.width;
        viewController.view.frame = frame;
        viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_scrollView addSubview:viewController.view];
        
        [self addChildViewController:viewController];
    }
    
    [_pageSlideBar setItems:barItems];
    CGSize contentSize = _scrollView.contentSize;
    contentSize.width = self.view.frame.size.width * self.viewControllers.count;
    _scrollView.contentSize = contentSize;
}

- (void)updateSubviewsWithSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex < 0 || selectedIndex > self.viewControllers.count) return;
    
    UIViewController *viewController = self.viewControllers[selectedIndex];
    if (self.pageSlideBar.selectedItem != viewController.pageSlideBarItem) {
        if (self.pageSlideBar.selectedItem != nil) {
            NSInteger preSelectedIndex = [self.pageSlideBar.items indexOfObject:self.pageSlideBar.selectedItem];
            if (preSelectedIndex < self.viewControllers.count) {
                UIViewController *preViewController = self.viewControllers[preSelectedIndex];
                [preViewController viewWillDisappear:NO];
            }
        }
        
        self.pageSlideBar.selectedItem = viewController.pageSlideBarItem;
        [viewController viewWillAppear:NO];
        
        if ([self.delegate respondsToSelector:@selector(pageSlideController:didSelectViewController:)]) {
            [self.delegate pageSlideController:self didSelectViewController:viewController];
        }
        
        if (![self.scrollView isDecelerating]) {
            CGPoint contentOffset = self.scrollView.contentOffset;
            if (contentOffset.x != selectedIndex * self.view.frame.size.width) {
                contentOffset.x = selectedIndex * self.view.frame.size.width;
                [self.scrollView setContentOffset:contentOffset animated:YES];
            }
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (![scrollView isDecelerating]) return;
    
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    CGFloat indexF = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (fabs(indexF - index) <= 0.1) {
        [self updateSubviewsWithSelectedIndex:index];
    }
}

#pragma mark - CYPageSlideBarDelegate

- (void)pageSlideBar:(CYPageSlideBar *)slideBar didSelectItem:(CYPageSlideBarItem *)item {
    NSInteger index = [self.pageSlideBar.items indexOfObject:item];
    [self updateSubviewsWithSelectedIndex:index];
}

@end

static const void * kCYPageSlideBarItem = &kCYPageSlideBarItem;
//static const void * kCYPageSlideController = &kCYPageSlideController;

@implementation UIViewController (CYPageSlideControllerItem)

- (CYPageSlideBarItem *)pageSlideBarItem {
    return objc_getAssociatedObject(self, kCYPageSlideBarItem);
}

- (void)setPageSlideBarItem:(CYPageSlideBarItem *)pageSlideBarItem {
    objc_setAssociatedObject(self, kCYPageSlideBarItem, pageSlideBarItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CYPageSlideController *)pageSlideController {
    CYPageSlideController *pageSlideController = nil;
//    UIViewController *parentController = nil;
//    do {
//        UIViewController *parentController = self.parentViewController;
//        if ([parentController isKindOfClass:[TabSlideController class]]) {
//            tabSlideController = (TabSlideController *)parentController;
//        }
//    } while (tabSlideController == nil  && parentController.parentViewController != nil);
//    
//    return tabSlideController;
    
    if ([self.parentViewController isKindOfClass:[CYPageSlideController class]]) {
        pageSlideController = (CYPageSlideController *)self.parentViewController;
    }
    return pageSlideController;
}

@end

