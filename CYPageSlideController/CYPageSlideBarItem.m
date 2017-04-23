//
//  CYPageSlideBarItem.m
//  PageSlideControllerDemo
//
//  Created by Chen Yiliang on 12/14/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CYPageSlideBarItem.h"

@implementation CYPageSlideBarItem

- (instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor selectedTitleColor:(UIColor *)selectedTitleColor {
    self = [super init];
    if (self != nil) {
        self.title = title;
        self.titleColor = titleColor;
        self.selectedTitleColor = selectedTitleColor;
    }
    
    return self;
}

- (UIColor *)titleColor {
    return _titleColor == nil ? [UIColor blackColor] : _titleColor;
}

@end
