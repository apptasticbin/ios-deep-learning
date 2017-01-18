//
//  SFMeModel.m
//  ios-deep-learning
//
//  Created by Bin Yu on 15/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "SFUserModel.h"

@implementation SFUserModel

+ (NSDictionary *)JSONKeypathByPropertyKey {
    return @{
             @"userId"          : @"id",
             @"name"            : @"name",
             @"pictureURL"      : @"picture.data.url",
             @"friends"         : @"friends.data"
             };
}

@end
