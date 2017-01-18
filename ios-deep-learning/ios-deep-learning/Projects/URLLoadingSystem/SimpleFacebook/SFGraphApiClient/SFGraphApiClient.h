//
//  SFGraphApiClient.h
//  ios-deep-learning
//
//  Created by Bin Yu on 12/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GraphApiSuccessHandler)(id json);
typedef void(^GraphApiFailureHandler)(NSInteger statusCode, NSError *error);

@interface SFGraphApiClient : NSObject

+ (instancetype)sharedClient;

- (void)fetchMeWithSuccessHandler:(GraphApiSuccessHandler)successHandler
                   failureHandler:(GraphApiFailureHandler)failureHandler;

- (void)fetchUserWithId:(NSString *)userId
         successHandler:(GraphApiSuccessHandler)successHandler
         failureHandler:(GraphApiFailureHandler)failureHandler;

@end
