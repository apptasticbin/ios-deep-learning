//
//  SFJSONObject.h
//  ios-deep-learning
//
//  Created by Bin Yu on 13/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFJSONObject : NSObject

+ (__kindof SFJSONObject *)parseJSON:(id)json forClass:(Class)objectClass;
+ (NSDictionary *)JSONKeypathByPropertyKey;

@end
