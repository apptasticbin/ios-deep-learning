//
//  BaseViewController.h
//  ios-deep-learning
//
//  Created by Bin Yu on 27/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)initializeViewController NS_REQUIRES_SUPER;
- (void)initializeViews NS_REQUIRES_SUPER;
- (void)initializeViewConstraints NS_REQUIRES_SUPER;

@end
