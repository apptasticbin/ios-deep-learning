//
//  CDPersonObject.m
//  ios-deep-learning
//
//  Created by Bin Yu on 09/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "CDPersonObject.h"

@implementation CDPersonObject

@dynamic name;
@dynamic age;
@dynamic friends;
@dynamic beFriendedBy;

+ (NSFetchRequest<CDPersonObject *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"Person"];
}

@end
