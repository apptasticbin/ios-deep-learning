//
//  ProjectController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 10/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "ProjectController.h"
#import "Project.h"
#import "ProjectModel.h"
#import <objc/objc-runtime.h>

@implementation ProjectController

+ (instancetype)sharedController {
    static ProjectController *_sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void) {
        _sharedController = [self new];
    });
    return _sharedController;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _projects = [self buildProjects];
    }
    return self;
}

#pragma mark - Private

- (NSArray<ProjectModel *> *)buildProjects {
    NSArray<NSString *> * projectClassNames = [self searchProjectClassNames];
    NSArray<ProjectModel *> *projects = [self buildProjectModelsByClassNames:projectClassNames];
    NSArray<ProjectModel *> *groupedProjects = [self groupProjects:projects];
    return groupedProjects;
}

- (NSArray<NSString *> *)searchProjectClassNames {
    unsigned int classAmount;
    Class *classes = objc_copyClassList(&classAmount);
    NSMutableArray<NSString *> *classNames = [NSMutableArray array];
    
    for (NSInteger i=0; i<classAmount; i++) {
        if (class_conformsToProtocol(classes[i], @protocol(Project))) {
            [classNames addObject:NSStringFromClass(classes[i])];
        }
    }
    
    free(classes);
    return classNames;
}

- (NSArray<ProjectModel *> *)buildProjectModelsByClassNames:(NSArray<NSString *> *)classNames {
    NSMutableArray *projectModels = [NSMutableArray array];
    for (NSString *className in classNames) {
        ProjectModel *projectModel = [self buildProjectModelByClassName:className];
        [projectModels addObject:projectModel];
    }
    return projectModels;
}

- (ProjectModel *)buildProjectModelByClassName:(NSString *)className {
    Class projectClass = NSClassFromString(className);
    ProjectModel *project = [ProjectModel new];
    project.name = [projectClass name];
    project.desc = [projectClass desc];
    project.groupName = [projectClass groupName];
    project.projectClass = projectClass;
    return project;
}

- (NSArray<ProjectModel *> *)groupProjects:(NSArray<ProjectModel *> *)projectModels {
    NSMutableDictionary *groups = [NSMutableDictionary dictionary];
    for (ProjectModel *project in projectModels) {
        if (project.groupName && project.groupName.length) {
            ProjectModel *group = [groups valueForKey:project.groupName];
            if (!group) {
                group = [ProjectModel new];
                group.name = project.groupName;
                groups[project.groupName] = group;
            }
            [group addChild:project];
        }
    }
    return groups.allValues;
}

@end
