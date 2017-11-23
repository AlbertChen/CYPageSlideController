//
//  TabSlideController.h
//  PageSlideControllerDemo
//
//  Created by Chen Yiliang on 12/14/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYPageSlideBar.h"

@protocol CYPageSlideControllerDelegate;

@interface CYPageSlideController : UIViewController <UIScrollViewDelegate, CYPageSlideBarDataSource, CYPageSlideBarDelegate>

- (instancetype)initWithViewControllers:(NSArray *)viewControllers barLayoutStyle:(CYPageSlideBarLayoutStyle)barLayoutStyle;

@property (nonatomic, copy) NSArray *viewControllers;

@property (nonatomic, assign) UIViewController *selectedViewController;
@property (nonatomic, assign) NSUInteger selectedIndex;

@property (nonatomic, strong) IBOutlet CYPageSlideBar *pageSlideBar;
@property (nonatomic, assign) CGFloat pageSlideBarHeight;
@property (nonatomic, assign) CYPageSlideBarLayoutStyle pageSlideBarLayoutStyle;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) id<CYPageSlideControllerDelegate> delegate;

- (void)updateSubviewsWithSelectedIndex:(NSInteger)selectedIndex changeOffset:(BOOL)changeOffset;

@end

@protocol CYPageSlideControllerDelegate <NSObject>

@optional
- (void)pageSlideController:(CYPageSlideController *)slideController didSelectViewController:(UIViewController *)viewController;

@end

@interface UIViewController (CYPageSlideControllerItem)

@property (nonatomic, strong) CYPageSlideBarItem *pageSlideBarItem;
@property (nonatomic, strong, readonly) CYPageSlideController *pageSlideController;

@end

