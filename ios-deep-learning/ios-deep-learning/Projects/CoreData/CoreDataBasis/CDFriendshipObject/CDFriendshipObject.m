//
//  CDFriendshipObject.m
//  ios-deep-learning
//
//  Created by Bin Yu on 09/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "CDFriendshipObject.h"

@implementation CDFriendshipObject

@dynamic date;
@dynamic source;
@dynamic friend;

+ (NSFetchRequest<CDFriendshipObject *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"FriendshipObject"];
}

@end
