//
//  ObjectiveCppViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 23/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "ObjectiveCppViewController.h"
#import "ObjectiveCppWrapper.h"
#include <memory>

@interface ObjectiveCppViewController ()

@end

@implementation ObjectiveCppViewController {
    // modern way to create instance variables
    std::shared_ptr<ObjectiveCppWrapper> _wrapper;
}

#pragma mark - Initialization

- (void)initializeViewController {
    [super initializeViewController];
    
    // 
    _wrapper = std::make_shared<ObjectiveCppWrapper>();
}

- (void)initializeViews {
    [super initializeViews];
}

- (void)initializeViewConstraints {
    [super initializeViewConstraints];
}

#pragma mark - Constraints

- (NSArray *)viewConstraints {
    return [NSLayoutConstraint constraintsWithVisualFormat:@""
                                                   options:0
                                                   metrics:nil
                                                     views:[self layoutViews]];
}

- (NSDictionary *)layoutViews {
    return nil;
}

#pragma mark - Control Panel

- (NSArray<PlayGroundControlAction *> *)controlPanelActions {
    return @[
             [[PlayGroundControlAction alloc] initWithName:@"Show Objective-C++ Alert"
                                                    target:self
                                                    action:@selector(showObjectiveCppAlert)]
             ];
}

- (void)showObjectiveCppAlert {
    _wrapper->showAlert(@"Objective-C++", @"Hello C++", self);
}

#pragma mark - Project

+ (NSString *)name {
    return @"Objective-C++ Playground";
}

+ (NSString *)desc {
    return @"Play with objective-c++ and objective c";
}

+ (NSString *)groupName {
    return ProjectGroupNameHybridProgramming;
}

+ (instancetype)projectViewController {
    return [self new];
}


@end
