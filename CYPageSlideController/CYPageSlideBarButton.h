//
//  CYPageSlideBarButton.h
//  PageSlideControllerDemo
//
//  Created by Chen Yiliang on 12/14/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYPageSlideBarItem.h"

#define PAGE_SLIDE_BAR_BUTTON_CONTENT_EDGE_H    8.0f
#define PAGE_SLIDE_BAR_BUTTON_TITLE_FONT   [UIFont systemFontOfSize:14.0]

@interface CYPageSlideBarButton : UIButton

@property (nonatomic, strong) CYPageSlideBarItem *item;

+ (instancetype)buttonWithType:(UIButtonType)buttonType item:(CYPageSlideBarItem *)item;

@end
