//
//  SimpleItunesDownloader.m
//  ios-deep-learning
//
//  Created by Bin Yu on 18/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "SimpleItunesDownloader.h"

@interface SimpleItunesDownloader ()

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSData *resumeData;

@end

@implementation SimpleItunesDownloader

- (instancetype)initWithSessionDelegate:(id<NSURLSessionDelegate>)delegate {
    self = [super init];
    if (self) {
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
            NSURLSessionConfiguration *backgroundConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"SimpleItunesDownloadConfiguration"];
            _session = [NSURLSession sessionWithConfiguration:backgroundConfiguration
                                                     delegate:delegate
                                                delegateQueue:nil];
//        });
    }
    return self;
}

- (void)downloadMusic {
    if (self.downloadTask || self.downloadTask.state == NSURLSessionTaskStateRunning) {
        [self stopDownloadMusic];
    }
    NSURL *musicURL = [NSURL URLWithString:@"http://a907.phobos.apple.com/us/r30/Music3/v4/b8/b3/7a/b8b37a93-2154-34da-74fc-8e8a316979a8/mzaf_7991652075174454658.plus.aac.p.m4a"];
    
    self.downloadTask = [self.session downloadTaskWithURL:musicURL];
    [self.downloadTask resume];
}

- (void)cancelDownload {
    if (!self.downloadTask) {
        NSLog(@"No download task to cancel");
        return;
    }
    
    [self.downloadTask cancel];
    self.downloadTask = nil;
}

- (void)resumeDownload {
    if (!self.resumeData || !self.downloadTask) {
        return;
    }
    self.downloadTask = [self.session downloadTaskWithResumeData:self.resumeData];
    [self.downloadTask resume];
}

- (void)pauseDownloadMusic {
    if (self.downloadTask && self.downloadTask.state == NSURLSessionTaskStateRunning) {
        [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            self.resumeData = resumeData;
        }];
    }
}

- (void)stopDownloadMusic {
    
}

@end
