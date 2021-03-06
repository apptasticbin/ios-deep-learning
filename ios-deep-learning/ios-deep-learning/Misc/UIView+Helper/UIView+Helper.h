//
//  UIView+Helper.h
//  ios-deep-learning
//
//  Created by Bin Yu on 12/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Helper)

- (void)addSubviewWithoutAutoResizing:(UIView *)view;
- (void)addSubview:(UIView *)view andCenterWithSize:(CGSize)size;

@end
