//
//  MethodSwizzlingViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 23/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "MethodSwizzlingViewController.h"
#import "SwizzlingRect.h"

@interface MethodSwizzlingViewController ()

@property (nonatomic, strong) SwizzlingRect *swizzlingRect;

@end

@implementation MethodSwizzlingViewController

#pragma mark - Initialization

- (void)initializeViewController {
    [super initializeViewController];
}

- (void)initializeViews {
    [super initializeViews];
    
    _swizzlingRect = [SwizzlingRect blueRect];
    [self.playStage addSubviewWithoutAutoResizing:_swizzlingRect];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _swizzlingRect.frame = CGRectMake(100, 100, 150, 150);
}

#pragma mark - Control Panel

- (NSArray<PlayGroundControlAction *> *)controlPanelActions {
    return @[
             [[PlayGroundControlAction alloc] initWithName:@"Shake Shake"
                                                    target:self
                                                    action:@selector(shake)],
             ];
}

- (void)shake {
    [self.swizzlingRect shake];
}

#pragma mark - Project

+ (NSString *)name {
    return @"Method Swizzling";
}

+ (NSString *)desc {
    return @"Try method swizzling by using objective-c runtime features";
}

+ (NSString *)groupName {
    return ProjectGroupNameObjectiveCRuntime;
}

+ (instancetype)projectViewController {
    return [self new];
}


@end
