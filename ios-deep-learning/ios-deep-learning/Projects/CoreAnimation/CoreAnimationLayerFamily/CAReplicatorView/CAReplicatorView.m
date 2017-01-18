//
//  CAReplicatorView.m
//  ios-deep-learning
//
//  Created by Bin Yu on 17/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "CAReplicatorView.h"

@interface CAReplicatorView ()

@property (nonatomic, strong) CAReplicatorLayer *replicatorLayer;
@property (nonatomic, strong) CALayer *instanceLayer;

@end

@implementation CAReplicatorView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    // replicator layer configuration.
    self.replicatorLayer.instanceCount = 8;
    self.replicatorLayer.instanceDelay = 1.0f / 8.0f;
    // set color offset for each instance.
    self.replicatorLayer.instanceRedOffset = 0.0f;
    self.replicatorLayer.instanceBlueOffset = -0.5f;
    self.replicatorLayer.instanceGreenOffset = -0.5f;
    // set transform offset for each instance: rotating each instance 45 degree around z axis
    CGFloat angel = M_PI * 2 / self.replicatorLayer.instanceCount;
    self.replicatorLayer.instanceTransform = CATransform3DMakeRotation(angel, 0, 0, 1);
    
    self.instanceLayer = [CALayer layer];
    self.instanceLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.replicatorLayer addSublayer:self.instanceLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // now setup the instance layer
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat shortEdge = MIN(width, height);
    
    CGFloat instanceLayerWidth = 10.0f;
    CGFloat instanceLayerHeight = shortEdge / 3.41f;
    CGFloat instanctLayerY = (height - instanceLayerHeight) / 2.0f;
    self.instanceLayer.frame = CGRectMake(0, instanctLayerY, instanceLayerWidth, instanceLayerHeight);
}

- (void)start {
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = @(1);
    fadeAnimation.toValue = @(0);
    fadeAnimation.duration = 1;
    fadeAnimation.repeatCount = INT_MAX;
    
    [self.instanceLayer addAnimation:fadeAnimation forKey:@"fadeAnimation"];
}

- (CAReplicatorLayer *)replicatorLayer {
    return (CAReplicatorLayer *)self.layer;
}

+ (Class)layerClass {
    return [CAReplicatorLayer class];
}

@end
