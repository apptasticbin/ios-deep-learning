//
//  NSLayoutConstraint+Helper.h
//  ios-deep-learning
//
//  Created by Bin Yu on 14/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (Helper)

+ (NSArray<NSLayoutConstraint *> *)constraintsForCenterView:(UIView *)subview inView:(UIView *)superView;

@end
