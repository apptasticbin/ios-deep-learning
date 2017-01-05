//
//  CPThread.m
//  ios-deep-learning
//
//  Created by Bin Yu on 03/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "CPThread.h"

@implementation CPThread

- (void)main {
    while (!self.isCancelled) {
        [self performSelectorOnMainThread:@selector(sendTickEvent) withObject:nil waitUntilDone:YES];
        [NSThread sleepForTimeInterval:0.5f];
    }
    [NSThread exit];
}

- (void)sendTickEvent {
    if (self.tickBlock) {
        self.tickBlock();
    }
}

@end
