//
//  SFViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 13/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "SFViewController.h"
#import "SFGraphApiClient.h"
#import "SFUserModel.h"
#import "SFFriendListTableViewCell.h"

@interface SFViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SFUserModel *userModel;

@end

@implementation SFViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _userId = @"me";
        _userModel = nil;
    }
    return self;
}

- (void)initializeViewController {
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.friendsTableView.delegate = self;
    self.friendsTableView.dataSource = self;
    [self.friendsTableView registerClass:[SFFriendListTableViewCell class]
                  forCellReuseIdentifier:FriendListTableViewCellID];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeViewController];
    [self loadUserInformation];
}

- (void)loadUserInformation {
    // fetch user information and update UI
    __weak id weakSelf = self;
    [[SFGraphApiClient sharedClient] fetchUserWithId:self.userId successHandler:^(id json) {
        SFViewController *strongSelf = weakSelf;
        SFUserModel *userModel = [SFJSONObject parseJSON:json forClass:[SFUserModel class]];
        NSLog(@"[SUCCESS] %@", userModel);
        [strongSelf updateUserInformation:userModel];
    } failureHandler:^(NSInteger statusCode, NSError *error) {
        NSLog(@"[ERROR] statuc code %@", @(statusCode));
    }];
}

#pragma mark - Private

- (void)updateUserInformation:(SFUserModel *)userModel {
    self.userModel = userModel;
    
    __weak id weakSelf = self;
    // load image also on backgroudn queue
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error;
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:userModel.pictureURL]
                                                  options:0
                                                    error:&error];
        UIImage *image = [UIImage imageWithData:imageData
                                          scale:[UIScreen mainScreen].scale];
        dispatch_async(dispatch_get_main_queue(), ^{
            SFViewController *strongSelf = weakSelf;
            strongSelf.pictureImageView.image = image;
        });
    });
    
    // dispatch to main queue in order to update UIViews.
    dispatch_async(dispatch_get_main_queue(), ^{
        SFViewController *strongSelf = weakSelf;
        strongSelf.nameLabel.text = userModel.name;
        strongSelf.userIdLabel.text = userModel.userId;
        [strongSelf.friendsTableView reloadData];
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userModel.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFFriendListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FriendListTableViewCellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[SFFriendListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:FriendListTableViewCellID];
    }
    SFUserModel *friendModel = [SFJSONObject parseJSON:self.userModel.friends[indexPath.row]
                                              forClass:[SFUserModel class]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = friendModel.name;
    cell.detailTextLabel.text = [@"ID: " stringByAppendingString:friendModel.userId];
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Friends";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SFUserModel *friendModel = [SFJSONObject parseJSON:self.userModel.friends[indexPath.row]
                                              forClass:[SFUserModel class]];
    SFViewController *viewController = [SFViewController new];
    viewController.userId = friendModel.userId;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Project

+ (NSString *)name {
    return @"Simple Facebook";
}

+ (NSString *)desc {
    return @"Try to create a simple version of facebook ";
}

+ (NSString *)groupName {
    return ProjectGroupNameURLLoadingSystem;
}

+ (instancetype)projectViewController {
    return [self new];
}

@end
