//
//  UIStoryboard+Helper.h
//  ios-deep-learning
//
//  Created by Bin Yu on 11/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (Helper)

+ (__kindof UIViewController *)instantiateViewControllerInMainStoryboard:(NSString *)storyboardIdentifier;

@end
