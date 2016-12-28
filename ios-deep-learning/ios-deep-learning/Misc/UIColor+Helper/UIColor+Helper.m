//
//  UIColor+Helper.m
//  ios-deep-learning
//
//  Created by Bin Yu on 28/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "UIColor+Helper.h"

@implementation UIColor (Helper)

+ (UIColor *)randomColor {
    CGFloat randomRed = arc4random_uniform(255)  / 255.0f;
    CGFloat randomGreen = arc4random_uniform(255) / 255.0f;
    CGFloat randomBlue = arc4random_uniform(255) / 255.0f;
    UIColor *randomColor = [UIColor colorWithRed:randomRed green:randomGreen blue:randomBlue alpha:1.0f];
    return randomColor;
}

@end
