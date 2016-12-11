//
//  UIStoryboard+Helper.m
//  ios-deep-learning
//
//  Created by Bin Yu on 11/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "UIStoryboard+Helper.h"

@implementation UIStoryboard (Helper)

+ (__kindof UIViewController *)instantiateViewControllerInMainStoryboard:(NSString *)storyboardIdentifier {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:storyboardIdentifier];
}

@end
