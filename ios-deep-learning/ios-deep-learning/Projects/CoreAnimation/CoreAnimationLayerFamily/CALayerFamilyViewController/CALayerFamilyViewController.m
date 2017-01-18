//
//  CALayerFamilyViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 16/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "CALayerFamilyViewController.h"
#import "CAScrollView.h"
#import "CATextView.h"
#import "CAReplicatorView.h"
#import "CATiledView.h"
#import "CATiledImageView.h"
#import "CAEmitterView.h"

@interface CALayerFamilyViewController ()

@property (nonatomic, strong) UIView *currentView;
@property (nonatomic, strong) CAScrollView *scrollView;
@property (nonatomic, strong) CATextView *textView;
@property (nonatomic, strong) CAReplicatorView *replicatorView;
@property (nonatomic, strong) CATiledView *tiledView;
@property (nonatomic, strong) UIScrollView *tiledImageScrollView;
@property (nonatomic, strong) CATiledImageView *tiledImageView;
@property (nonatomic, strong) CAEmitterView *emitterView;

@end

@implementation CALayerFamilyViewController

#pragma mark - Initialization

- (void)initializeViewController {
    [super initializeViewController];
}

- (void)initializeViews {
    [super initializeViews];
    
    _scrollView = [CAScrollView new];
    _textView = [CATextView new];
    _replicatorView = [CAReplicatorView new];
    _tiledView = [CATiledView new];
    _tiledImageView = [CATiledImageView new];
    _tiledImageScrollView = [UIScrollView new];
    _emitterView = [CAEmitterView new];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _scrollView.frame = [self frameForSubviewToFitView:self.playStage];
    _textView.frame = [self frameForSubviewToFitView:self.playStage];
    _replicatorView.frame = [self frameForSubviewToFitView:self.playStage];
    _tiledView.frame = [self frameForSubviewToFitView:self.playStage];
    
    _tiledImageView.frame = CGRectMake(0, 0, 1920, 1080);
    [_tiledImageView cutAndSaveImages];
    
    _tiledImageScrollView.frame = [self frameForSubviewToFitView:self.playStage];
    [_tiledImageScrollView addSubview:_tiledImageView];
    _tiledImageScrollView.contentSize = CGSizeMake(1920, 1080);
    
    _emitterView.frame = [self frameForSubviewToFitView:self.playStage];
}

#pragma mark - Control Panel

- (NSArray<PlayGroundControlAction *> *)controlPanelActions {
    return @[
             [[PlayGroundControlAction alloc] initWithName:@"Show Scroll View"
                                                    target:self
                                                    action:@selector(showScrollView)],
             [[PlayGroundControlAction alloc] initWithName:@"Show Text View"
                                                    target:self
                                                    action:@selector(showTextView)],
             [[PlayGroundControlAction alloc] initWithName:@"Show Replicator View"
                                                    target:self
                                                    action:@selector(showReplicatorView)],
             [[PlayGroundControlAction alloc] initWithName:@"Show Tiled View"
                                                    target:self
                                                    action:@selector(showTiledView)],
             [[PlayGroundControlAction alloc] initWithName:@"Show Tiled Image View"
                                                    target:self
                                                    action:@selector(showTiledImageView)],
             [[PlayGroundControlAction alloc] initWithName:@"Show Emitter View"
                                                    target:self
                                                    action:@selector(showEmitterView)]
             ];
}

#pragma mark - Actions

- (void)showScrollView {
    [self showView:self.scrollView];
}

- (void)showTextView {
    [self showView:self.textView];
}

- (void)showReplicatorView {
    [self showView:self.replicatorView];
    [self.replicatorView start];
}

- (void)showTiledView {
    [self showView:self.tiledView];
}

- (void)showTiledImageView {
    [self showView:self.tiledImageScrollView];
}

- (void)showEmitterView {
    [self showView:self.emitterView];
}

- (void)showView:(UIView *)view {
    if (self.currentView == view) {
        return;
    }
    
    if (!self.currentView) {
        self.currentView = view;
        [self.playStage addSubviewWithoutAutoResizing:view];
        view.alpha = 0.0f;
        [UIView animateWithDuration:0.5 animations:^{
            view.alpha = 1.0f;
        }];
    } else {
        view.hidden = YES;
        [self.playStage addSubviewWithoutAutoResizing:view];
        [UIView transitionFromView:self.currentView
                            toView:view
                          duration:1.0f
                           options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionShowHideTransitionViews
                        completion:^(BOOL finished) {
                            self.currentView = view;
                        }];
    }
}

#pragma mark - Helper

- (CGRect)frameForSubviewToFitView:(UIView *)view {
    CGRect frame = view.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat margin = 10.0f;
    return CGRectMake(margin, margin, width-margin*2, height-margin*2);
}

#pragma mark - Project

+ (NSString *)name {
    return @"Core Animation Layer Family";
}

+ (NSString *)desc {
    return @"Try different types of CALayers";
}

+ (NSString *)groupName {
    return ProjectGroupNameCoreAnimation;
}

+ (instancetype)projectViewController {
    return [self new];
}


@end
