//
//  ProjectModel.h
//  ios-deep-learning
//
//  Created by Bin Yu on 10/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, assign) Class projectClass;

@property (nonatomic, weak) ProjectModel *parent;
@property (nonatomic, readonly) NSArray<ProjectModel *> *children;
@property (nonatomic, readonly, assign) BOOL isLeaf;

- (void)addChild:(ProjectModel *)child;

@end
