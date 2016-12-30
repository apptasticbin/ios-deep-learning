//
//  PersonModel.h
//  ios-deep-learning
//
//  Created by Bin Yu on 30/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSArray *friends;

+ (instancetype)shalockHomes;

@end
