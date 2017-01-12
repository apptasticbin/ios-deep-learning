//
//  CoreDataController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 08/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "CoreDataController.h"
#import "CDPersonObject.h"
#import "CDFriendshipObject.h"

@interface CoreDataController ()

// Core Data Stack
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;   // link to the data model file
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator * persistentStoreCoordinator;

@end

@implementation CoreDataController

@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeEntities];
    }
    return self;
}

- (void)initializeEntities {
    // create person entity
    NSEntityDescription *personEntity = [NSEntityDescription new];
    personEntity.name = @"Person";
    personEntity.managedObjectClassName = @"CDPersonObject";
    
    // name attribute
    NSAttributeDescription *nameAttribute = [NSAttributeDescription new];
    nameAttribute.name = @"name";
    nameAttribute.attributeType = NSStringAttributeType;
    // whether a property's value can be nil or not (before an object can be persisted).
    nameAttribute.optional = NO;
    // if the property is important for searching
    nameAttribute.indexed = YES;
    // whether a property's value is persisted or ignored when an object is persisted
    nameAttribute.transient = NO;
    
    // age attribute
    NSAttributeDescription *ageAttribute = [NSAttributeDescription new];
    ageAttribute.name = @"age";
    ageAttribute.attributeType = NSDecimalAttributeType;
    ageAttribute.optional = NO;
    
    // friendship entity is like an "edge" in friendship graph.
    NSEntityDescription *friendshipEntity = [NSEntityDescription new];
    friendshipEntity.name = @"Friendship";
    friendshipEntity.managedObjectClassName = @"CDFriendshipObject";
    
    // date attribute
    NSAttributeDescription *dateAttribute = [NSAttributeDescription new];
    dateAttribute.name = @"date";
    dateAttribute.attributeType = NSDateAttributeType;
    dateAttribute.optional = YES;
    dateAttribute.transient = NO;
    
    /* because one person can have several friends, and each friend has several friends as well,
     so this is a many-to-many relationship.
     we should separate the friendship into another entity
     */
    NSRelationshipDescription *sourceRelationship = [NSRelationshipDescription new];
    NSRelationshipDescription *friendRelationship = [NSRelationshipDescription new];
    NSRelationshipDescription *friendsRelationship = [NSRelationshipDescription new];
    NSRelationshipDescription *beFriendedByRelationship = [NSRelationshipDescription new];
    
    sourceRelationship.name = @"source";
    sourceRelationship.destinationEntity = personEntity;
    sourceRelationship.minCount = 0;
    sourceRelationship.maxCount = 1;    // to-one
    sourceRelationship.deleteRule = NSNoActionDeleteRule;
    sourceRelationship.inverseRelationship = beFriendedByRelationship;
    
    friendRelationship.name = @"friend";
    friendRelationship.destinationEntity = personEntity;
    friendRelationship.minCount = 0;
    friendRelationship.maxCount = 1;    // to-one
    friendRelationship.deleteRule = NSNoActionDeleteRule;

    friendsRelationship.name = @"friends";
    friendsRelationship.destinationEntity = friendshipEntity;
    friendsRelationship.minCount = 0;
    friendsRelationship.maxCount = 0;   // o-many
    friendsRelationship.deleteRule = NSCascadeDeleteRule;
    friendsRelationship.inverseRelationship = sourceRelationship;
    
    beFriendedByRelationship.name = @"beFriendedBy";
    beFriendedByRelationship.destinationEntity = friendshipEntity;
    beFriendedByRelationship.minCount = 0;
    beFriendedByRelationship.maxCount = 0;  // to-many
    beFriendedByRelationship.deleteRule = NSCascadeDeleteRule;
    beFriendedByRelationship.inverseRelationship = friendRelationship;
    
    // add attributes and relationships into each entity
    personEntity.properties = @[nameAttribute, ageAttribute, friendsRelationship, beFriendedByRelationship];
    friendshipEntity.properties = @[dateAttribute, sourceRelationship, friendRelationship];
    
    // at last, add entities into object model
    self.managedObjectModel.entities = @[personEntity, friendshipEntity];
}

#pragma mark - Public

+ (instancetype)sharedController {
    static CoreDataController *_sharedController = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedController = [self new];
    });
    return _sharedController;
}

- (void)saveContext {
    if (!self.managedObjectContext) {
        NSLog(@"[ERROR] Managed object context is nil");
        return;
    }
    
    if (![self.managedObjectContext hasChanges]) {
        NSLog(@"[INFO] No change in data context");
        return;
    }
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"[ERROR] Save changes in context failed: %@", error.userInfo);
        abort();
    }
    
    NSLog(@"[SUCCESS] Saved changes");
}

- (void)clearStore {
    NSFetchRequest *fetchRequest = [CDPersonObject fetchRequest];
    NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    NSError *error;
    [self.managedObjectContext executeRequest:deleteRequest error:&error];
}

- (CDPersonObject *)insertNewPersonObject {
    return [self insertNewObjectForEntityForName:@"Person"
                          inManagedObjectContext:self.managedObjectContext];
}

- (CDFriendshipObject *)insertNewFriendshipObject {
    return [self insertNewObjectForEntityForName:@"Friendship"
                          inManagedObjectContext:self.managedObjectContext];
}

- (NSArray<CDPersonObject *> *)fetchPersonObjects {
    NSFetchRequest *fetchRequest = [CDPersonObject fetchRequest];
    fetchRequest.returnsObjectsAsFaults = NO;
    
    NSError *error;
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

- (NSArray<CDPersonObject *> *)fetchPersonObjectsWithName:(NSString *)name {
    NSFetchRequest *fetchRequest = [CDPersonObject fetchRequest];
    fetchRequest.returnsObjectsAsFaults = NO;
    fetchRequest.fetchLimit = 100;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@", name];
    NSError *error;
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

- (NSUndoManager *)undoManager {
    return self.managedObjectContext.undoManager;
}

- (void)undo {
//    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate date]];
    [self.managedObjectContext.undoManager undo];
}

#pragma mark - Private

- (id)insertNewObjectForEntityForName:(NSString *)entityName
               inManagedObjectContext:(NSManagedObjectContext *)context {
    return [NSEntityDescription insertNewObjectForEntityForName:entityName
                                         inManagedObjectContext:context];
}

#pragma mark - Core Data Stack

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    if (self.persistentStoreCoordinator) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
        _managedObjectContext.undoManager = [NSUndoManager new];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        NSURL *dataModelFileURL = [[NSBundle mainBundle] URLForResource:@"CoreDataModel" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:dataModelFileURL];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    // compiler will generate sqlite file for data model. link it on runtime.
    NSURL *sqliteURL = [[self applicationDirectoryURL] URLByAppendingPathComponent:@"CoreDataModel.sqlite"];
    NSError *error = nil;
    NSPersistentStore *persistentStore =
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                              configuration:nil
                                                        URL:sqliteURL
                                                    options:nil
                                                      error:&error];
    if (!persistentStore) {
        NSLog(@"[ERROR]Persistent Store can not be nil: %@", error.userInfo);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDirectoryURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

@end
