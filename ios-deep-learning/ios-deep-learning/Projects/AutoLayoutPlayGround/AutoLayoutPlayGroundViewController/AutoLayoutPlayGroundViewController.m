//
//  AutoLayoutPlayGroundViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 10/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "AutoLayoutPlayGroundViewController.h"
#import "ProjectGroupNames.h"

@interface AutoLayoutPlayGroundViewController ()

@end

@implementation AutoLayoutPlayGroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Project

+ (NSString *)name {
    return @"Auto Layout Play Ground";
}

+ (NSString *)desc {
    return @"Try to deep understand how exactly Auto Layout works.";
}

+ (NSString *)groupName {
    return ProjectGroupNameAutoLayout;
}

+ (__kindof UIViewController *)projectViewController {
    return [AutoLayoutPlayGroundViewController new];
}

@end
