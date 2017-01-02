//
//  NSLayoutConstraint+Helper.m
//  ios-deep-learning
//
//  Created by Bin Yu on 14/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "NSLayoutConstraint+Helper.h"

@implementation NSLayoutConstraint (Helper)

+ (NSArray<NSLayoutConstraint *> *)constraintsForCenterView:(UIView *)subview inView:(UIView *)superView {
    NSLayoutConstraint *centerXConstriant = [self constraintWithItem:subview
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:superView
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1.0f
                                                            constant:0];
    
    NSLayoutConstraint *centerYConstriant = [self constraintWithItem:subview
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:superView
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1.0f
                                                            constant:0];
    return @[centerXConstriant, centerYConstriant];
}

+ (NSArray<NSLayoutConstraint *> *)constraintsToFitSuperView:(UIView *)subview {
    NSDictionary *layoutViews = @{
                                  @"subview" : subview,
                                  };
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subview]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:layoutViews];
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subview]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:layoutViews];
    return [horizontalConstraints arrayByAddingObjectsFromArray:verticalConstraints];
}

@end
