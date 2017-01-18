//
//  SFMeModel.h
//  ios-deep-learning
//
//  Created by Bin Yu on 15/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "SFJSONObject.h"

@interface SFUserModel : SFJSONObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *pictureURL;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSNumber *friendsAmount;
@property (nonatomic, strong) NSString *moreFriendsURL;

@end
