//
//  ShowOffVIewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 20/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "ShowOffViewController.h"

@implementation ShowOffViewController

- (instancetype)initWithContentView:(UIView *)contentView {
    self = [super init];
    if (self) {
        _contentView = contentView;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    [self.view addSubviewWithoutAutoResizing:self.contentView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // to prevent unpredictable push effect, set background colour
    self.view.backgroundColor = [UIColor blackColor];
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[contentView]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:[self layoutViews]];
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[contentView]-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:[self layoutViews]];
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticalConstraints];
}

- (NSDictionary *)layoutViews {
    return @{
             @"contentView" : self.contentView
             };
}

@end
