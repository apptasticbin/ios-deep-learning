//
//  ProxyCounter.h
//  ios-deep-learning
//
//  Created by Bin Yu on 24/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NumberCounter.h"

@interface ProxyCounter : NSProxy

- (instancetype)init;
@property (nonatomic, strong, readonly) NumberCounter *numberCounter;

@end
