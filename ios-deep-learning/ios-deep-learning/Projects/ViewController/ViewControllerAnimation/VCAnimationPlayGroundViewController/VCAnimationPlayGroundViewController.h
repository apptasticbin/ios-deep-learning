//
//  VCAnimationPlayGroundViewController.h
//  ios-deep-learning
//
//  Created by Bin Yu on 26/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "PlayGroundViewController.h"
#import "PlayRect.h"

@interface VCAnimationPlayGroundViewController : PlayGroundViewController<Project>

@property (nonatomic, readonly, strong) PlayRect *blueRect;

@end
