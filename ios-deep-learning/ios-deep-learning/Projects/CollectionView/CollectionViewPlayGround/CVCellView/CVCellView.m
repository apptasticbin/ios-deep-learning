//
//  CVCellViewCollectionViewCell.m
//  ios-deep-learning
//
//  Created by Bin Yu on 28/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "CVCellView.h"
#import "UIColor+Helper.h"

@implementation CVCellView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor randomColor];
    }
    return self;
}

@end
