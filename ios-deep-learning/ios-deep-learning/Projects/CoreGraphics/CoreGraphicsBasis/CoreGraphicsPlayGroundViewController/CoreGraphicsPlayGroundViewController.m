//
//  CoreGraphicsPlayGroundViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 19/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "CoreGraphicsPlayGroundViewController.h"
#import "CircleProgressBarView.h"
#import "GraphicsView.h"
#import "ShowOffViewController.h"

@interface CoreGraphicsPlayGroundViewController ()

@property (nonatomic, strong) CircleProgressBarView *circleProgressBarView;
@property (nonatomic, strong) GraphicsView *graphicsView;
@property (nonatomic, assign) BOOL isGraphicsView;

@end

@implementation CoreGraphicsPlayGroundViewController

#pragma mark - Initialization

- (void)initializeViews {
    [super initializeViews];
    _circleProgressBarView = [CircleProgressBarView new];
    [self.playStage addSubviewWithoutAutoResizing:_circleProgressBarView];
    
    _graphicsView = [GraphicsView new];
    _graphicsView.hidden = YES;
    [self.playStage addSubviewWithoutAutoResizing:_graphicsView];
    
    _isGraphicsView = NO;
}

- (void)initializeViewConstraints {
    [super initializeViewConstraints];
    [self.playStage addConstraints:[self circleProgressBarViewWidthConstraints]];
    [self.playStage addConstraints:[self circleProgressBarViewHeightConstraints]];
    [self.playStage addConstraints:[NSLayoutConstraint constraintsForCenterView:self.circleProgressBarView
                                                                         inView:self.playStage]];
    [self.playStage addConstraints:[self graphicsViewWidthConstraints]];
    [self.playStage addConstraints:[self graphicsViewHeightConstraints]];
    [self.playStage addConstraints:[NSLayoutConstraint constraintsForCenterView:self.graphicsView
                                                                         inView:self.playStage]];
}

#pragma mark - Private

- (NSArray *)circleProgressBarViewWidthConstraints {
    return [NSLayoutConstraint constraintsWithVisualFormat:@"H:[circleProgressBarView(300)]"
                                                   options:0
                                                   metrics:nil
                                                     views:[self layoutViews]];
}

- (NSArray *)circleProgressBarViewHeightConstraints {
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:[circleProgressBarView(300)]"
                                                   options:0
                                                   metrics:nil
                                                     views:[self layoutViews]];
}

- (NSArray *)graphicsViewWidthConstraints {
    return [NSLayoutConstraint constraintsWithVisualFormat:@"H:[graphicsView(300)]"
                                                   options:0
                                                   metrics:nil
                                                     views:[self layoutViews]];
}

- (NSArray *)graphicsViewHeightConstraints {
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:[graphicsView(300)]"
                                                   options:0
                                                   metrics:nil
                                                     views:[self layoutViews]];
}

- (NSDictionary *)layoutViews {
    return @{
             @"circleProgressBarView" : self.circleProgressBarView,
             @"graphicsView" : self.graphicsView
             };
}


#pragma mark - Actions

- (NSArray<PlayGroundControlAction *> *)controlPanelActions {
    return @[
             [[PlayGroundControlAction alloc] initWithName:@"Increase Progress By 10%"
                                                    target:self
                                                    action:@selector(increaseProgress)],
             [[PlayGroundControlAction alloc] initWithName:@"Decrease Progress By 10%"
                                                    target:self
                                                    action:@selector(decreaseProgress)],
             [[PlayGroundControlAction alloc] initWithName:@"Take a picture! Smile~"
                                                    target:self
                                                    action:@selector(takePicture)],
             [[PlayGroundControlAction alloc] initWithName:@"Flip Playground"
                                                    target:self
                                                    action:@selector(flipPlayground)]
             ];
}

- (void)increaseProgress {
    self.circleProgressBarView.progress += 0.1f;
}

- (void)decreaseProgress {
    self.circleProgressBarView.progress -= 0.1f;
}

- (void)takePicture {
    // create image context
    UIGraphicsBeginImageContextWithOptions(self.playStage.bounds.size, YES, [[UIScreen mainScreen] scale]);
    CGContextRef imageContext = UIGraphicsGetCurrentContext();
    [self.playStage.layer renderInContext:imageContext];
    // add some text in the screenshot
    NSString *helloWorld = @"Hellow World";
    [helloWorld drawAtPoint:CGPointMake(20.0f, 20.0f)
             withAttributes:@{
                              NSForegroundColorAttributeName : [UIColor greenColor],
                              NSFontAttributeName : [UIFont boldSystemFontOfSize:20]
                              }];
    // get image from image context
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    ShowOffViewController *showOffViewController = [[ShowOffViewController alloc] initWithContentView:imageView];
    [self.navigationController pushViewController:showOffViewController animated:YES];
}

- (void)flipPlayground {
    if (self.isGraphicsView) {
        [UIView transitionFromView:self.graphicsView
                            toView:self.circleProgressBarView
                          duration:1.0f
                           options:UIViewAnimationOptionShowHideTransitionViews | UIViewAnimationOptionTransitionFlipFromLeft
                        completion:nil];
    } else {
        [UIView transitionFromView:self.circleProgressBarView
                            toView:self.graphicsView
                          duration:1.0f
                           options:UIViewAnimationOptionShowHideTransitionViews | UIViewAnimationOptionTransitionFlipFromRight
                        completion:nil];
    }
    self.isGraphicsView = !self.isGraphicsView;
}

#pragma mark - Project

+ (NSString *)name {
    return @"Core Graphics Play Ground";
}

+ (NSString *)desc {
    return @"Try to deeply understand core grahpics API:s";
}

+ (NSString *)groupName {
    return ProjectGroupNameCoreGraphics;
}

+ (instancetype)projectViewController {
    return [self new];
}

@end
