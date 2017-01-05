//
//  PlayRect.m
//  ios-deep-learning
//
//  Created by Bin Yu on 11/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "PlayRect.h"

@implementation PlayRect

#pragma mark - Public

+ (instancetype)rectWithColor:(UIColor *)color {
    return [self rectWithColor:color name:NSStringFromClass([self class])];
}

+ (instancetype)rectWithColor:(UIColor *)color name:(NSString *)name {
    PlayRect *rect = [self new];
    rect.backgroundColor = color;
    rect.name = name;
    return rect;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeView];
        [self initializeSubviews];
        [self initializeConstraints];
    }
    return self;
}

#pragma mark - Initialization

- (void)initializeView {
    // override in subclass
}

- (void)initializeSubviews {
    // override in subclass
}

- (void)initializeConstraints {
    // override in subclass
}

#pragma mark - NSObject Protocal

- (NSString *)description {
    return [NSString stringWithFormat:@"Rect(%@) at %@", self.name, NSStringFromCGRect(self.frame)];
}

#pragma mark - Colourful Rects

+ (instancetype)redRect {
    return [self rectWithColor:[UIColor redColor] name:@"Red Rect"];
}

+ (instancetype)blueRect {
    return [self rectWithColor:[UIColor blueColor] name:@"Blue Rect"];
}

+ (instancetype)orangeRect {
    return [self rectWithColor:[UIColor orangeColor] name:@"Orange Rect"];
}

+ (instancetype)greenRect {
    return [self rectWithColor:[UIColor greenColor] name:@"Green Rect"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    return [self copy];
}

@end
