//
//  CAAdvancedViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 25/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "CAAdvancedViewController.h"
#import "LoadIngIndicator.h"

@interface CAAdvancedViewController ()

@property (nonatomic, strong) LoadIngIndicator *loadingIndicator;

@end

@implementation CAAdvancedViewController

#pragma mark - Initialization

- (void)initializeViews {
    [super initializeViews];
    
    _loadingIndicator = [LoadIngIndicator new];
    _loadingIndicator.frame = CGRectMake(50, 50, 100, 100);
    [self.view.layer addSublayer:_loadingIndicator];
}

#pragma mark - Control Panel

- (NSArray<PlayGroundControlAction *> *)controlPanelActions {
    return @[
             [[PlayGroundControlAction alloc] initWithName:@"Start Loading"
                                                    target:self
                                                    action:@selector(startLoading)],
             [[PlayGroundControlAction alloc] initWithName:@"End Loading"
                                                    target:self
                                                    action:@selector(endLoading)]
             ];
}

#pragma mark - Private

- (void)startLoading {
    self.loadingIndicator.loading = YES;
}

- (void)endLoading {
    self.loadingIndicator.loading = NO;
}

#pragma mark - Project

+ (NSString *)name {
    return @"Core Animation Advanced";
}

+ (NSString *)desc {
    return @"Implements advanced customized layer effects.";
}

+ (NSString *)groupName {
    return ProjectGroupNameCoreAnimation;
}

+ (instancetype)projectViewController {
    return [self new];
}


@end
