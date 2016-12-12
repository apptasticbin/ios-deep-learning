//
//  UIView+Helper.m
//  ios-deep-learning
//
//  Created by Bin Yu on 12/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "UIView+Helper.h"

@implementation UIView (Helper)

- (void)addSubviewWithoutAutoResizing:(UIView *)view {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:view];
}

@end
