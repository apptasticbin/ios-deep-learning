//
//  ProxyPlayGroundViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 24/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "ProxyPlayGroundViewController.h"
#import "ProxyCounter.h"

@interface ProxyPlayGroundViewController ()

@property (nonatomic, strong) ProxyCounter *proxyCounter;

@end

@implementation ProxyPlayGroundViewController

#pragma mark - Initialization

- (void)initializeViews {
    [super initializeViews];
    
    _proxyCounter = [[ProxyCounter alloc] init];
    _proxyCounter.numberCounter.frame = CGRectMake(100, 100, 200, 200);
    [self.playStage.layer addSublayer:_proxyCounter.numberCounter];
}

#pragma mark - Control Panel

- (NSArray<PlayGroundControlAction *> *)controlPanelActions {
    return @[
             [[PlayGroundControlAction alloc] initWithName:@"+10"
                                                    target:self
                                                    action:@selector(addTen)],
             [[PlayGroundControlAction alloc] initWithName:@"-10"
                                                    target:self
                                                    action:@selector(minusTen)]
             ];
}

- (void)addTen {
    id proxy = self.proxyCounter;
    [proxy setCount:self.proxyCounter.numberCounter.count+10];
}

- (void)minusTen {
    id proxy = self.proxyCounter;
    [proxy setCount:self.proxyCounter.numberCounter.count-10];
}

#pragma mark - Project

+ (NSString *)name {
    return @"Proxy Counter";
}

+ (NSString *)desc {
    return @"Using NSProxy to create animated number counter.";
}

+ (NSString *)groupName {
    return ProjectGroupNameFoundation;
}

+ (instancetype)projectViewController {
    return [self new];
}


@end
