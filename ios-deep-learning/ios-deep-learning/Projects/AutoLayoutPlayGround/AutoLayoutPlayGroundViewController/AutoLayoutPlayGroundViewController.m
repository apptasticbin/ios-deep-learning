//
//  AutoLayoutPlayGroundViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 10/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "AutoLayoutPlayGroundViewController.h"
#import "AutoLayoutRect.h"
#import "PlayGroundControlAction.h"
#import "ProjectGroupNames.h"

/*
 * APIs need to try out:
 * - needsUpdateConstraints
 * - systemLayoutSizeFittingSize
 * - constraintsAffectingLayoutForAxis
 * - hasAmbiguousLayout
 */

@interface AutoLayoutPlayGroundViewController ()

@property (nonatomic, strong) AutoLayoutRect *redRect;
@property (nonatomic, strong) AutoLayoutRect *orangeRect;
@property (nonatomic, strong) AutoLayoutRect *blueRect;
@property (nonatomic, strong) AutoLayoutRect *greenRect;

@end

@implementation AutoLayoutPlayGroundViewController

#pragma mark - Lift Cycle

- (void)viewDidLoad {
    MarkStart;
    [super viewDidLoad];
    MarkEnd;
}

- (void)viewWillAppear:(BOOL)animated {
    MarkStart;
    [super viewWillAppear:animated];
    MarkEnd;
}

- (void)viewDidAppear:(BOOL)animated {
    MarkStart;
    [super viewDidAppear:animated];
    MarkEnd;
}

- (void)viewWillLayoutSubviews {
    MarkStart;
    [super viewWillLayoutSubviews];
    MarkEnd;
}

- (void)viewDidLayoutSubviews {
    MarkStart;
    [super viewDidLayoutSubviews];
    MarkEnd;
}

- (void)loadView {
    MarkStart;
    [super loadView];
    MarkEnd;
}

#pragma mark - Initialization

- (void)initializeViews {
    [super initializeViews];
    
    self.redRect = [AutoLayoutRect redRect];
    self.orangeRect = [AutoLayoutRect orangeRect];
    self.blueRect = [AutoLayoutRect blueRect];
    self.greenRect = [AutoLayoutRect greenRect];
    
    // red rect is the parent of blue and gree rects
    [self.redRect addSubviewWithoutAutoResizing:self.blueRect];
    [self.redRect addSubviewWithoutAutoResizing:self.greenRect];
    // orange rect is child of blue rect
    [self.blueRect addSubviewWithoutAutoResizing:self.orangeRect];
    
    [self.playStage addSubviewWithoutAutoResizing:self.redRect];
}

- (void)initializeViewConstraints {
    [super initializeViewConstraints];
    
    NSDictionary<NSString *, __kindof UIView *> *views = @{
                                                           @"redRect"       : self.redRect,
                                                           @"orangeRect"    : self.orangeRect,
                                                           @"blueRect"      : self.blueRect,
                                                           @"greenRect"     : self.greenRect
                                                           };
    // Auto Layout Visual Format Syntax
    NSArray *redRectHorizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[redRect]-40-|"
                                            options:0
                                            metrics:nil
                                              views:views];
    [self.playStage addConstraints:redRectHorizontalConstraints];
    
    NSArray *redRectVerticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[redRect]-40-|"
                                            options:0
                                            metrics:nil
                                              views:views];
    [self.playStage addConstraints:redRectVerticalConstraints];
    
    NSArray *blueRectHorizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[blueRect(150)]"
                                            options:0
                                            metrics:nil
                                              views:views];
    [self.redRect addConstraints:blueRectHorizontalConstraints];
    
    NSArray *blueRectVerticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[blueRect(150)]"
                                            options:0
                                            metrics:nil
                                              views:views];
    [self.redRect addConstraints:blueRectVerticalConstraints];
    
    NSArray *greenRectHorizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[greenRect(100)]-30-|"
                                            options:0
                                            metrics:nil
                                              views:views];
    [self.redRect addConstraints:greenRectHorizontalConstraints];
    
    NSArray *greenRectVerticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[greenRect(100)]-30-|"
                                            options:0
                                            metrics:nil
                                              views:views];
    [self.redRect addConstraints:greenRectVerticalConstraints];
    
    NSArray *ornageRectHorizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[orangeRect(50)]"
                                            options:0
                                            metrics:nil
                                              views:views];
    [self.blueRect addConstraints:ornageRectHorizontalConstraints];
    
    NSArray *ornageRectVerticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[orangeRect(50)]"
                                            options:0
                                            metrics:nil
                                              views:views];
    [self.blueRect addConstraints:ornageRectVerticalConstraints];
    
}

- (void)initializeControlPanel {
    [super initializeControlPanel];
    self.controlActions = @[
                            [[PlayGroundControlAction alloc] initWithName:@"Check Ambiguous Layout"
                                                                   target:self
                                                                   action:@selector(checkAmbiguousLayout)]
                            ];
}

#pragma mark - Private

- (void)checkAmbiguousLayout {
    if ([self.view hasAmbiguousLayout]) {
        [self.view exerciseAmbiguityInLayout];
    }
}

#pragma mark - Project

+ (NSString *)name {
    return @"Auto Layout Play Ground";
}

+ (NSString *)desc {
    return @"Try to deep understand how exactly Auto Layout works.";
}

+ (NSString *)groupName {
    return ProjectGroupNameAutoLayout;
}

+ (__kindof UIViewController *)projectViewController {
    return [AutoLayoutPlayGroundViewController new];
}

@end
