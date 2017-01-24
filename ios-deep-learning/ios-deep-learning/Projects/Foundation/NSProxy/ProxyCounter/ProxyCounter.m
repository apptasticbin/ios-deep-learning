//
//  ProxyCounter.m
//  ios-deep-learning
//
//  Created by Bin Yu on 24/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "ProxyCounter.h"

@interface ProxyCounter ()

@property (nonatomic, strong, readwrite) NumberCounter *numberCounter;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ProxyCounter

- (instancetype)init
{
    // here we don't call [super init], because NSProxy doesn't have init method.
    _numberCounter = [NumberCounter new];
    return self;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if (invocation.selector == @selector(setCount:)) {
        NSInteger newCount = 0;
        // argument 0 is 'self', and argument 1 is '_cmd'
        [invocation getArgument:&newCount atIndex:2];
        [self animateNumberCounterToCount:newCount >= 0 ? newCount : 0];
    } else {
        [invocation invokeWithTarget:self.numberCounter];
    }
}

- (void)animateNumberCounterToCount:(NSInteger)count {
    __weak id weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f repeats:YES block:^(NSTimer * _Nonnull timer) {
        // TODO: fix the 0 bug
        __strong ProxyCounter *strongSelf = weakSelf;
        if (strongSelf.numberCounter.count < count) {
            strongSelf.numberCounter.count += 1;
        } else if (strongSelf.numberCounter.count > count) {
            strongSelf.numberCounter.count -= 1;
        }else {
            [strongSelf.timer invalidate];
        }
    }];
}

- (nullable NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.numberCounter methodSignatureForSelector:sel];
}

@end
