//
//  IntransicContentSizeViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 14/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "IntransicContentSizeViewController.h"
#import "CustomIntransicRect.h"

@interface IntransicContentSizeViewController ()

@property (nonatomic, strong) CustomIntransicRect *customRect;

@end

@implementation IntransicContentSizeViewController

- (void)initializeViews {
    [super initializeViews];
    _customRect = [CustomIntransicRect rectWithColor:[UIColor redColor] name:@"Custom Rect"];
    [self.playStage addSubviewWithoutAutoResizing:self.customRect];
}

- (void)initializeViewConstraints {
    [super initializeViewConstraints];
    NSArray *centerConstraints = [NSLayoutConstraint constraintsForCenterView:self.customRect
                                                                       inView:self.playStage];
    [self.playStage addConstraints:centerConstraints];
}

#pragma mark - Private

- (NSArray<PlayGroundControlAction *> *)controlPanelActions {
    return @[
             [[PlayGroundControlAction alloc] initWithName:@"Change Custom View Width"
                                                    target:self
                                                    action:@selector(changeCustomViewWidth)],
             [[PlayGroundControlAction alloc] initWithName:@"Change Custom View Content Margin"
                                                    target:self
                                                    action:@selector(changeCustomViewContentMargin)],
             ];
}

- (void)changeCustomViewWidth {
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.customRect
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:300];
    [UIView animateWithDuration:1.0f animations:^{
        [self.customRect addConstraint:widthConstraint];
        [self.customRect layoutIfNeeded];
    }];
}

- (void)changeCustomViewContentMargin {
    self.customRect.contentMargin = UIEdgeInsetsMake(20.0, 40.0, 30.0, 50.0);
    [UIView animateWithDuration:1.0f animations:^{
        [self.customRect invalidateIntrinsicContentSize];
        [self.playStage layoutIfNeeded];
    }];
}

#pragma mark - Project

+ (NSString *)name {
    return @"Custom View Intransic Content Size";
}

+ (NSString *)desc {
    return @"Try to deeply understand how exactly intransic content size works for custom views.";
}

+ (NSString *)groupName {
    return ProjectGroupNameAutoLayout;
}

+ (instancetype)projectViewController {
    return [self new];
}


@end
