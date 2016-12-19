//
//  CorGraphicsPlayGroundViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 18/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "CustomUIViewController.h"
#import "SimpleRoundButton.h"
#import "MaskedButton.h"

@interface CustomUIViewController ()

@property (nonatomic, strong) SimpleRoundButton *roundButton;
@property (nonatomic, strong) MaskedButton *maskedButton;

@end

@implementation CustomUIViewController

- (void)initializeViews {
    [super initializeViews];
    [self initializeRoundButton];
    [self initializeMaskedButton];
}

- (void)initializeRoundButton {
    _roundButton = [SimpleRoundButton new];
    [_roundButton addTarget:self
                     action:@selector(simpleRoundButtonClicked)
           forControlEvents:UIControlEventTouchUpInside];
    [self.playStage addSubviewWithoutAutoResizing:_roundButton];
}

- (void)initializeMaskedButton {
    _maskedButton = [MaskedButton new];
    _maskedButton.backgroundColor = [UIColor redColor];
    _maskedButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [_maskedButton setTitle:@"Masked Button" forState:UIControlStateNormal];
    [_maskedButton setTitle:@"Hello!" forState:UIControlStateHighlighted];
    [self.playStage addSubviewWithoutAutoResizing:_maskedButton];
}

- (void)initializeViewConstraints {
    [super initializeViewConstraints];
    [self.playStage addConstraints:[self roundButtonHorizontalConstraints]];
    [self.playStage addConstraints:[self roundButtonVerticalConstraints]];
    [self.playStage addConstraints:[self maskedButtonHorizontalConstraints]];
    [self.maskedButton addConstraints:[self maskedButtonVerticalConstraints]];
}

#pragma mark - Constraints

- (NSArray *)roundButtonHorizontalConstraints {
    return [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[roundButton(70)]"
                                                   options:0
                                                   metrics:0
                                                     views:[self layoutViews]];
}

- (NSArray *)roundButtonVerticalConstraints {
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[roundButton(70)]"
                                                   options:0
                                                   metrics:0
                                                     views:[self layoutViews]];
}

- (NSArray *)maskedButtonHorizontalConstraints {
    return [NSLayoutConstraint constraintsWithVisualFormat:@"H:[roundButton]-40-[maskedButton(140)]"
                                                   options:NSLayoutFormatAlignAllCenterY
                                                   metrics:0
                                                     views:[self layoutViews]];
}

- (NSArray *)maskedButtonVerticalConstraints {
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:[maskedButton(60)]"
                                                   options:0
                                                   metrics:0
                                                     views:[self layoutViews]];
}

#pragma mark - Private

- (NSDictionary *)layoutViews {
    return @{
             @"roundButton" : self.roundButton,
             @"maskedButton" : self.maskedButton
             };
}

- (void)simpleRoundButtonClicked {
    NSLog(@"[DEBUG] simple round button clicked");
}

#pragma mark - Project

+ (NSString *)name {
    return @"Custom UI";
}

+ (NSString *)desc {
    return @"Try to custom UIViews by Core Graphics";
}

+ (NSString *)groupName {
    return ProjectGroupNameCoreGraphics;
}

+ (instancetype)projectViewController {
    return [self new];
}

@end
