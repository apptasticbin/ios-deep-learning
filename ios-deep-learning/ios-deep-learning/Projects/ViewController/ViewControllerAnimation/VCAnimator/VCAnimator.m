//
//  AnimationController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 26/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "VCAnimator.h"

@implementation VCAnimator

- (instancetype)init
{
    self = [super init];
    if (self) {
        _presenting = YES;
        _originRect = CGRectZero;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 2.0f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (self.presenting) {
        [self presentAnimation:transitionContext];
    } else {
        [self dismissAnimation:transitionContext];
    }
}

#pragma mark - Private

- (void)presentAnimation:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = transitionContext.containerView;
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    CGRect startFrame = self.originRect;
    CGRect endFrame = toView.frame;
    
    // because we want to expend the view. here we use scale transform
    CGFloat xScaleFactor = CGRectGetWidth(startFrame) / CGRectGetWidth(endFrame);
    CGFloat yScaleFactor = CGRectGetHeight(startFrame) / CGRectGetHeight(endFrame);
    
    toView.center = CGPointMake(CGRectGetMidX(startFrame), CGRectGetMidY(startFrame));
    toView.transform = CGAffineTransformScale(toView.transform, xScaleFactor, yScaleFactor);
    toView.clipsToBounds = YES;
    
    [containerView addSubview:toView];
    [containerView bringSubviewToFront:toView];
    
    [UIView animateWithDuration:2.0f
                          delay:0
         usingSpringWithDamping:0.4
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         toView.transform = CGAffineTransformIdentity;
                         toView.center = CGPointMake(CGRectGetMidX(endFrame), CGRectGetMidY(endFrame));
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}

- (void)dismissAnimation:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = transitionContext.containerView;
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    CGRect startFrame = fromView.frame;
    CGRect endFrame= self.originRect;
    
    CGFloat xScaleFactor = CGRectGetWidth(endFrame) / CGRectGetWidth(startFrame);
    CGFloat yScaleFactor = CGRectGetHeight(endFrame) / CGRectGetHeight(startFrame);
    
    [containerView addSubview:toView];
    [containerView bringSubviewToFront:fromView];
    
    [UIView animateWithDuration:2.0f
                          delay:0
         usingSpringWithDamping:0.4
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         fromView.transform = CGAffineTransformScale(fromView.transform, xScaleFactor, yScaleFactor);
                         fromView.center = CGPointMake(CGRectGetMidX(endFrame), CGRectGetMidY(endFrame));
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

@end
