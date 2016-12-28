//
//  BaseViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 27/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeViewController];
    [self initializeViewConstraints];
}

- (void)loadView {
    [super loadView];
    [self initializeViews];
}

#pragma mark - Initialization

- (void)initializeViewController {
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initializeViews {

}

- (void)initializeViewConstraints {

}

@end
