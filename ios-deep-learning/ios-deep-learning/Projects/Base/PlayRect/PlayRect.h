//
//  PlayRect.h
//  ios-deep-learning
//
//  Created by Bin Yu on 11/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayRect : UIView<NSCopying>

@property (nonatomic, strong) NSString *name;

- (void)initializeView;
- (void)initializeSubviews;
- (void)initializeConstraints;

+ (instancetype)rectWithColor:(UIColor *)color;
+ (instancetype)rectWithColor:(UIColor *)color name:(NSString *)name;

// colourful rects
+ (instancetype)redRect;
+ (instancetype)blueRect;
+ (instancetype)orangeRect;
+ (instancetype)greenRect;

@end
