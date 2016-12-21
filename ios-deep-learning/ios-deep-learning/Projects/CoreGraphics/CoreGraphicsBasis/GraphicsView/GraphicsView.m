//
//  GraphicsView.m
//  ios-deep-learning
//
//  Created by Bin Yu on 20/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "GraphicsView.h"

typedef CGFloat(^ColumnXFromIndex)(NSInteger index);
typedef CGFloat(^ColumnYFromPointValue)(NSInteger pointValue);

@implementation GraphicsView

- (void)drawRect:(CGRect)rect {
    // variables
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    
    // clip round rect area
    CGSize cornerRadii = CGSizeMake(5.0f, 5.0f);
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:cornerRadii];
    CGContextAddPath(context, clipPath.CGPath);
    CGContextClip(context);
    
    // create RGB color space; can be CMYK or grayscale
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create color array; toll-free bridging
    CGColorRef startColor = [[[UIColor orangeColor] colorWithAlphaComponent:0.9] CGColor];
    CGColorRef endColor = [[UIColor redColor] CGColor];
    CFArrayRef colors = (__bridge CFArrayRef)@[(__bridge id)startColor, (__bridge id)endColor];
    
    // create locations array
    CGFloat locations[] = {0.0f, 1.0f};
    
    // create gradient
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, locations);
    
    // now draw gradient
    CGPoint startPoint = CGPointMake(width/2, 0);
    CGPoint endPoint = CGPointMake(width/2, height);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    // calculate positions of dots
    NSArray *graphPoints = @[ @(4), @(5), @(2), @(1), @(3) ];
    
    // left and right border for the graph
    CGFloat leftBorder = 20.0f;
    CGFloat rightBorder = 20.0f;
    CGFloat graphWidth = width - leftBorder - rightBorder;
    
    // space between dots
    CGFloat space = graphWidth / (graphPoints.count - 1);
    
    // x values for columns
    ColumnXFromIndex columnXFromIndex = ^(NSInteger index) {
        return index * space + leftBorder;
    };
    
    // top and bottom border for the graph
    CGFloat topBorder = 60.0f;
    CGFloat bottomBorder = 50.0f;
    CGFloat graphHeight = height - topBorder - bottomBorder;
    NSInteger maxGraphPointValue = [[self maxNumberInArray:graphPoints] integerValue];
    
    // y values for columns
    ColumnYFromPointValue columnYFromPointValue = ^(NSInteger pointValue) {
        // because (0, 0) is at top-left corner, we need to reverse the height of graph points
        CGFloat heightOfPoint = graphHeight * pointValue / maxGraphPointValue;
        return graphHeight + topBorder - heightOfPoint;
    };
    
    // generate lines path
    UIBezierPath *graphPath = [UIBezierPath bezierPath];
    CGPoint firstGraphPoint = CGPointMake(columnXFromIndex(0), columnYFromPointValue([graphPoints[0] integerValue]));
    [graphPath moveToPoint:firstGraphPoint];
    for (NSInteger i=1; i<graphPoints.count; i++) {
        CGPoint graphPoint = CGPointMake(columnXFromIndex(i), columnYFromPointValue([graphPoints[i] integerValue]));
        [graphPath addLineToPoint:graphPoint];
    }
    
    /** next we will start clipping the context based on graph path, we need to save the context state.
        this is necessary, because after clipping the context along the graph path, if you then draw
        points, part of those points will be clipped as well.
        So we save the previous context states, then restore it.
     */
    CGContextSaveGState(context);
    
    // create gradiant effect under line path by using line path as clip path
    CGFloat lastPointX = columnXFromIndex(graphPoints.count-1);
    CGPoint bottomRightPoint = CGPointMake(lastPointX, height);
    
    UIBezierPath *clipLinePath = [graphPath copy];
    [clipLinePath addLineToPoint:bottomRightPoint];
    
    CGFloat firstPointX = columnXFromIndex(0);
    CGPoint bottomLeftPoint = CGPointMake(firstPointX, height);
    [clipLinePath addLineToPoint:bottomLeftPoint];
    
    [clipLinePath closePath];
    CGContextAddPath(context, clipLinePath.CGPath);
    CGContextClip(context);
    
    // notice that we clipped the view into line path area, so we still need to fill the view context
    CGPoint lineAreaGradientStartPoint = CGPointMake(leftBorder, columnYFromPointValue(maxGraphPointValue));
    CGPoint lineAreaGradientEndPoint = CGPointMake(leftBorder, height);
    CGContextDrawLinearGradient(context, gradient, lineAreaGradientStartPoint, lineAreaGradientEndPoint, 0);
    
    CGContextRestoreGState(context);
    
    // draw lines between graph points
    CGColorRef graphLinesColor = [[UIColor whiteColor] CGColor];
    
    CGContextAddPath(context, graphPath.CGPath);
    CGContextSetStrokeColorWithColor(context, graphLinesColor);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 3.0f);
    CGContextStrokePath(context);
    
    // draw points over lines
    CGFloat pointRadius = 3.0f;
    CGColorRef pointColor = [[UIColor whiteColor] CGColor];
    
    for (NSInteger i=0; i<graphPoints.count; i++) {
        CGFloat pointX = columnXFromIndex(i);
        CGFloat pointY = columnYFromPointValue([graphPoints[i] integerValue]);
        CGRect pointRect = CGRectMake(pointX-pointRadius, pointY-pointRadius, pointRadius*2, pointRadius*2);
        UIBezierPath *pointPath = [UIBezierPath bezierPathWithOvalInRect:pointRect];
        CGContextAddPath(context, pointPath.CGPath);
        CGContextSetFillColorWithColor(context, pointColor);
        CGContextFillPath(context);
    }
    
    // draw some lines for the graph
    UIBezierPath *linesPath = [UIBezierPath bezierPath];
    
    // draw top line
    CGPoint topLineStartPoint = CGPointMake(leftBorder, topBorder);
    CGPoint topLineEndPoint = CGPointMake(width-rightBorder, topBorder);
    [linesPath moveToPoint:topLineStartPoint];
    [linesPath addLineToPoint:topLineEndPoint];
    
    // draw middle line
    CGPoint middleLineStartPoint = CGPointMake(leftBorder, topBorder + graphHeight / 2);
    CGPoint middleLineEndPoint = CGPointMake(width-rightBorder, topBorder + graphHeight / 2);
    [linesPath moveToPoint:middleLineStartPoint];
    [linesPath addLineToPoint:middleLineEndPoint];
    
    // draw bottom line
    CGPoint bottomLineStartPoint = CGPointMake(leftBorder, topBorder + graphHeight);
    CGPoint bottomLineEndPoint = CGPointMake(width-rightBorder, topBorder + graphHeight);
    [linesPath moveToPoint:bottomLineStartPoint];
    [linesPath addLineToPoint:bottomLineEndPoint];
    
    CGColorRef linesColor = [[[UIColor whiteColor] colorWithAlphaComponent:0.5] CGColor];
    CGContextSetLineWidth(context, 1.0f);
    CGContextAddPath(context, linesPath.CGPath);
    CGContextSetStrokeColorWithColor(context, linesColor);
    CGContextStrokePath(context);
}

- (NSNumber *)maxNumberInArray:(NSArray <NSNumber *>*)numbers {
    NSNumber *maxOne = nil;
    for (NSNumber *number in numbers) {
        if (!maxOne || [number compare:maxOne] == NSOrderedDescending) {
            maxOne = number;
        }
    }
    return maxOne ?: @(0);
}

@end
