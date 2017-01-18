//
//  SFJSONObject.m
//  ios-deep-learning
//
//  Created by Bin Yu on 13/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "SFJSONObject.h"
#import <objc/runtime.h>

@implementation SFJSONObject

#pragma mark - Public

+ (__kindof SFJSONObject *)parseJSON:(id)json forClass:(Class)objectClass {
    // make sure that the object class is subclass of SFJSONObject
    NSParameterAssert(objectClass != nil);
    // because of the meta-class inheritant hierarchy rule, all class objects decant from NSObject can use NSObject's class methods.
    NSParameterAssert([objectClass isSubclassOfClass:[SFJSONObject class]]);
    
    // for basic implementation, we assume that the json is NSDictionary
    NSDictionary *jsonDictionary = (NSDictionary *)json;
    NSDictionary *keypathPropertyMap = [[objectClass JSONKeypathByPropertyKey] copy];
    
    if (!keypathPropertyMap) {
        return nil;
    }
    
    id object = [objectClass new];
    
    for (NSString *key in keypathPropertyMap.allKeys) {
        NSString *keyPath = keypathPropertyMap[key];
        id value = [jsonDictionary valueForKeyPath:keyPath];
        if (!value) {
            continue;
        }
        // TODO: using object runtime to check existance of property
        [object setValue:value forKey:key];
    }
    
    return object;
}

+ (NSDictionary<NSString *, NSString *> *)JSONKeypathByPropertyKey {
    return nil;
}

#pragma mark - NSObject

- (NSString *)description {
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    NSMutableArray *keyValuePairs = [NSMutableArray array];
    [keyValuePairs addObject:@"\n"];
    
    for (NSInteger i=0; i<outCount; i++) {
        const char *pName = property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:pName];
        id propertyValue = [self valueForKey:propertyName];
        [keyValuePairs addObject:[NSString stringWithFormat:@"\"%@\" = \"%@\"", propertyName, propertyValue]];
    }
    return [keyValuePairs componentsJoinedByString:@"\n"];
}

@end
