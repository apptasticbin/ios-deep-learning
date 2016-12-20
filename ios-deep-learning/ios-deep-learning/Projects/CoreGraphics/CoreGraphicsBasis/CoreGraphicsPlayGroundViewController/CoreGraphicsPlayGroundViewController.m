//
//  CoreGraphicsPlayGroundViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 19/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "CoreGraphicsPlayGroundViewController.h"
#import "CircleProgressBarView.h"

@interface CoreGraphicsPlayGroundViewController ()

@property (nonatomic, strong) CircleProgressBarView *circleProgressBarView;

@end

@implementation CoreGraphicsPlayGroundViewController

#pragma mark - Initialization

- (void)initializeViews {
    [super initializeViews];
    _circleProgressBarView = [CircleProgressBarView new];
    [self.playStage addSubviewWithoutAutoResizing:_circleProgressBarView];
}

- (void)initializeViewConstraints {
    [super initializeViewConstraints];
    [self.playStage addConstraints:[self circleProgressBarViewWidthConstraints]];
    [self.playStage addConstraints:[self circleProgressBarViewHeightConstraints]];
    [self.playStage addConstraints:[NSLayoutConstraint constraintsForCenterView:self.circleProgressBarView
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

- (NSDictionary *)layoutViews {
    return @{
             @"circleProgressBarView" : self.circleProgressBarView
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
                                                    action:@selector(decreaseProgress)]
             ];
}

- (void)increaseProgress {
    self.circleProgressBarView.progress += 0.1f;
}

- (void)decreaseProgress {
    self.circleProgressBarView.progress -= 0.1f;
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
