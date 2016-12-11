//
//  ProjectModel.m
//  ios-deep-learning
//
//  Created by Bin Yu on 10/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "ProjectModel.h"

@interface ProjectModel ()

@property (nonatomic, strong) NSMutableArray<ProjectModel *> *internalChildren;

@end

@implementation ProjectModel

- (void)addChild:(ProjectModel *)child {
    child.parent = self;
    [self.internalChildren addObject:child];
}

- (BOOL)isLeaf {
    return self.internalChildren.count == 0;
}

- (NSArray<ProjectModel *> *)children {
    return self.internalChildren;
}

- (NSMutableArray<ProjectModel *> *)internalChildren {
    if (!_internalChildren) {
        _internalChildren = [NSMutableArray array];
    }
    return _internalChildren;
}

@end
