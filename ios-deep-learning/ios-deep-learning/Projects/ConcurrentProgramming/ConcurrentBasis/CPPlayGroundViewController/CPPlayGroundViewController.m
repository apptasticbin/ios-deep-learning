//
//  CPPlayGroundViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 03/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "CPPlayGroundViewController.h"
#import "CPOperation.h"
#import "CPThread.h"

// expose private property as protected property
@interface KVOPlayGroundViewController (Protected)

@property (nonatomic, assign) NSInteger number;

@end

@interface CPPlayGroundViewController ()

// because thread can not be restarted, so we keep running thread.
@property (nonatomic, strong) CPThread *currentThread;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CPOperation *currentOperation;

@end

@implementation CPPlayGroundViewController

#pragma mark - Control Panel

- (NSArray<PlayGroundControlAction *> *)controlPanelActions {
    return @[
             [[PlayGroundControlAction alloc] initWithName:@"Count by NSThread"
                                                    target:self
                                                    action:@selector(countByNSThread)],
             [[PlayGroundControlAction alloc] initWithName:@"Count by GCD"
                                                    target:self
                                                    action:@selector(countByGCD)],
             [[PlayGroundControlAction alloc] initWithName:@"Count by NSOperation"
                                                    target:self
                                                    action:@selector(countByNSOperation)],
             [[PlayGroundControlAction alloc] initWithName:@"Reset Counter"
                                                    target:self
                                                    action:@selector(resetCounter)]
             ];
}

- (void)countByNSThread {
    if (self.currentThread && self.currentThread.isExecuting) {
        [self.currentThread cancel];
        self.currentThread = nil;
    } else {
        self.currentThread = [self thread];
        [self.currentThread start];
    }
}

- (void)countByGCD {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    } else {
        // get week pointer
        __weak id weakSelf = self;
        // run something on global queue, and update UI on main queue
        dispatch_after(DISPATCH_TIME_NOW, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Timer MUST work with runloop. But the thread created by CGD doesn't have runloop attached.
            // create a runloop
            NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
            // strong weak pointer
            CPPlayGroundViewController *strongSelf = weakSelf;
            strongSelf.timer =
            [NSTimer scheduledTimerWithTimeInterval:0.5f
                                            repeats:YES
                                              block:^(NSTimer * _Nonnull timer) {
                                                  // update UI on main thread
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      strongSelf.number += 1;
                                                  });
                                              }];
            // add timer to runloop
            [runLoop addTimer:strongSelf.timer forMode:NSDefaultRunLoopMode];
            // run the runloop forever.
            [runLoop run];
            [strongSelf.timer fire];
        });
    }
}

- (void)countByNSOperation {
    if (self.currentOperation && self.currentOperation.isExecuting) {
        [self.currentOperation cancel];
        self.currentOperation = nil;
    } else {
        self.currentOperation = [self operation];
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperation:self.currentOperation];
    }
}

- (void)resetCounter {
    self.number = 0;
}

- (CPThread *)thread {
    CPThread *thread = [CPThread new];
    __weak CPPlayGroundViewController *weakSelf = self;
    thread.tickBlock = ^() {
        weakSelf.number += 1;
    };
    return thread;
}

- (CPOperation *)operation {
    CPOperation *operation = [CPOperation new];
    __weak CPPlayGroundViewController *weakSelf = self;
    operation.tickBlock = ^() {
        weakSelf.number += 1;
    };
    return operation;
}

#pragma mark - Project

+ (NSString *)name {
    return @"Cooncurrent Playground";
}

+ (NSString *)desc {
    return @"NSThread, GCD, NSOperationQueue, and NSRunLoop";
}

+ (NSString *)groupName {
    return ProjectGroupNameConcurrentProgramming;
}

+ (instancetype)projectViewController {
    return [self new];
}


@end
