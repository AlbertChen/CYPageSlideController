//
//  CYPageSlideBarButton.m
//  PageSlideControllerDemo
//
//  Created by Chen Yiliang on 12/14/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "CYPageSlideBarButton.h"

@interface CYPageSlideBarButton ()

@end

@implementation CYPageSlideBarButton

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"item.title"];
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType item:(CYPageSlideBarItem *)item {
    CYPageSlideBarButton *button = [super buttonWithType:buttonType];
    if (button != nil) {
        button.item = item;
        button.titleLabel.font = PAGE_SLIDE_BAR_BUTTON_TITLE_FONT;
        
        [button addObserver:button forKeyPath:@"item.title" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
    
    return button;
}

- (void)setItem:(CYPageSlideBarItem *)item {
    _item = item;
    
    [self configTitle];
}

- (void)configTitle {
    [self setTitle:self.item.title forState:UIControlStateNormal];
    [self setTitle:self.item.title forState:UIControlStateSelected];
    [self setTitleColor:self.item.titleColor forState:UIControlStateNormal];
    [self setTitleColor:self.item.selectedTitleColor forState:UIControlStateSelected];
}

#pragma mark - Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"item.title"] && object == self) {
        [self configTitle];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
