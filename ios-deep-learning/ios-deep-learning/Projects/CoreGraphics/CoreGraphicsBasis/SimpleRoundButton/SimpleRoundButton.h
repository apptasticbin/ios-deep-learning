//
//  StarButton.h
//  ios-deep-learning
//
//  Created by Bin Yu on 18/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleRoundButton : UIButton

@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *selectedColor;

@property (nonatomic, strong) NSString *normalTitle;
@property (nonatomic, strong) UIColor *normalTitleColor;
@property (nonatomic, strong) UIFont *normalTitleFont;

@end
