//
//  CYPageSlideBar.h
//  PageSlideControllerDemo
//
//  Created by Chen Yiliang on 12/14/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYPageSlideBarButton.h"

#define PAGE_SLIDE_BAR_HEIGHT    35.0f
#define PAGE_SLIDE_BAR_TINT_COLOR [UIColor colorWithRed:6/255.0 green:151/255.0 blue:218/255.0 alpha:1.0]
#define PAGE_SLIDE_BAR_INDECATOR_VIEW_HEIGHT 2.0f
#define PAGE_SLIDE_BAR_ITEMS_GAP    15.0f

typedef NS_ENUM(NSInteger, CYPageSlideBarLayoutStyle) {
    CYPageSlideBarLayoutStyleNormal = 0, // Buttons layout one by one
    CYPageSlideBarLayoutStyleTite, // Buttons layout in full screen width
};

@protocol CYPageSlideBarDataSource, CYPageSlideBarDelegate;

@interface CYPageSlideBar : UIView

- (instancetype)initWithLayoutStyle:(CYPageSlideBarLayoutStyle)layoutStyle;

@property (nonatomic, assign) CYPageSlideBarLayoutStyle layoutStyle;

@property (nonatomic, strong) UIView *accessoryView;

@property (nonatomic, strong, readonly) UIView *seperatorView;

@property (nonatomic, strong, readonly) UIView *indicatorView;
@property (nonatomic, assign) CGFloat indicatorViewHeight;

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, copy) NSArray<CYPageSlideBarItem *> *items;
@property (nonatomic, weak) CYPageSlideBarItem *selectedItem;

@property (nonatomic, weak) id<CYPageSlideBarDataSource> dataSource;
@property (nonatomic, weak) id<CYPageSlideBarDelegate> delegate;

- (void)moveToIndex:(NSInteger)index progress:(CGFloat)progress;

@end

@protocol CYPageSlideBarDataSource <NSObject>

@optional
- (CYPageSlideBarButton *)pageSlideBar:(CYPageSlideBar *)slideBar buttonForItem:(CYPageSlideBarItem *)item atIndex:(NSNumber *)index;

@end

@protocol CYPageSlideBarDelegate <NSObject>

@optional
- (void)pageSlideBar:(CYPageSlideBar *)slideBar didSelectItem:(CYPageSlideBarItem *)item;
- (void)pageSlideBar:(CYPageSlideBar *)slideBar didLoadButton:(CYPageSlideBarButton *)button atIndex:(NSNumber *)index;

@end
