//
//  SimpleItunesDownloader.h
//  ios-deep-learning
//
//  Created by Bin Yu on 18/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleItunesDownloader : NSObject

- (instancetype)initWithSessionDelegate:(id<NSURLSessionDelegate>)delegate;
- (void)downloadMusic;
- (void)resumeDownload;
- (void)pauseDownloadMusic;
- (void)cancelDownload;

@end
