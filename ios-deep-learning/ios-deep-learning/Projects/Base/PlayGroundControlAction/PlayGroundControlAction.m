//
//  PlayGroundControlAction.m
//  ios-deep-learning
//
//  Created by Bin Yu on 12/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "PlayGroundControlAction.h"

@implementation PlayGroundControlAction

- (instancetype)initWithName:(NSString *)name target:(id)target action:(SEL)action {
    self = [super init];
    if (self) {
        _name = name;
        _target = target;
        _action = action;
    }
    return self;
}

- (void)run {
    if (self.target && self.action && [self.target respondsToSelector:self.action]) {
        [self.target performSelector:self.action];
    }
}

@end
