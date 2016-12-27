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

- (void)addSubview:(UIView *)view andCenterWithSize:(CGSize)size {
    [self addSubviewWithoutAutoResizing:view];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGRect rect = CGRectMake((width-size.width)/2.0f,
                             (height-size.height)/2.0f,
                             size.width,
                             size.height);
    view.frame = rect;
}

@end
