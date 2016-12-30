//
//  CRCHViewController.h
//  ios-deep-learning
//
//  Created by Bin Yu on 15/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "PlayGroundViewController.h"

@interface CRCHViewController : PlayGroundViewController<Project>

@property (nonatomic, readonly, strong) UITextField *nameTextField;
@property (nonatomic, readonly, strong) UITextField *addressTextField;

@end
