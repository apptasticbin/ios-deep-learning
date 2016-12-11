//
//  ProjectTableViewController.h
//  ios-deep-learning
//
//  Created by Bin Yu on 09/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProjectModel;

@interface ProjectTableViewController : UITableViewController

@property (nonatomic, strong) NSArray<ProjectModel *> *projects;

@end
