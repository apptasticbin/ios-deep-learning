//
//  EHPlayGroundViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 01/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "EHPlayGroundViewController.h"
#import "EHRect.h"
#import "EHGestureRecognizer.h"

@interface EHPlayGroundViewController ()

@property (nonatomic, strong) EHRect *redRect;
@property (nonatomic, strong) EHRect *orangeRect;
@property (nonatomic, strong) EHRect *blueRect;
@property (nonatomic, strong) EHRect *greenRect;

@end

@implementation EHPlayGroundViewController

#pragma mark - Initialization

- (void)initializeViews {
    [super initializeViews];
    self.redRect = [EHRect redRect];
    self.orangeRect = [EHRect orangeRect];
    self.blueRect = [EHRect blueRect];
    self.greenRect = [EHRect greenRect];
    
    // red rect is the parent of blue and gree rects
    [self.redRect addSubviewWithoutAutoResizing:self.blueRect];
    [self.redRect addSubviewWithoutAutoResizing:self.greenRect];
    // orange rect is child of blue rect
    [self.blueRect addSubviewWithoutAutoResizing:self.orangeRect];
    [self.playStage addSubviewWithoutAutoResizing:self.redRect];
    
    [self initializeGestureRecognizers];
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // set blue rect as first responder
    // we assign first responder after the view appearing.
    [self.blueRect becomeFirstResponder];
}

#pragma mark - Gesture Recognizer

- (void) initializeGestureRecognizers {
    EHGestureRecognizer *gestureRecognizer = [[EHGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandler:)];
    [self.blueRect addGestureRecognizer:gestureRecognizer];
}

- (void)gestureHandler:(UIGestureRecognizer *)gestureRecognizer {
    Mark;
}

#pragma mark - Constraints

- (NSArray *)redRectConstraints {
    NSArray *redRectHorizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[redRect]-40-|"
                                            options:0
                                            metrics:nil
                                              views:[self layoutViews]];
    
    NSArray *redRectVerticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[redRect]-40-|"
                                            options:0
                                            metrics:nil
                                              views:[self layoutViews]];
    
    return [redRectHorizontalConstraints arrayByAddingObjectsFromArray:redRectVerticalConstraints];
}

- (NSArray *)blueRectConstraints {
    NSArray *blueRectHorizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[blueRect(150)]"
                                            options:0
                                            metrics:nil
                                              views:[self layoutViews]];
    
    NSArray *blueRectVerticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[blueRect(150)]"
                                            options:0
                                            metrics:nil
                                              views:[self layoutViews]];
    return [blueRectHorizontalConstraints arrayByAddingObjectsFromArray:blueRectVerticalConstraints];
}

- (NSArray *)greenRectConstraints {
    NSArray *greenRectHorizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-150-[greenRect]-20-|"
                                            options:0
                                            metrics:nil
                                              views:[self layoutViews]];
    
    NSArray *greenRectVerticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[greenRect]-20-|"
                                            options:0
                                            metrics:nil
                                              views:[self layoutViews]];
    return [greenRectHorizontalConstraints arrayByAddingObjectsFromArray:greenRectVerticalConstraints];
}

- (NSArray *)orangeRectConstraints {
    NSArray *orangeRectHorizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[orangeRect(50)]"
                                            options:0
                                            metrics:nil
                                              views:[self layoutViews]];
    
    NSArray * orangeRectVerticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[orangeRect(50)]"
                                            options:0
                                            metrics:nil
                                              views:[self layoutViews]];
    return [orangeRectHorizontalConstraints arrayByAddingObjectsFromArray:orangeRectVerticalConstraints];
}


- (NSDictionary *)layoutViews {
    return @{
             @"redRect"       : self.redRect,
             @"orangeRect"    : self.orangeRect,
             @"blueRect"      : self.blueRect,
             @"greenRect"     : self.greenRect
             };
}

#pragma mark - Control Panel

- (NSArray<PlayGroundControlAction *> *)controlPanelActions {
    return @[
             [[PlayGroundControlAction alloc] initWithName:@"Shake First Responder"
                                                    target:self
                                                    action:@selector(shakeFirstResponder)]
             ];
}

- (void)shakeFirstResponder {
    [[UIApplication sharedApplication] sendAction:@selector(shake) to:nil from:nil forEvent:nil];
}

#pragma mark - Project

+ (NSString *)name {
    return @"Event Handling Playground";
}

+ (NSString *)desc {
    return @"Fully understand hit test, response chain, gestures, etc.";
}

+ (NSString *)groupName {
    return ProjectGroupNameEventHandling;
}

+ (instancetype)projectViewController {
    return [self new];
}


@end
