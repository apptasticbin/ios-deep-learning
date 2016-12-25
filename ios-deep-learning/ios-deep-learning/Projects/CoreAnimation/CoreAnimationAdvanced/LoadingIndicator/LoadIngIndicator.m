//
//  LoadIngIndicator.m
//  ios-deep-learning
//
//  Created by Bin Yu on 25/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "LoadIngIndicator.h"

@interface LoadIngIndicator ()

@property (nonatomic, strong) UIColor *indicatorColor;

@end

@implementation LoadIngIndicator

- (instancetype)init
{
    self = [super init];
    if (self) {
        _indicatorColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSublayers {
    [super layoutSublayers];
    [self buildIndicator];
}

#pragma mark - Accessors

- (void)setLoading:(BOOL)loading {
    _loading = loading;
    [self startLoading:loading];
}

- (UIBezierPath *)indicatorPath {
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    CGPoint center = CGPointMake(width/2.0f, height/2.0f);
    CGFloat radius = MIN(width, height) / 2.0f;
    return [UIBezierPath bezierPathWithArcCenter:center
                                          radius:radius
                                      startAngle:0
                                        endAngle:M_PI_2
                                       clockwise:YES];
}

#pragma mark - Private

- (void)buildIndicator {
    self.lineWidth = 15.0f;
    self.lineCap = kCALineCapRound;
    self.strokeColor = self.indicatorColor.CGColor;
    self.path = [[self indicatorPath] CGPath];
}

- (void)startLoading:(BOOL)start {
    if (start) {
        /*  split the animation into two parts:
            - rotation around center
            - keyframe animation for strokeStart and strokeEnd properties
         */
        CFTimeInterval duration = 2.0f;
        
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.duration = duration;
        rotationAnimation.toValue = @(2 * M_PI);
        rotationAnimation.repeatCount = HUGE_VAL;
        
        CAKeyframeAnimation *strokeStartAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
        strokeStartAnimation.values = @[@(0), @(1), @(1), @(0)];
        strokeStartAnimation.keyTimes = @[@(0), @(0.47), @(0.52), @(1)];
        // here we SHOULD NOT use kCAAnimationPaced, because when we use kCAAnimationPaced, keyTimes doesn't effect the time function anymore.
//        strokeStartAnimation.calculationMode = kCAAnimationPaced;
        strokeStartAnimation.duration = 2 * duration;
        strokeStartAnimation.repeatCount = HUGE_VAL;
        
        [self addAnimation:rotationAnimation forKey:@"rotation"];
        [self addAnimation:strokeStartAnimation forKey:@"strokeStart"];
    } else {
//        self.transform = self.presentationLayer.transform;
//        self.strokeStart = self.presentationLayer.strokeStart;
        [self removeAllAnimations];
    }
}

@end
