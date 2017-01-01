//
//  EHRect.m
//  ios-deep-learning
//
//  Created by Bin Yu on 01/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "EHRect.h"

@implementation EHRect

- (void)shake {
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    shakeAnimation.values = @[@(-10), @(10), @(-10), @(10), @(-10), @(0)];
    shakeAnimation.keyTimes = @[@(0), @(0.2), @(0.4), @(0.6), @(0.8), @(1)];
    shakeAnimation.additive = YES;
    shakeAnimation.duration = 1.0f;
    [self.layer addAnimation:shakeAnimation forKey:@"ShakeAnimation"];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - Hit Test and Touch Event

- (nullable UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    Mark;
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView) {
        NSLog(@"Hit View: %@", hitView);
    }
    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return [super pointInside:point withEvent:event];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // MUST call super
    // call super method to propragate the event to super view.
    // if we ONLY want the event to be handled in this view, don't call super method.
//    [super touchesBegan:touches withEvent:event];
    Mark;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    Mark;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    Mark;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.name];
}

@end
