//
//  AnimationController.h
//  ios-deep-learning
//
//  Created by Bin Yu on 26/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VCAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign, getter=isPresenting) BOOL presenting;
@property (nonatomic, assign) CGRect originRect;    // the source view's origin rect is relative to the container view.

@end
