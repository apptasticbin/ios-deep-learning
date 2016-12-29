//
//  CVSupplementaryViewCollectionReusableView.m
//  ios-deep-learning
//
//  Created by Bin Yu on 28/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "CVSupplementaryView.h"
#import "UIColor+Helper.h"

@implementation CVSupplementaryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _color = [UIColor randomColor];
        self.backgroundColor = _color;
    }
    return self;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    self.backgroundColor = color;
}

@end
