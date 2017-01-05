//
//  NSNumber+Helper.m
//  ios-deep-learning
//
//  Created by Bin Yu on 04/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "NSNumber+Helper.h"

@implementation NSNumber (Helper)

+ (NSNumber *)randomIntegerBetween:(uint32_t)from and:(uint32_t)to {
    if (from > to) {
        return [self randomIntegerBetween:to and:from];
    }
    uint32_t randomInteger = from + arc4random_uniform(to-from);
    return @(randomInteger);
}

@end
