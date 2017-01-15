//
//  SFViewController.h
//  ios-deep-learning
//
//  Created by Bin Yu on 13/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

@interface SFViewController : UIViewController<Project>

@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;

@property (nonatomic, copy) NSString *userId;


@end
