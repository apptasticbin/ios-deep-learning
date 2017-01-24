//
//  SwizzlingRect.m
//  ios-deep-learning
//
//  Created by Bin Yu on 23/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "SwizzlingRect.h"

@implementation SwizzlingRect

- (void)shake {
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    shakeAnimation.values = @[@(0), @(10), @(-10), @(10), @(0)];
    shakeAnimation.keyTimes = @[@(0), @(1.0f/6.0f), @(3.0/6.0f), @(5.0/6.0f), @(1)];
    shakeAnimation.additive = YES;  // add values to current "render tree" value
    shakeAnimation.duration = 0.5f;
    [self.layer addAnimation:shakeAnimation forKey:@"shakeAnimation"];
}

@end
