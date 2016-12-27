//
//  VCAnimationPlayGroundViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 26/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "VCAnimationPlayGroundViewController.h"
#import "VCAnimationPopViewController.h"
#import "VCAnimator.h"

@interface VCAnimationPlayGroundViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, readwrite, strong) PlayRect *blueRect;
@property (nonatomic, strong) VCAnimator *animator;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveAnimationController;
@property (nonatomic, assign) CGRect originRect;
@property (nonatomic, strong) VCAnimationPopViewController *popViewController;

@end

@implementation VCAnimationPlayGroundViewController

#pragma mark - Initialization

- (void)initializeViews {
    [super initializeViews];
    
    _blueRect = [PlayRect blueRect];
    _blueRect.frame = CGRectMake(70, 70, 200, 250);
    [self.playStage addSubviewWithoutAutoResizing:_blueRect];
}

#pragma mark - Control Panel

- (NSArray<PlayGroundControlAction *> *)controlPanelActions {
    return @[
             [[PlayGroundControlAction alloc] initWithName:@"Pop!"
                                                    target:self
                                                    action:@selector(pop)]
             ];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.animator.presenting = YES;
    self.animator.originRect = self.originRect;
//    self.blueRect.hidden = YES;
    return self.animator;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.animator.presenting = NO;
    return self.animator;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    if (self.interactiveAnimationController) {
        return self.interactiveAnimationController;
    }
    return nil;
}

#pragma mark - Private

- (VCAnimator *)animator {
    if (!_animator) {
        _animator = [VCAnimator new];
    }
    return _animator;
}

- (CGRect)originRect {
    // convert the frame of blueRect from superview coordinate to window coordinate
    return [self.blueRect.superview convertRect:self.blueRect.frame toView:nil];
}

- (void)pop {
    UIPanGestureRecognizer *panGuestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    self.popViewController = [VCAnimationPopViewController new];
    self.popViewController.transitioningDelegate = self;
    [self.popViewController.view addGestureRecognizer:panGuestureRecognizer];
    [self presentViewController:self.popViewController animated:YES completion:nil];
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.interactiveAnimationController = [UIPercentDrivenInteractiveTransition new];
        [self.popViewController dismissViewControllerAnimated:YES completion:nil];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if (self.interactiveAnimationController.percentComplete < 0.1f) {
            CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
            // because (0.1f) 10% is the animation patition before spring effect.
            CGFloat percentage = fabs(translation.y / CGRectGetHeight(gestureRecognizer.view.bounds) * 0.1f);
            [self.interactiveAnimationController updateInteractiveTransition:percentage];
        } else {
            [self.interactiveAnimationController finishInteractiveTransition];
        }
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (self.interactiveAnimationController.percentComplete < 0.1f) {
            [self.interactiveAnimationController cancelInteractiveTransition];
        } else {
            [self.interactiveAnimationController finishInteractiveTransition];
        }
        // remember to clear the interactive animator
        self.interactiveAnimationController = nil;
    }
    
}

#pragma mark - Project

+ (NSString *)name {
    return @"View Controller Animation Play Ground";
}

+ (NSString *)desc {
    return @"Try to play with customized view controller animation.";
}

+ (NSString *)groupName {
    return ProjectGroupNameViewController;
}

+ (instancetype)projectViewController {
    return [self new];
}


@end
