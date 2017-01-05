//
//  CPOperation.m
//  ios-deep-learning
//
//  Created by Bin Yu on 03/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "CPOperation.h"

@interface CPOperation ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation CPOperation

- (void)main {
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    self.timer =
    [NSTimer scheduledTimerWithTimeInterval:0.5f
                                    repeats:YES
                                      block:^(NSTimer * _Nonnull timer) {
                                          if (self.tickBlock) {
                                              self.tickBlock();
                                          }
                                      }];
    [runLoop addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [self.timer fire];
    
    // when we want to cancel a runloop, we can use a while loop to control the runloop
    while (!self.isCancelled) {
        [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    // after runloop stopping, we invalidate the timer before the end of main method.
    [self.timer invalidate];
}

@end
