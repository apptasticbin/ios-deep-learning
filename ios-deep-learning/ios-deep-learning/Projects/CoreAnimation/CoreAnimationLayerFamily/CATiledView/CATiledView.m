//
//  CATiledView.m
//  ios-deep-learning
//
//  Created by Bin Yu on 17/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "CATiledView.h"

@interface CATiledView ()

@property (nonatomic, strong) CATiledLayer *tiledLayer;

@end

@implementation CATiledView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    // setup tiles
    self.tiledLayer.contentsScale = [[UIScreen mainScreen] scale];
    self.tiledLayer.levelsOfDetail = 2.0f;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat tileWidth = CGRectGetWidth(self.frame) * self.tiledLayer.contentsScale / 8;
    CGFloat tileHeight = CGRectGetHeight(self.frame) * self.tiledLayer.contentsScale / 8;
    self.tiledLayer.tileSize = CGSizeMake(tileWidth, tileHeight);
}

- (CATiledLayer *)tiledLayer {
    return (CATiledLayer *)self.layer;
}

+ (Class)layerClass {
    return [CATiledLayer class];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat red = arc4random_uniform(255) / 255.0;
    CGFloat green = arc4random_uniform(255) / 255.0;
    CGFloat blue = arc4random_uniform(255) / 255.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
}

@end
