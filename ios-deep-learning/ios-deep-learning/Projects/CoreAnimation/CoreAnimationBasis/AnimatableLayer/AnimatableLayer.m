//
//  AnimatableLayer.m
//  ios-deep-learning
//
//  Created by Bin Yu on 22/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "AnimatableLayer.h"

@interface AnimatableLayer ()

@property (nonatomic, assign) BOOL isRect;

@end

@implementation AnimatableLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isRect = YES;
    }
    return self;
}

#pragma mark - Public

- (void)changeShape {
    // since path property IS animatable, but no implicit animation
    // so we animate it with explicit animation
    UIBezierPath *toPath = self.isRect ? [self circleShapePath] : [self rectShapePath];
    self.path = [toPath CGPath];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.toValue = toPath;
    pathAnimation.duration = 1.0;
    pathAnimation.fillMode = kCAFillModeBoth;
    
    [self addAnimation:pathAnimation forKey:@"path"];
    
    self.isRect = !self.isRect;
}

#pragma mark - Private

- (void)layoutSublayers {
    [super layoutSublayers];
    // setup path after layer has layout information
    [self setupPath];
}

- (void)setupPath {
    CGColorRef strokeColor = [[UIColor whiteColor] CGColor];
    self.strokeColor = strokeColor;
    self.lineWidth = 3.0f;
    [self changeShape];
}

- (UIBezierPath *)rectShapePath {
    CGRect pathRect = CGRectInset(self.bounds, 20.0f, 20.0f);
    return [UIBezierPath bezierPathWithRect:pathRect];
}

- (UIBezierPath *)circleShapePath {
    CGRect pathRect = CGRectInset(self.bounds, 20.0f, 20.0f);
    return [UIBezierPath bezierPathWithOvalInRect:pathRect];
}

@end
