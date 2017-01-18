//
//  SimpleItunesViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 18/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "SimpleItunesViewController.h"
#import "SimpleItunesDownloader.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SimpleItunesViewController ()<NSURLSessionDownloadDelegate>

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) SimpleItunesDownloader *downloader;
@property (nonatomic, strong) AVPlayerViewController *avPlayerViewController;

@end

@implementation SimpleItunesViewController

#pragma mark - Initialization

- (void)initializeViewController {
    [super initializeViewController];
    self.downloader = [[SimpleItunesDownloader alloc] initWithSessionDelegate:self];
    self.avPlayerViewController = [AVPlayerViewController new];
}

- (void)initializeViews {
    [super initializeViews];
    
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    _progressView.progress = 0.0f;
    _progressView.center = CGPointMake(180, 180);
    _progressView.transform = CGAffineTransformMakeScale(1.0f, 4.0f);
    [self.playStage addSubview:_progressView];
}

#pragma mark - Control Panel

- (NSArray<PlayGroundControlAction *> *)controlPanelActions {
    return @[
             [[PlayGroundControlAction alloc] initWithName:@"Download"
                                                    target:self
                                                    action:@selector(download)],
             [[PlayGroundControlAction alloc] initWithName:@"Pause download"
                                                    target:self
                                                    action:@selector(pauseDownload)],
             [[PlayGroundControlAction alloc] initWithName:@"Resume download"
                                                    target:self
                                                    action:@selector(resumeDownload)],
             [[PlayGroundControlAction alloc] initWithName:@"Cancel download"
                                                    target:self
                                                    action:@selector(cancelDownload)],
             [[PlayGroundControlAction alloc] initWithName:@"Play music"
                                                    target:self
                                                    action:@selector(playMusic)]
             ];
}

- (void)download {
    Mark;
    [self startNetworkActiveIndicator];
    [self.downloader downloadMusic];
}

- (void)pauseDownload {
    Mark;
    [self stopNetworkActiveIndicator];
    [self.downloader pauseDownloadMusic];
}

- (void)resumeDownload {
    Mark;
    [self startNetworkActiveIndicator];
    [self.downloader resumeDownload];
}

- (void)cancelDownload {
    Mark;
    [self stopNetworkActiveIndicator];
    [self.downloader cancelDownload];
}

- (void)playMusic {
    Mark;
    if (![self hasMusicFileCached]) {
        NSLog(@"No cached music file");
        return;
    }
    
    self.avPlayerViewController.player = [AVPlayer playerWithURL:[self musicCacheURL]];
    self.avPlayerViewController.showsPlaybackControls = YES;
    [self presentViewController:self.avPlayerViewController animated:YES completion:^{
        [self.avPlayerViewController.player play];
    }];
}

- (void)startNetworkActiveIndicator {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)stopNetworkActiveIndicator {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)saveMusicLocatedAt:(NSURL *)location {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *targetPath = [self musicCachePath];
    
    if ([fileManager fileExistsAtPath:targetPath]) {
        NSError *error;
        if (![fileManager removeItemAtPath:targetPath error:&error]) {
            NSLog(@"[ERROR] remove cached music error %@", error);
        }
    }
    
    NSError *error;
    if (![fileManager copyItemAtURL:location toURL:[self musicCacheURL] error:&error]) {
        NSLog(@"[ERROR] copy music to cache error %@", error);
    }
}

- (NSString *)musicCachePath {
    NSString *cacheDirectoryPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *targetPath = [NSString stringWithFormat:@"%@/music.m4a", cacheDirectoryPath];
    return targetPath;
}

- (NSURL *)musicCacheURL {
    NSString *cacheDirectoryPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *targetPath = [NSString stringWithFormat:@"file://%@/music.m4a", cacheDirectoryPath];
    return [NSURL URLWithString:targetPath];
}

- (BOOL)hasMusicFileCached {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:[self musicCachePath]];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.progress = totalBytesWritten * 1.0f / totalBytesExpectedToWrite;
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"[SUCCESS] download finished");
    [self stopNetworkActiveIndicator];
    [self saveMusicLocatedAt:location];
    [session finishTasksAndInvalidate];
}

#pragma mark - Project

+ (NSString *)name {
    return @"Simple iTunes";
}

+ (NSString *)desc {
    return @"Try download music from iTunes";
}

+ (NSString *)groupName {
    return ProjectGroupNameURLLoadingSystem;
}

+ (instancetype)projectViewController {
    return [self new];
}


@end
