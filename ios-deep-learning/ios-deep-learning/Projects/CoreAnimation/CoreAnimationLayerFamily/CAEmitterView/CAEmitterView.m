//
//  CAEmitterView.m
//  ios-deep-learning
//
//  Created by Bin Yu on 18/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "CAEmitterView.h"

@interface CAEmitterView ()

@property (nonatomic, strong) CAEmitterLayer *emitterLayer;
@property (nonatomic, strong) CAEmitterCell *emitterCell;

@end

@implementation CAEmitterView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.emitterLayer.renderMode = kCAEmitterLayerAdditive;
    self.emitterLayer.drawsAsynchronously = YES;
    // set seed for random emitting
    self.emitterLayer.seed = (unsigned int)[NSDate date].timeIntervalSince1970;
    self.emitterLayer.emitterCells = @[self.emitterCell];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // set emitter layer to the middle of emitter layer
    self.emitterLayer.emitterPosition = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (CAEmitterCell *)emitterCell {
    if (!_emitterCell) {
        _emitterCell = [CAEmitterCell emitterCell];
        // set emitter cell's content
        _emitterCell.contents = (__bridge id)[UIImage imageNamed:@"apple"].CGImage;
        // set velocity of cells
        _emitterCell.velocity = 30.0f;
        _emitterCell.velocityRange = 300.f;
        // set cell color
        _emitterCell.color = [UIColor blackColor].CGColor;
        _emitterCell.redRange = 1.0f;
        _emitterCell.blueRange = 1.0f;
        _emitterCell.greenRange = 1.0f;
        _emitterCell.alphaRange = 0.0f;
        
        _emitterCell.redSpeed = 0.0f;
        _emitterCell.blueSpeed = 0.0f;
        _emitterCell.greenSpeed = 0.0f;
        _emitterCell.alphaSpeed = -0.5f;
        
        // set spin and emission angle
        _emitterCell.spin = M_PI;
        _emitterCell.spinRange = 0;
        _emitterCell.emissionRange = 2 * M_PI;
        
        _emitterCell.lifetime = 1.0f;
        _emitterCell.birthRate = 20.0f;
        _emitterCell.xAcceleration = -300.0f;
        _emitterCell.yAcceleration = 200.0f;
    }
    return _emitterCell;
}

- (CAEmitterLayer *)emitterLayer {
    return (CAEmitterLayer *)self.layer;
}

+ (Class)layerClass {
    return [CAEmitterLayer class];
}

@end
