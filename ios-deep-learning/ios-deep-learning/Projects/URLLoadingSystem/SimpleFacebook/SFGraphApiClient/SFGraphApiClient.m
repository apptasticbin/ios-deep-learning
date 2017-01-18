//
//  SFGraphApiClient.m
//  ios-deep-learning
//
//  Created by Bin Yu on 12/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "SFGraphApiClient.h"

#pragma mark - HTTP Methods

NSString * const HTTPRequestMethodGet = @"GET";
NSString * const HTTPRequestMethodPost = @"POST";
NSString * const HTTPRequestMethodDelete = @"DELETE";

#pragma mark - HTTP Header

NSString * const HTTPContentTypeHeaderField = @"Content-Type";
NSString * const HTTPContentTypeURLEncoded = @"application/x-www-form-urlencoded";

#pragma mark - Graph API

NSString * const GraphApiAccessToken = @"EAACEdEose0cBAPNQubdslgeP9v0sZBy1XUz7rYmv4M51iGYCEtTK9scm2xhTYzQaVAKQAbGDis4fWKa8N9NMsfxcHKSZBZBfSKyHo9Cyvrbkt2wCp0j4xPX6cxPzr9FjzEcs0fnRkuxjEIjVuTuLEHMlp5zFHv0ZCWUgsV0xTwZDZD";
NSString * const GraphApiParameterKeyAccessToken = @"access_token";

NSString * const GraphApiBasePath = @"https://graph.facebook.com/v2.8";
NSString * const GraphApiGetMePath = @"/me";
NSString * const GraphApiGetUserPath = @"/%@";



static const NSInteger TimeoutPeriod = 5;

@implementation SFGraphApiClient

+ (instancetype)sharedClient {
    static SFGraphApiClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [self new];
    });
    return _sharedClient;
}

#pragma mark - Public Graph API

- (void)fetchMeWithSuccessHandler:(GraphApiSuccessHandler)successHandler
                   failureHandler:(GraphApiFailureHandler)failureHandler {
    [self fetchUserWithId:@"me" successHandler:successHandler failureHandler:failureHandler];
}

- (void)fetchUserWithId:(NSString *)userId successHandler:(GraphApiSuccessHandler)successHandler
         failureHandler:(GraphApiFailureHandler)failureHandler {
    NSDictionary *parameters = @{
                                 @"fields" : @"id,name,friends, picture.width(200).height(200)"
                                 };
    NSURL *userURL = [self urlForPath:[self formatPath:GraphApiGetUserPath, userId] withParameters:parameters];
    NSURLSessionDataTask *dataTask = [self urlSessionTaskForMethod:HTTPRequestMethodGet url:userURL parameters:nil successHandler:successHandler failureHandler:failureHandler];
    [dataTask resume];
}

#pragma mark - Basic Api Client

- (NSURLSessionDataTask *)urlSessionTaskForMethod:(NSString *)method
                                              url:(NSURL *)url
                                       parameters:(NSDictionary *)parameters
                                   successHandler:(GraphApiSuccessHandler)successHandler {
    return [self urlSessionTaskForMethod:method url:url parameters:parameters successHandler:successHandler failureHandler:nil];
}

- (NSURLSessionDataTask *)urlSessionTaskForMethod:(NSString *)method
                                              url:(NSURL *)url
                                       parameters:(NSDictionary *)parameters
                                   successHandler:(GraphApiSuccessHandler)successHandler
                                   failureHandler:(GraphApiFailureHandler)failureHandler {
    NSURLRequest *request = [self requestForMethod:method url:url parameters:parameters];
    // get default configuration
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // generate a URL session
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:configuration];
    // generate data task from URL session
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (error || httpResponse.statusCode != 200) {
            NSLog(@"[ERROR] %@", error);
            if (failureHandler) {
                failureHandler(httpResponse.statusCode, error);
            }
            return;
        }

        // parse respond data
        NSError *parseError;
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (parseError) {
            NSLog(@"[ERROR] %@", parseError);
            if (failureHandler) {
                failureHandler(httpResponse.statusCode, parseError);
            }
            return;
        }
        
        if (successHandler) {
            successHandler(json);
        }
    }];
    
    return dataTask;
}

- (NSURLRequest *)requestForMethod:(NSString *)method url:(NSURL *)url parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:url
                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                        timeoutInterval:TimeoutPeriod];
    // set the HTTP method
    [request setHTTPMethod:method];
    // set content type as url encoded
    [request setValue:HTTPContentTypeURLEncoded forHTTPHeaderField:HTTPContentTypeHeaderField];
    
    return request;
}

#pragma mark - Helper

- (NSString *)serializeParametersString:(NSDictionary *)parameters {
    // serialize parameters into NSData
    NSMutableArray *parametersArray = [NSMutableArray array];
    
    // for testing graph api, all request MUST have access token
    NSString *accessTokenParameter = [NSString stringWithFormat:@"%@=%@", GraphApiParameterKeyAccessToken, GraphApiAccessToken];
    [parametersArray addObject:accessTokenParameter];
    
    if (parameters) {
        [parameters enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *parameter = [NSString stringWithFormat:@"%@=%@", [self percentEscapeString:key], [self percentEscapeString:obj]];
            [parametersArray addObject:parameter];
        }];
    }

    return [parametersArray componentsJoinedByString:@"&"];;
}

- (NSData *)serializeParametersData:(NSDictionary *)parameters {
    return [[self serializeParametersString:parameters] dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)percentEscapeString:(NSString *)string  {
    NSMutableCharacterSet *allowCharacterSet = [[NSCharacterSet alphanumericCharacterSet] mutableCopy];
    NSString *additionCharacters = @"-._~";
    // allowed characters including alphabets, numbers and '-', '.', '_', '~'
    // other characters will be encoded into percentage presentation
    [allowCharacterSet addCharactersInString:additionCharacters];
    return [string stringByAddingPercentEncodingWithAllowedCharacters:allowCharacterSet];
}

- (NSURL *)urlForPath:(NSString *)path {
    return [self urlForPath:path withParameters:nil];
}

- (NSURL *)urlForPath:(NSString *)path withParameters:(NSDictionary *)parameters {
    NSString *fullPath = [GraphApiBasePath stringByAppendingPathComponent:path];
    fullPath = [fullPath stringByAppendingString:@"?"];
    fullPath = [fullPath stringByAppendingString:[self serializeParametersString:parameters]];
    return [NSURL URLWithString:fullPath];
}

- (NSString *)formatPath:(NSString *)path, ... {
    va_list args;
    va_start(args, path);
    NSString *formatPath = [[NSString alloc] initWithFormat:path arguments:args];
    va_end(args);
    return formatPath;
}

@end
