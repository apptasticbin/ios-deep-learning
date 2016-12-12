//
//  PlayRect.h
//  ios-deep-learning
//
//  Created by Bin Yu on 11/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayRect : UIView

// colourful rects
+ (__kindof PlayRect *)redRect;
+ (__kindof PlayRect *)blueRect;
+ (__kindof PlayRect *)yellowRect;
+ (__kindof PlayRect *)greenRect;

@end
