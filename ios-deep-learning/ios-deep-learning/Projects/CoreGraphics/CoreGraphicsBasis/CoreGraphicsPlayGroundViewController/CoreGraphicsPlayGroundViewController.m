//
//  CoreGraphicsPlayGroundViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 19/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "CoreGraphicsPlayGroundViewController.h"

@interface CoreGraphicsPlayGroundViewController ()

@end

@implementation CoreGraphicsPlayGroundViewController

#pragma mark - Project

+ (NSString *)name {
    return @"Core Graphics Play Ground";
}

+ (NSString *)desc {
    return @"Try to deeply understand core grahpics API:s";
}

+ (NSString *)groupName {
    return ProjectGroupNameCoreGraphics;
}

+ (instancetype)projectViewController {
    return [self new];
}

@end
