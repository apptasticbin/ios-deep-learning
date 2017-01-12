//
//  CDFriendshipObject.h
//  ios-deep-learning
//
//  Created by Bin Yu on 09/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import <CoreData/CoreData.h>

@class CDPersonObject;

@interface CDFriendshipObject : NSManagedObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) CDPersonObject *source;
@property (nonatomic, strong) CDPersonObject *friend;

+ (NSFetchRequest<CDFriendshipObject *> *)fetchRequest;

@end
