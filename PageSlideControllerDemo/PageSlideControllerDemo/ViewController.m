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

- (IBAction)buttonPressed:(id)sender {
    PageViewController *controller1 = [[PageViewController alloc] initWithNibName:nil bundle:nil];
    controller1.title = @"controller 1";
//    controller1.pageSlideBarItem = 
    PageViewController *controller2 = [[PageViewController alloc] initWithNibName:nil bundle:nil];
    controller2.title = @"controller 2";
    
    CYPageSlideController *slideController = [[CYPageSlideController alloc] initWithViewControllers:@[controller1, controller2] barLayoutStyle:CYPageSlideBarLayoutStyleTite];
    [self presentViewController:slideController animated:YES completion:NULL];
}

@end
