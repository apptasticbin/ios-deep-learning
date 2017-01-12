//
//  CDPersonObject.h
//  ios-deep-learning
//
//  Created by Bin Yu on 09/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import <CoreData/CoreData.h>

@class CDFriendshipObject;

NS_ASSUME_NONNULL_BEGIN

@interface CDPersonObject : NSManagedObject

@property (nullable, nonatomic, strong) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *age;
@property (nullable, nonatomic, strong) NSSet<CDFriendshipObject *> *beFriendedBy;
@property (nullable, nonatomic, strong) NSSet<CDFriendshipObject *> *friends;

+ (NSFetchRequest<CDPersonObject *> *)fetchRequest;

- (void)addFriendsObject:(CDFriendshipObject *)object;
- (void)addFriends:(NSSet *)objects;
- (void)removeFriendsObject:(CDFriendshipObject *)object;
- (void)removeFriends:(NSSet *)objects;

- (void)addBeFriendedByObject:(CDFriendshipObject *)object;
- (void)addBeFriendedBy:(NSSet *)objects;
- (void)removeBeFriendedByObject:(CDFriendshipObject *)object;
- (void)removeBeFriendedBy:(NSSet *)objects;

@end

NS_ASSUME_NONNULL_END
