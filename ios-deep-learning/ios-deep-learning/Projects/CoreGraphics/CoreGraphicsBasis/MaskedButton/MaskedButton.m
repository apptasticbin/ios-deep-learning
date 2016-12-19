//
//  MaskedButton.m
//  ios-deep-learning
//
//  Created by Bin Yu on 18/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "MaskedButton.h"

@implementation MaskedButton

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupMask];
}

- (void)setupMask {
    // hide original text
    self.titleLabel.hidden = YES;
    
    // first we create graphics image context
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [[UIScreen mainScreen] scale]);
    // get current context
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    // create mask outline path
    CGFloat cornerRadius = self.layer.cornerRadius;
    UIBezierPath *maskRectPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    /** add mask path to context, and fill it
        we can also use implicit context after we created image context
        - [[UIColor whiteColor] setFill];
        - [maskRectPath fill];
     */
    CGContextSetFillColorWithColor(contextRef, [[UIColor whiteColor] CGColor]);
    CGContextAddPath(contextRef, maskRectPath.CGPath);
    CGContextFillPath(contextRef);
    
    // calculate title text size from its attributes
    NSDictionary *titleAttributes = @{ NSFontAttributeName : self.titleLabel.font };
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:titleAttributes];
    // calculate title position
    CGPoint titleCenter = CGPointMake((CGRectGetWidth(self.bounds)-titleSize.width)/2.0f,
                                      (CGRectGetHeight(self.bounds)-titleSize.height)/2.0f);
    /** IMPORTANT:
     reverse the color of text
     original text color is black
     in order to mask-out the text, we change text to transparent
     R = D*(1 - Sa)
     */
    CGContextSetBlendMode(contextRef, kCGBlendModeDestinationOut);
    // draw title following destination out blend mode
    [self.titleLabel.text drawAtPoint:titleCenter withAttributes:titleAttributes];
    
    // generate mask from context
    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CALayer *maskLayer = [CALayer new];
    maskLayer.contents = (__bridge id _Nullable)([maskImage CGImage]);
    maskLayer.frame = self.bounds;
    self.layer.mask = maskLayer;
}

@end
