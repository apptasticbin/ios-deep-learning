//
//  ProjectController.h
//  ios-deep-learning
//
//  Created by Bin Yu on 10/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProjectModel;

@interface ProjectController : NSObject

@property (nonatomic, strong) NSArray<ProjectModel *> *projects;

+ (instancetype)sharedController;

@end
