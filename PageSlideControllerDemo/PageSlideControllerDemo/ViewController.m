//
//  ViewController.m
//  PageSlideControllerDemo
//
//  Created by Chen Yiliang on 12/14/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "ViewController.h"
#import "CYPageSlideController.h"
#import "PageViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)tileButtonPressed:(id)sender {
    [self showPageSlideControllerWithStyle:CYPageSlideBarLayoutStyleTite numberOfControllers:3];
}

- (IBAction)orderButtonPressed:(id)sender {
    [self showPageSlideControllerWithStyle:CYPageSlideBarLayoutStyleNormal numberOfControllers:6];
}

- (void)showPageSlideControllerWithStyle:(CYPageSlideBarLayoutStyle)style numberOfControllers:(NSInteger)numberOfControllers {
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < numberOfControllers; i++) {
        PageViewController *controller = [[PageViewController alloc] initWithNibName:nil bundle:nil];
        controller.title = [NSString stringWithFormat:@"controller %d", i + 1];
        [viewControllers addObject:controller];
    }
    
    CYPageSlideController *slideController = [[CYPageSlideController alloc] initWithViewControllers:viewControllers barLayoutStyle:style];
    slideController.title = @"Page Slide Controller";
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:slideController];
    navController.navigationBar.translucent = NO;
    [self presentViewController:navController animated:YES completion:NULL];
}

@end
