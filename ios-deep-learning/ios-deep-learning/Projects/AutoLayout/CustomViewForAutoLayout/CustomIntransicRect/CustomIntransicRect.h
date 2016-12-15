//
//  CustomIntransicRect.h
//  ios-deep-learning
//
//  Created by Bin Yu on 14/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "PlayRect.h"

@interface CustomIntransicRect : PlayRect

@property (nonatomic, assign) CGSize orangeRectSize;
@property (nonatomic, assign) CGSize greenRectSize;
@property (nonatomic, assign) UIEdgeInsets contentMargin;
@property (nonatomic, assign) CGFloat space;

@end
