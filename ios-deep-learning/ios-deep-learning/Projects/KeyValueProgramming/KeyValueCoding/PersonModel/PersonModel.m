//
//  PersonModel.m
//  ios-deep-learning
//
//  Created by Bin Yu on 30/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "PersonModel.h"


@implementation PersonModel

- (instancetype)initWithName:(NSString *)name
                     address:(NSString *)address
                     friends:(NSArray *)friends {
    self = [super init];
    if (self) {
        _name = name;
        _address = address;
        _friends = friends;
    }
    return self;
}

- (void)setNilValueForKey:(NSString *)key {
    // override this method to handle nil values for age (scalar value)
    if ([key isEqualToString:@"age"]) {
        NSLog(@"[WARNING]: set nil value for age");
    } else {
        [super setNilValueForKey:key];
    }
}

// handle undefined key. By default, it will raise exception.
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"gender"]) {
        NSLog(@"[UNKNOWN]: %@ is unknown key", key);
    } else {
        [super setValue:value forUndefinedKey:key];
    }
}

// validation
- (BOOL)validateName:(inout id  _Nullable __autoreleasing *)ioValue error:(out NSError * _Nullable __autoreleasing *)outError {
    NSString *name = (NSString *)*ioValue;
    if ([name isEqualToString:@"HelloKitty"]) {
        NSLog(@"%@ is invalid", name);
        return NO;
    }
    
    NSLog(@"%@ is valid", name);
    return YES;
}

+ (instancetype)shalockHomes {
    return [[self alloc] initWithName:@"Shalock Holmes"
                              address:@"Baker Streat 301"
                              friends:@[[self johnWason], [self binYu]]];
}

+ (instancetype)johnWason {
    return [[self alloc] initWithName:@"John Wason"
                              address:@"Baker Streat 401"
                              friends:nil];
}

+ (instancetype)binYu {
    return [[self alloc] initWithName:@"Bin Yu"
                              address:@"Revontulentie 11 E"
                              friends:nil];
}

@end
