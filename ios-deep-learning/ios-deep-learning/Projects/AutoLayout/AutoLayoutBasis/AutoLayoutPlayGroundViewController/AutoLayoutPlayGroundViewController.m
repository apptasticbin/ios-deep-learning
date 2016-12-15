//
//  AutoLayoutPlayGroundViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 10/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "AutoLayoutPlayGroundViewController.h"
#import "AutoLayoutRect.h"

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

@property (nonatomic, strong) NSLayoutConstraint *blueRectHeightConstraint;

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

- (void)updateViewConstraints {
    MarkStart;
    [super updateViewConstraints];
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
    
    // Auto Layout Visual Format Syntax
    // red rect constraints
    [self.playStage addConstraints:[self redRectConstraints]];
    
    // blue rect constraints
    [self.redRect addConstraints:[self blueRectConstraints]];
    
    // green rect constraints
    [self.redRect addConstraints:[self greenRectConstraints]];
    
    // orange rect constraints
    [self.blueRect addConstraints:[self orangeRectConstraints]];
    
}

#pragma mark - Private

- (NSArray<PlayGroundControlAction *> *)controlPanelActions {
    return @[
             [[PlayGroundControlAction alloc] initWithName:@"Check Ambiguous Layout"
                                                    target:self
                                                    action:@selector(checkAmbiguousLayout)],
             [[PlayGroundControlAction alloc] initWithName:@"Move Orange From Blue To Green"
                                                    target:self
                                                    action:@selector(moveOrangeFromBlueToGreen)],
             [[PlayGroundControlAction alloc] initWithName:@"Resize Blue"
                                                    target:self
                                                    action:@selector(resizeBlueRect)]
             ];
}

- (NSDictionary<NSString *, __kindof UIView *> *)playGroundViews {
    return @{
             @"redRect"       : self.redRect,
             @"orangeRect"    : self.orangeRect,
             @"blueRect"      : self.blueRect,
             @"greenRect"     : self.greenRect
             };
}

- (void)checkAmbiguousLayout {
    if ([self.view hasAmbiguousLayout]) {
        [self.view exerciseAmbiguityInLayout];
    }
}

- (void)moveOrangeFromBlueToGreen {
    AutoLayoutRect *orangeSuperView = (AutoLayoutRect *)self.orangeRect.superview;
    AutoLayoutRect *targetSuperView = (orangeSuperView == self.blueRect ? self.greenRect : self.blueRect);
    // when we adjust the parent of subview, all constraints will be removed.
    [self.orangeRect removeFromSuperview];
    [targetSuperView addSubviewWithoutAutoResizing:self.orangeRect];
    // now add constraints to new superview
    [targetSuperView addConstraints:[self orangeRectConstraints]];
}

- (void)resizeBlueRect {
    [UIView animateWithDuration:1.0f animations:^{
        self.blueRectHeightConstraint.constant = self.blueRectHeightConstraint.constant > 150.0f ? 150.0f : 250.0f;
        [self.redRect layoutIfNeeded];
    }];
}

#pragma mark - Constraints

- (NSArray *)redRectConstraints {
    NSArray *redRectHorizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[redRect]-40-|"
                                            options:0
                                            metrics:nil
                                              views:[self playGroundViews]];
    
    NSArray *redRectVerticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[redRect]-40-|"
                                            options:0
                                            metrics:nil
                                              views:[self playGroundViews]];
    
    return [redRectHorizontalConstraints arrayByAddingObjectsFromArray:redRectVerticalConstraints];
}

- (NSArray *)blueRectConstraints {
    NSArray *blueRectHorizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[blueRect(150)]"
                                            options:0
                                            metrics:nil
                                              views:[self playGroundViews]];
    
    NSArray *blueRectVerticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[blueRect]"
                                            options:0
                                            metrics:nil
                                              views:[self playGroundViews]];
    self.blueRectHeightConstraint =
    [NSLayoutConstraint constraintWithItem:self.blueRect attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:150];
    return [blueRectHorizontalConstraints arrayByAddingObjectsFromArray:[blueRectVerticalConstraints arrayByAddingObject:self.blueRectHeightConstraint]];
}

- (NSArray *)greenRectConstraints {
    NSArray *greenRectHorizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-150-[greenRect]-20-|"
                                            options:0
                                            metrics:nil
                                              views:[self playGroundViews]];
    
    NSArray *greenRectVerticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[greenRect]-20-|"
                                            options:0
                                            metrics:nil
                                              views:[self playGroundViews]];
    return [greenRectHorizontalConstraints arrayByAddingObjectsFromArray:greenRectVerticalConstraints];
}

- (NSArray *)orangeRectConstraints {
    NSArray *orangeRectHorizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[orangeRect(50)]"
                                            options:0
                                            metrics:nil
                                              views:[self playGroundViews]];
    
    NSArray * orangeRectVerticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[orangeRect(50)]"
                                            options:0
                                            metrics:nil
                                              views:[self playGroundViews]];
    return [orangeRectHorizontalConstraints arrayByAddingObjectsFromArray:orangeRectVerticalConstraints];
}

#pragma mark - Project

+ (NSString *)name {
    return @"Auto Layout Play Ground";
}

+ (NSString *)desc {
    return @"Try to deeply understand how exactly Auto Layout works.";
}

+ (NSString *)groupName {
    return ProjectGroupNameAutoLayout;
}

+ (__kindof UIViewController *)projectViewController {
    return [AutoLayoutPlayGroundViewController new];
}

@end
