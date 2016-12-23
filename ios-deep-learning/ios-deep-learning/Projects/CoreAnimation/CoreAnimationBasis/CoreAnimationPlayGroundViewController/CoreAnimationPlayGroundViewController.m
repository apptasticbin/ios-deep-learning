//
//  CoreAnimationPlayGroundViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 21/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "CoreAnimationPlayGroundViewController.h"
#import "AnimatableLayer.h"

typedef NS_ENUM(NSInteger, MoveDirection) {
    Up,
    Down,
    Left,
    Right
};

@interface CoreAnimationPlayGroundViewController ()

// implicit animatation is disabled the layer created by UIView.
// only layer created by us can do implicit animation
@property (nonatomic, strong) AnimatableLayer *animatableLayer;

@end

@implementation CoreAnimationPlayGroundViewController

#pragma mark - Initialization

- (void)initializeViews {
    [super initializeViews];
    _animatableLayer = [AnimatableLayer layer];
    
    // in this project, we can not use auto layout for CALayer
    CGRect startRect = CGRectMake(50, 50, 100, 100);
    _animatableLayer.frame = startRect;
    _animatableLayer.backgroundColor = [self randomCGColor];
    
    [self.view.layer addSublayer:_animatableLayer];
}

#pragma mark - Control Panel

- (NSArray<PlayGroundControlAction *> *)controlPanelActions {
    return @[
             [[PlayGroundControlAction alloc] initWithName:@"Move Left"
                                                    target:self
                                                    action:@selector(moveLeft)],
             [[PlayGroundControlAction alloc] initWithName:@"Move Right"
                                                    target:self
                                                    action:@selector(moveRight)],
             [[PlayGroundControlAction alloc] initWithName:@"Move Up"
                                                    target:self
                                                    action:@selector(moveUp)],
             [[PlayGroundControlAction alloc] initWithName:@"Move Down"
                                                    target:self
                                                    action:@selector(moveDown)],
             [[PlayGroundControlAction alloc] initWithName:@"Shake Me~"
                                                    target:self
                                                    action:@selector(shake)]
             ];
}

- (void)moveLeft {
    [self move:Left];
}

- (void)moveRight {
    [self move:Right];
}

- (void)moveUp {
    [self move:Up];
}

- (void)moveDown {
    [self move:Down];
}

- (void)shake {
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    shakeAnimation.values = @[@(0), @(10), @(-10), @(10), @(0)];
    shakeAnimation.keyTimes = @[@(0), @(1.0f/6.0f), @(3.0/6.0f), @(5.0/6.0f), @(1)];
    shakeAnimation.additive = YES;  // add values to current "render tree" value
    shakeAnimation.duration = 0.5f;
    [self.animatableLayer addAnimation:shakeAnimation forKey:@"shakeAnimation"];
}

#pragma mark - Private

- (void)move:(MoveDirection)direction {
    NSInteger moveDistance = 30.0f;
    switch (direction) {
        case Up: {
            // CATransaction can make operation to "multiple-layers" at the same time
            // CAAnimation is only for one layer each time
            [CATransaction begin];
            [CATransaction setAnimationDuration:1.0f];
            
            CGPoint endPoint = self.animatableLayer.position;
            endPoint.y -= moveDistance;
            self.animatableLayer.position = endPoint;
            
            CGRect bounds = self.animatableLayer.bounds;
            // nest transaction
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.5f];
            self.animatableLayer.bounds = CGRectInset(bounds, 3.0f, 3.0f);
            [CATransaction commit];
            
            [CATransaction commit];
            break;
        }
        case Down: {
            // create path
            CGFloat offset = 20.0f;
            CGPoint startPoint = self.animatableLayer.position;
            CGPoint endPoint = CGPointMake(startPoint.x, startPoint.y + 2 * moveDistance);
            CGPoint controlPoint1 = CGPointMake(startPoint.x - offset, startPoint.y + moveDistance / 2);
            CGPoint controlPoint2 = CGPointMake(startPoint.x + offset, startPoint.y + 3 * moveDistance / 2);
            
            UIBezierPath *snakePath = [UIBezierPath bezierPath];
            [snakePath moveToPoint:startPoint];
            [snakePath addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
            
            self.animatableLayer.position = endPoint;
            
            // move down along a path by using CAKeyframeAnimation and path
            CAKeyframeAnimation *snakePathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            snakePathAnimation.path = snakePath.CGPath;
            snakePathAnimation.duration = 1.5f;
            /*
              kCAAnimationPaced gives a linearly interpolated animation, but keyTimes and timingFunction are
              ignored and keyframe times are automatically generated to give the animation a constant velocity.
             */
            snakePathAnimation.calculationMode = kCAAnimationPaced;
            // rotation mode can control the rotation of layer along the path
//            snakePathAnimation.rotationMode = kCAAnimationRotateAuto;
            
            [self.animatableLayer addAnimation:snakePathAnimation forKey:@"snakePathAnimation"];
            
            break;
        }
        case Left: {
            // using Core Animation
            CGPoint oldPosition = self.animatableLayer.position;
            CGPoint newPosition = oldPosition;
            newPosition.x -= moveDistance;
            
            // IMPORTANT: not like implicit animation, the explicit animation DOES NOT change the property value.
            // so we MUST change the value ourselves.
            self.animatableLayer.position = newPosition;
            
            CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
            positionAnimation.fromValue = [NSValue valueWithCGPoint:oldPosition];
            positionAnimation.toValue = [NSValue valueWithCGPoint:newPosition];
            positionAnimation.duration = 1.0f;
            positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            
            // make 3D transformation
            CATransform3D oldTransform = self.animatableLayer.transform;
            // flipping the layer
            CATransform3D newTransform = CATransform3DRotate(oldTransform, M_PI_4, 0, 0, 1);
            
            self.animatableLayer.transform = newTransform;
            
            CASpringAnimation *transformAnimation = [CASpringAnimation animationWithKeyPath:@"transform"];
            transformAnimation.fromValue = [NSValue valueWithCATransform3D:oldTransform];
            transformAnimation.toValue = [NSValue valueWithCATransform3D:newTransform];
            transformAnimation.initialVelocity = -20.0f;
            transformAnimation.duration = 2.5f;
            
            CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
            animationGroup.animations = @[positionAnimation, transformAnimation];
            // animation group duration SHOULD greater than the maximum duration among the animations.
            animationGroup.duration = 2.5f;
            
            [self.animatableLayer addAnimation:animationGroup forKey:@"groupAnimation"];
            
            break;
        }
        case Right: {
            // implicit animation by changing layer property directly
            // based on the API, frame is not animatable. use position and bound instead
            CGPoint position = self.animatableLayer.position;
            position.x += moveDistance;
            self.animatableLayer.position = position;
            break;
        }
    }
    self.animatableLayer.backgroundColor = [self randomCGColor];
}

- (CGColorRef)randomCGColor {
    CGFloat randomRed = arc4random_uniform(255)  / 255.0f;
    CGFloat randomGreen = arc4random_uniform(255) / 255.0f;
    CGFloat randomBlue = arc4random_uniform(255) / 255.0f;
    UIColor *randomColor = [UIColor colorWithRed:randomRed green:randomGreen blue:randomBlue alpha:1.0f];
    return randomColor.CGColor;
}

#pragma mark - Project

+ (NSString *)name {
    return @"Core Animation Basis";
}

+ (NSString *)desc {
    return @"Try to deeply understand Core Animation APIs";
}

+ (NSString *)groupName {
    return ProjectGroupNameCoreAnimation;
}

+ (instancetype)projectViewController {
    return [self new];
}

@end
