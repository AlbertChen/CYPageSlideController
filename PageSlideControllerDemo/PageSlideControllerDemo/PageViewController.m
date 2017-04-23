//
//  PageViewController.m
//  PageSlideControllerDemo
//
//  Created by Chen Yiliang on 12/15/16.
//  Copyright © 2016 Chen Yiliang. All rights reserved.
//

#import "PageViewController.h"

@interface PageViewController ()

@property (nonatomic, weak) IBOutlet UILabel *label;

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.label.text = self.title;
}

- (IBAction)dismissButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
