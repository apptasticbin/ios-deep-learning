//
//  CoreDataController.h
//  ios-deep-learning
//
//  Created by Bin Yu on 08/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CDPersonObject;
@class CDFriendshipObject;

@interface CoreDataController : NSObject

+ (instancetype)sharedController;

- (CDPersonObject *)insertNewPersonObject;
- (CDFriendshipObject *)insertNewFriendshipObject;

- (NSArray<CDPersonObject *> *)fetchPersonObjects;
- (NSArray<CDPersonObject *> *)fetchPersonObjectsWithName:(NSString *)name;

- (NSUndoManager *)undoManager;
- (void)undo;

- (void)clearStore;
- (void)saveContext;

@end
