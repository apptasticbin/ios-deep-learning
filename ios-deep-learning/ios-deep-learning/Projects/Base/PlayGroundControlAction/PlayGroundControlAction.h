//
//  PlayGroundControlAction.h
//  ios-deep-learning
//
//  Created by Bin Yu on 12/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayGroundControlAction : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;

- (instancetype)initWithName:(NSString *)name target:(id)target action:(SEL)action;
- (void)run;

@end
