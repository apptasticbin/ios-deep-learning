//
//  KVCPlayGroundViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 30/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "KVCPlayGroundViewController.h"
#import "PersonModel.h"

@interface KVCPlayGroundViewController ()

@property (nonatomic, strong) PersonModel *person;

@end

@implementation KVCPlayGroundViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _person = [PersonModel shalockHomes];
    }
    return self;
}

#pragma mark - Initialization

- (void)initializeViews {
    [super initializeViews];
    [self updateTextFields];
}

#pragma mark - Control Panel

- (NSArray<PlayGroundControlAction *> *)controlPanelActions {
    return @[
             [[PlayGroundControlAction alloc] initWithName:@"Show Friends' Names"
                                                    target:self
                                                    action:@selector(showFriendsNames)],
             [[PlayGroundControlAction alloc] initWithName:@"Set Nil Age"
                                                    target:self
                                                    action:@selector(setNilAge)],
             [[PlayGroundControlAction alloc] initWithName:@"Set Gender (Unknown)"
                                                    target:self
                                                    action:@selector(setGender)],
             [[PlayGroundControlAction alloc] initWithName:@"Validate Name"
                                                    target:self
                                                    action:@selector(validateName)]
             ];
}

- (void)showFriendsNames {
    NSArray *friendsNames = [self.person valueForKeyPath:@"friends.name"];
    NSString *message = [friendsNames componentsJoinedByString:@", "];
    [self showAlertWithTitle:@"Friends" message:message];
}

- (void)setNilAge {
    [self.person setValue:nil forKey:@"age"];
}

- (void)setGender {
    [self.person setValue:@"male" forKey:@"gender"];
}

- (void)validateName {
    NSString *newName = @"HelloKitty";
    [self.person validateValue:&newName forKey:@"name" error:NULL];
}

#pragma mark - KVC

- (NSArray *)personTextProperties {
    return @[@"name", @"address"];
}

// get textfields by key names
- (UITextField *)textFieldForPersomModelKey:(NSString *)key {
    return [self valueForKey:[key stringByAppendingString:@"TextField"]];
}

- (void)updateTextFields {
    for (NSString *key in [self personTextProperties]) {
        UITextField *textField = [self textFieldForPersomModelKey:key];
        textField.text = [self.person valueForKey:key];
    }
}

#pragma mark - Private

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:title
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Project

+ (NSString *)name {
    return @"KVC Playground";
}

+ (NSString *)desc {
    return @"Learn deeply with key value coding.";
}

+ (NSString *)groupName {
    return ProjectGroupNameKeyValueProgramming;
}

+ (instancetype)projectViewController {
    return [self new];
}


@end
