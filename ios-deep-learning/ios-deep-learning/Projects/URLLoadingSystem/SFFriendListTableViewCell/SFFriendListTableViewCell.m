//
//  SFFriendListTableViewCell.m
//  ios-deep-learning
//
//  Created by Bin Yu on 15/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "SFFriendListTableViewCell.h"

NSString * const FriendListTableViewCellID = @"FriendListTableViewCellID";

@implementation SFFriendListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:FriendListTableViewCellID];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
