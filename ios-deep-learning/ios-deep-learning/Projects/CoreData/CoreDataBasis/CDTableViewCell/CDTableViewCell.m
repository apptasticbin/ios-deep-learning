//
//  CDTableViewCell.m
//  ios-deep-learning
//
//  Created by Bin Yu on 11/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "CDTableViewCell.h"

@implementation CDTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
