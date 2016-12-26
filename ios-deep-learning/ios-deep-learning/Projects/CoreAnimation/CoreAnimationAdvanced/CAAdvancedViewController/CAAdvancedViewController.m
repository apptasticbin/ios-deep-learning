//
//  CAAdvancedViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 25/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "CAAdvancedViewController.h"
#import "LoadIngIndicator.h"
#import "NumberCounter.h"

@interface CAAdvancedViewController ()

@property (nonatomic, strong) LoadIngIndicator *loadingIndicator;
@property (nonatomic, strong) NumberCounter *numberCounter;

@end

@implementation CAAdvancedViewController

#pragma mark - Initialization

- (void)initializeViews {
    [super initializeViews];
    
    _loadingIndicator = [LoadIngIndicator new];
    _loadingIndicator.frame = CGRectMake(50, 50, 100, 100);
    [self.view.layer addSublayer:_loadingIndicator];
    
    _numberCounter = [NumberCounter new];
    _numberCounter.frame = CGRectMake(250, 50, 100, 100);
    [self.view.layer addSublayer:_numberCounter];
}

#pragma mark - Control Panel

- (NSArray<PlayGroundControlAction *> *)controlPanelActions {
    return @[
             [[PlayGroundControlAction alloc] initWithName:@"Start Loading"
                                                    target:self
                                                    action:@selector(startLoading)],
             [[PlayGroundControlAction alloc] initWithName:@"End Loading"
                                                    target:self
                                                    action:@selector(endLoading)],
             [[PlayGroundControlAction alloc] initWithName:@"Increase Number"
                                                    target:self
                                                    action:@selector(increaseNumber)],
             [[PlayGroundControlAction alloc] initWithName:@"Decrease Number"
                                                    target:self
                                                    action:@selector(decreaseNumber)]
             ];
}

#pragma mark - Private

- (void)startLoading {
    self.loadingIndicator.loading = YES;
}

- (void)endLoading {
    self.loadingIndicator.loading = NO;
}

- (void)increaseNumber {
    // Seems that it is impossible to override property setter of custom dynamic properties.
    // In order to achieve more control for the animation, we can add logic to the custom layer’s wrapper,
    // like UIView or parent layer.
    self.numberCounter.subtype = kCATransitionFromTop;
    self.numberCounter.count += 1;
}

- (void)decreaseNumber {
    if (self.numberCounter.count > 0) {
        self.numberCounter.subtype = kCATransitionFromBottom;
        self.numberCounter.count -= 1;
    }
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
