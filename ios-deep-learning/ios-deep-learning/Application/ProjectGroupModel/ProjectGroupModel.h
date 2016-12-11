//
//  ProjectGroupModel.h
//  ios-deep-learning
//
//  Created by Bin Yu on 10/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProjectModel;

@interface ProjectGroupModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<ProjectModel *> *projects;

@end
