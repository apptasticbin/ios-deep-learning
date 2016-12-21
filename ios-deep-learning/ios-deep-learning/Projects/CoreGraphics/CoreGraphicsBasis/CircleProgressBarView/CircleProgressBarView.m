//
//  CanvasView.m
//  ios-deep-learning
//
//  Created by Bin Yu on 19/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "CircleProgressBarView.h"

@implementation CircleProgressBarView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _progress = 0.0f;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    if (progress > 1.0f) {
        _progress = 1.0f;
    } else if (progress < 0) {
        _progress = 0.0f;
    } else {
        _progress = progress;
    }
    [self setNeedsDisplay];
}

#pragma mark - Private

- (void)drawRect:(CGRect)rect {
    // setup required values
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    CGPoint centerPoint = CGPointMake(width / 2.0f, height / 2.0f);
    CGFloat innerPathLineWidth = 74.0f;
    CGFloat outerPathLineWidth = 5.0f;
    CGFloat radius = (MIN(width, height) - innerPathLineWidth - outerPathLineWidth) / 2.0f;
    
    CGColorRef innerColor = [[UIColor orangeColor] CGColor];
    CGColorRef outerColor = [[UIColor whiteColor] CGColor];
    
    // start and end angle in radian
    CGFloat startRadianAngle = 3 * M_PI_4;
    CGFloat endRadianAngle = M_PI_4;
    CGFloat outlineEndRadianAngle = (2 * M_PI - (startRadianAngle - endRadianAngle)) * self.progress + startRadianAngle;
    
    // create inner path for the circle
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *innerPath = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                             radius:radius
                                                         startAngle:startRadianAngle
                                                           endAngle:endRadianAngle
                                                          clockwise:YES];
    
    CGContextSetStrokeColorWithColor(context, innerColor);
    CGContextSetLineWidth(context, innerPathLineWidth);
    CGContextSetLineCap(context, kCGLineCapButt);
    CGContextAddPath(context, innerPath.CGPath);
    CGContextStrokePath(context);

    // create outer line path
    UIBezierPath *outerPath = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                             radius:radius+innerPathLineWidth/2.0f
                                                         startAngle:startRadianAngle
                                                           endAngle:outlineEndRadianAngle
                                                          clockwise:YES];
    [outerPath addArcWithCenter:centerPoint
                         radius:radius-innerPathLineWidth/2.0f
                     startAngle:outlineEndRadianAngle
                       endAngle:startRadianAngle
                      clockwise:NO];
    // close the path, which will add the line between first and last points
    [outerPath closePath];
    
    CGContextSetStrokeColorWithColor(context, outerColor);
    CGContextSetLineWidth(context, outerPathLineWidth);
    CGContextAddPath(context, outerPath.CGPath);
    CGContextStrokePath(context);
    
    // draw marks on progress bar
    
    // save context state
    CGContextSaveGState(context);
    
    // set outer color as fill color for marks
    CGContextSetFillColorWithColor(context, outerColor);
    
    // create mark path
    CGFloat markWidth = 5.0f;
    CGFloat markHeight = 10.0f;
    CGRect markRect = CGRectMake(-markWidth/2, 0, markWidth, markHeight);
    UIBezierPath *markPath = [UIBezierPath bezierPathWithRect:markRect];
    
    // translate the context to bottom-right. This will make top-left be the center now.
    CGContextTranslateCTM(context, width/2, height/2);
    
    // we separate the circle into 10 segments
    for (NSInteger i=1; i<=10; i++) {
        // translate path to each position, and fill them
        // save and restore context for each mark path
        CGContextSaveGState(context);
        
        // radian angle between start and end angles for circle
        CGFloat totalAngle = 2 * M_PI - (startRadianAngle - endRadianAngle);
        CGContextRotateCTM(context, totalAngle / 10 * i + M_PI - startRadianAngle);
        
        // translate to position on the circle
        CGContextTranslateCTM(context, 0, radius + innerPathLineWidth / 2 - markHeight);
        
        // fill mark path
        CGContextAddPath(context, markPath.CGPath);
        CGContextFillPath(context);
        
        CGContextRestoreGState(context);
    }
    
    CGContextRestoreGState(context);
}


@end
