//
//  CYGestureScrollView.m
//  PageSlideControllerDemo
//
//  Created by Chen Yiliang on 23/10/2017.
//  Copyright © 2017 Chen Yiliang. All rights reserved.
//

#import "CYPageScrollView.h"

@implementation CYPageScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    id nextResponder = [otherGestureRecognizer.view nextResponder];
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && self.contentOffset.x < [UIScreen mainScreen].bounds.size.width && ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) && [nextResponder isKindOfClass:[UINavigationController class]]) {
        return YES;
    } else {
        return  NO;
    }
}

- (void)setContentOffset:(CGPoint)contentOffset {
    if (!self.alwaysBounceHorizontalLeft) {
        if (self.isDragging || self.isDecelerating) {
            if (contentOffset.x < 0.0) {
                contentOffset.x = 0.0;
                self.panGestureRecognizer.enabled = NO;
            } else {
                self.panGestureRecognizer.enabled = YES;
            }
        } else {
            self.panGestureRecognizer.enabled = YES;
        }
    }
    
    [super setContentOffset:contentOffset];
}

@end
