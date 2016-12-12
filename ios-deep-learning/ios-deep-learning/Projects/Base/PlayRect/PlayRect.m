//
//  PlayRect.m
//  ios-deep-learning
//
//  Created by Bin Yu on 11/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "PlayRect.h"

@implementation PlayRect

#pragma mark - Private

+ (__kindof PlayRect *)rectWithColor:(UIColor *)color {
    PlayRect *rect = [PlayRect new];
    rect.backgroundColor = color;
    return rect;
}

#pragma mark - Colourful Rects

+ (__kindof PlayRect *)redRect {
    return [self rectWithColor:[UIColor redColor]];
}

+ (__kindof PlayRect *)blueRect {
    return [self rectWithColor:[UIColor blueColor]];
}

+ (__kindof PlayRect *)yellowRect {
    return [self rectWithColor:[UIColor yellowColor]];
}

+ (__kindof PlayRect *)greenRect {
    return [self rectWithColor:[UIColor greenColor]];
}

@end
