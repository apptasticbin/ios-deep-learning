//
//  KVOPlayGroundViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 30/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "KVOPlayGroundViewController.h"
#import "NumberCounter.h"

static int /*const*/ KVOContext;

@interface KVOPlayGroundViewController ()

@property (nonatomic, strong) NumberCounter *digitsCounter;
@property (nonatomic, strong) NumberCounter *tensCounter;

@property (nonatomic, assign) NSInteger digits;
@property (nonatomic, assign) NSInteger tens;
@property (nonatomic, assign) NSInteger number;

@end

@implementation KVOPlayGroundViewController

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (self) {
        _digits = 0;
        _tens = 0;
        
        [self addObserver:self forKeyPath:@"digits" options:NSKeyValueObservingOptionNew context:&KVOContext];
        
        [self addObserver:self forKeyPath:@"tens" options:NSKeyValueObservingOptionNew context:&KVOContext];
    }
    return self;
}

- (void)dealloc {
    // remove oberver
    [self removeObserver:self forKeyPath:@"digits"];
    [self removeObserver:self forKeyPath:@"tens"];
}

- (void)initializeViews {
    [super initializeViews];
    
    _digitsCounter = [NumberCounter new];
    _digitsCounter.frame = CGRectMake(200, 100, 100, 100);
    [self.playStage.layer addSublayer:_digitsCounter];
    
    _tensCounter = [NumberCounter new];
    _tensCounter.frame = CGRectMake(70, 100, 100, 100);
    [self.playStage.layer addSublayer:_tensCounter];
}

#pragma mark - Control Panel

- (NSArray<PlayGroundControlAction *> *)controlPanelActions {
    return @[
             [[PlayGroundControlAction alloc] initWithName:@"Increase 2"
                                                    target:self
                                                    action:@selector(increase2)],
             [[PlayGroundControlAction alloc] initWithName:@"Decrease 2"
                                                    target:self
                                                    action:@selector(decrease2)]
             ];
}

- (void)increase2 {
    self.number += 2;
}

- (void)decrease2 {
    if (self.number >= 2) {
        self.number -= 2;
    }
}

#pragma mark - KVO

// setup dependancies
+ (NSSet *)keyPathsForValuesAffectingTens {
    return [NSSet setWithObject:@"number"];
}

+ (NSSet *)keyPathsForValuesAffectingDigits {
    return [NSSet setWithObject:@"number"];
}

- (NSInteger)digits {
    return self.number % 10;
}

- (NSInteger)tens {
    return self.number / 10;
}

- (void)setNumber:(NSInteger)number {
    if (_number == number) {
        return;
    }
    [self willChangeValueForKey:@"number"];
    _number = number;
    [self didChangeValueForKey:@"number"];
}

+ (BOOL)automaticallyNotifiesObserversOfNumber {
    return NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == &KVOContext) {
        NSInteger newValue = [change[NSKeyValueChangeNewKey] integerValue];
        if ([keyPath isEqualToString:@"digits"]) {
            self.digitsCounter.count = newValue;
        }
        if ([keyPath isEqualToString:@"tens"]) {
            self.tensCounter.count = newValue;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Project

+ (NSString *)name {
    return @"KVO Playground";
}

+ (NSString *)desc {
    return @"Deeply understand key-value observing mechanism.";
}

+ (NSString *)groupName {
    return ProjectGroupNameKeyValueProgramming;
}

+ (instancetype)projectViewController {
    return [self new];
}


@end
