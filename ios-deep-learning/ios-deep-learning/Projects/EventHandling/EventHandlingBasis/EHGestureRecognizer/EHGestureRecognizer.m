//
//  EHGestureRecognizer.m
//  ios-deep-learning
//
//  Created by Bin Yu on 01/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "EHGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation EHGestureRecognizer

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    Mark;
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    Mark;
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", NSStringFromClass([self class])];
}

@end
