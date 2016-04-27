//
//  ViewController.m
//  AppSwitcherBlur
//
//  Created by Nikolay Korotkov on 27/04/16.
//  Copyright © 2016 Nikolay Korotkov. All rights reserved.
//

#import "ViewController.h"
#import "NKAppBlurManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NKAppBlurManager sharedManager] setAutoBlurEnabled:YES];
    
//    uncomment these two lines to set custom blur radius or tint color.
    
//    [[NKAppBlurManager sharedManager] setBlurRadius:5];
//    [[NKAppBlurManager sharedManager] setTintColor:[[UIColor blueColor] colorWithAlphaComponent:0.2]];
    
}

- (IBAction)_action:(id)sender {
    NKAppBlurManager *manager = [NKAppBlurManager sharedManager];
    [manager setAutoBlurEnabled:!manager.autoBlurEnabled];
    [((UIButton *)sender) setTitle:manager.autoBlurEnabled ? @"Enabled" : @"Disabled" forState:UIControlStateNormal];
}

@end
