//
//  CoreDataBasisViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 09/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "CoreDataBasisViewController.h"
#import "CoreDataController.h"
#import "CDPersonObject.h"
#import "CDFriendshipObject.h"
#import "CDTableViewCell.h"

static NSString * const PersonTableViewCellID = @"PersonTableViewCellID";

typedef NS_ENUM(NSInteger, AddPersonTextFieldTags) {
    AddPersonNameTextFieldTag = 0,
    AddPersonAgeTextFieldTag
};

@interface CoreDataBasisViewController ()<UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CoreDataController *coreDataController;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<CDPersonObject *> *persons;

@end

@implementation CoreDataBasisViewController

#pragma mark - Initialization

- (void)initializeViews {
    [super initializeViews];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[CDTableViewCell class] forCellReuseIdentifier:PersonTableViewCellID];
    [self.view addSubviewWithoutAutoResizing:self.tableView];
}

// will be called after initializeViews
- (void)initializeViewController {
    [super initializeViewController];

    // make sure that searchbar will be covered by other presented view controller
    self.definesPresentationContext = YES;
    self.title = @"Search Friend";
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewPerson)];
    UIBarButtonItem *clearButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearAllPersons)];
    UIBarButtonItem *addTestPersonsButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(generateTestPersonGraph)];
    
    self.navigationItem.rightBarButtonItems = @[clearButtonItem, addTestPersonsButtonItem, addButtonItem];
    
    self.coreDataController = [CoreDataController sharedController];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    // load persons from core data
    [self reloadPersons];
}

- (void)initializeViewConstraints {
    [super initializeViewConstraints];
    [self.view addConstraints:[NSLayoutConstraint constraintsToFitSuperView:self.tableView]];
}

#pragma mark - UIResponser

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (NSUndoManager *)undoManager {
    return self.coreDataController.undoManager;
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    if (!searchText.length) {
        self.persons = [[self.coreDataController fetchPersonObjects] mutableCopy];
    } else {
        NSArray *personObjects = [self.coreDataController fetchPersonObjectsWithName:searchText];
        self.persons = [personObjects mutableCopy];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *addFriendsAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Add Friends" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        // also we can use tableview.editting = NO. But if you don't wanna bother to enable it again, we can just reload the row.
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }];
    addFriendsAction.backgroundColor = [UIColor purpleColor];
    
    UITableViewRowAction *deleteFriendAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }];
    
    return @[deleteFriendAction, addFriendsAction];
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // you need to implement this method too or nothing will work.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // do deletion action here
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES; //tableview must be editable or nothing will work...
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.persons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonTableViewCellID];
    if (!cell) {
        cell = [[CDTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PersonTableViewCellID];
    }
    
    CDPersonObject *person = self.persons[indexPath.row];
    NSString *name = person.name;
    NSNumber *age = person.age;
    
    // using KVC to fetch the names of friends
    NSArray<NSString *> *friendNames = [[person valueForKeyPath:@"friends.friend.name"] allObjects];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (age: %@)", name, age];
    
    if (person.friends.count) {
        NSString *detailText = [@"Friends: " stringByAppendingString:[friendNames componentsJoinedByString:@", "]];
        cell.detailTextLabel.text = detailText;
    }
    
    return cell;
}

#pragma mark - Private

- (void)addNewPerson {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add" message:@"Add a new person" preferredStyle:UIAlertControllerStyleAlert];
    
    // we need to assign a tags for each text field, in order to access them later
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.tag = AddPersonNameTextFieldTag;
        textField.placeholder = @"What's your name?";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.tag = AddPersonAgeTextFieldTag;
        textField.placeholder = @"How old are you?";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __block NSString *name = nil;
        __block NSNumber *age = nil;
        
        [alertController.textFields enumerateObjectsUsingBlock:^(UITextField * _Nonnull textField, NSUInteger idx, BOOL * _Nonnull stop) {
            switch (textField.tag) {
                case AddPersonNameTextFieldTag:
                    name = textField.text;
                    break;
                case AddPersonAgeTextFieldTag:
                    age = @([textField.text integerValue]);
                    break;
            }
        }];
        
        [self doAddNewPersonWithName:name age:age];
        [self dismissViewController];
    }];
    [alertController addAction:addAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewController];
    }];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)clearAllPersons {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Clear" message:@"Are you sure to clear all existing persons?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self doClearAllPersons];
        [self dismissViewController];
    }];
    [alertController addAction:okAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewController];
    }];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doAddNewPersonWithName:(NSString *)name age:(NSNumber *)age {
    [self.undoManager beginUndoGrouping];
    [self.undoManager setActionName:@"Remove New Person"];
    [self.undoManager registerUndoWithTarget:self handler:^(id  _Nonnull target) {
        [self reloadPersons];
    }];
    
    CDPersonObject *newPerson = [self.coreDataController insertNewPersonObject];
    newPerson.name = name;
    newPerson.age = age;
    
    [self.persons addObject:newPerson];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.persons.count-1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    [self.coreDataController saveContext];
    [self.undoManager endUndoGrouping];
}

- (void)doClearAllPersons {
    [self.undoManager setActionName:@"Re-Add Deleted Persons"];
    
    [self.coreDataController clearStore];
    
    NSInteger personAmount = self.persons.count;
    [self.persons removeAllObjects];
    
    [self.tableView beginUpdates];
    
    for (NSInteger idx=personAmount-1; idx>=0; idx--) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    
    [self.tableView endUpdates];
}

- (void)generateTestPersonGraph {
    CoreDataController *coreDataController = [CoreDataController sharedController];
    
    CDPersonObject *person1 = [coreDataController insertNewPersonObject];
    person1.name = [NSString stringWithFormat:@"Person(%@)", @([[NSDate date] hash] % 10000)];
    person1.age = [NSNumber randomIntegerBetween:20 and:50];
    
    CDPersonObject *person2 = [coreDataController insertNewPersonObject];
    person2.name = [NSString stringWithFormat:@"Person(%@)", @([[NSDate date] hash] % 10000)];
    person2.age = [NSNumber randomIntegerBetween:20 and:50];
    
    CDPersonObject *person3 = [coreDataController insertNewPersonObject];
    person3.name = [NSString stringWithFormat:@"Person(%@)", @([[NSDate date] hash] % 10000)];
    person3.age = [NSNumber randomIntegerBetween:20 and:50];
    
    CDFriendshipObject *friendship12 = [coreDataController insertNewFriendshipObject];
    friendship12.source = person1;
    friendship12.friend = person2;
    
    CDFriendshipObject *friendship21 = [coreDataController insertNewFriendshipObject];
    friendship21.source = person2;
    friendship21.friend = person1;
    
    CDFriendshipObject *friendship13 = [coreDataController insertNewFriendshipObject];
    friendship13.source = person1;
    friendship13.friend = person3;
    
    CDFriendshipObject *friendship31 = [coreDataController insertNewFriendshipObject];
    friendship13.source = person3;
    friendship13.friend = person1;
    
    [person1 addFriendsObject:friendship12];
    [person1 addBeFriendedByObject:friendship21];
    
    [person1 addFriendsObject:friendship13];
    [person1 addBeFriendedByObject:friendship31];
    
    [person2 addFriendsObject:friendship21];
    [person2 addBeFriendedByObject:friendship12];
    
    [person3 addFriendsObject:friendship31];
    [person3 addBeFriendedByObject:friendship13];
    
    [self.coreDataController saveContext];
    
    [self.persons addObject:person1];
    [self.persons addObject:person2];
    [self.persons addObject:person3];
    
    [self.tableView beginUpdates];
    
    for (NSInteger idx=3; idx>=1; idx--) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.persons.count-idx inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
    
    [self.tableView endUpdates];
}

- (void)reloadPersons {
    NSArray *existingPersons = [self.coreDataController fetchPersonObjects];
    self.persons = [NSMutableArray arrayWithArray:existingPersons];
    [self.tableView reloadData];
}

#pragma mark - Project

+ (NSString *)name {
    return @"CoreData Playground";
}

+ (NSString *)desc {
    return @"Play with Core Data programmatically.";
}

+ (NSString *)groupName {
    return ProjectGroupNameCoreData;
}

+ (instancetype)projectViewController {
    return [self new];
}

@end
