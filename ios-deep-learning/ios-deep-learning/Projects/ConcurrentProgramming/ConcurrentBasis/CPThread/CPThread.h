//
//  CPThread.h
//  ios-deep-learning
//
//  Created by Bin Yu on 03/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TickBlock)();

@interface CPThread : NSThread

@property (nonatomic, strong) TickBlock tickBlock;

@end
