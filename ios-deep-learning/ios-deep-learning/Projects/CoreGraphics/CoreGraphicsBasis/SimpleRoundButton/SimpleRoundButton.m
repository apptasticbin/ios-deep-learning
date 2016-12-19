//
//  StarButton.m
//  ios-deep-learning
//
//  Created by Bin Yu on 18/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "SimpleRoundButton.h"

@interface SimpleRoundButton ()

@property (nonatomic, assign) CGFloat borderWidth;

@end

@implementation SimpleRoundButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        // setup default values
        _fillColor = [UIColor yellowColor];
        _borderColor = [UIColor redColor];
        _selectedColor = [UIColor greenColor];
        _borderWidth = 4.0f;
        
        _normalTitle = @"Button";
        _normalTitleColor = [UIColor blueColor];
        _normalTitleFont = [UIFont boldSystemFontOfSize:14];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    Mark;
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    Mark;
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect, self.borderWidth, self.borderWidth)];
    self.isHighlighted ? [self.selectedColor setFill] : [self.fillColor setFill];
    [roundPath fill];
    
    roundPath.lineWidth = self.borderWidth;
    [self.borderColor setStroke];
    [roundPath stroke];
    
    NSDictionary *titleAttributes = @{
                                      NSForegroundColorAttributeName : self.normalTitleColor,
                                      NSFontAttributeName   :   self.normalTitleFont
                                      };
    CGSize titleSize = [self.normalTitle sizeWithAttributes:titleAttributes];
    [self.normalTitle drawAtPoint:CGPointMake((CGRectGetMaxX(rect)-titleSize.width)/2,
                                              (CGRectGetMaxY(rect)-titleSize.height)/2)
                   withAttributes:titleAttributes];
}

- (NSString *)description {
    return [NSString  stringWithFormat:@"%@", NSStringFromClass(self.class)];
}


@end
