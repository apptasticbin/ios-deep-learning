//
//  Project.h
//  ios-deep-learning
//
//  Created by Bin Yu on 10/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController;

@protocol Project <NSObject>

NS_ASSUME_NONNULL_BEGIN
+ (NSString *)name;
+ (NSString *)desc;
+ (NSString *)groupName;
+ (instancetype)projectViewController;
NS_ASSUME_NONNULL_END

@end
