//
//  PlayGroundViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 12/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "PlayGroundViewController.h"
#import "PlayGroundControlAction.h"

@interface PlayGroundViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, readwrite) UIView *playStage;
@property (nonatomic, strong, readwrite) UITableView *controlPanel;

@end

@implementation PlayGroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeViewController];
    [self initializeControlPanel];
    [self initializeViewConstraints];
}

- (void)loadView {
    [super loadView];
    [self initializeViews];
}

#pragma mark - Initialization

- (void)initializeViewController {
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initializeViews {
    self.playStage = [UIView new];
    self.playStage.backgroundColor = [UIColor blackColor];
    [self.view addSubviewWithoutAutoResizing:self.playStage];
    
    self.controlPanel = [UITableView new];
    [self.view addSubviewWithoutAutoResizing:self.controlPanel];
}

- (void)initializeViewConstraints {
    NSDictionary *views = @{
                            @"playStage"    : self.playStage,
                            @"controlPanel" : self.controlPanel
                            };
    NSDictionary *matrics = @{ @"playStageHeight" : @(CGRectGetWidth([[UIScreen mainScreen] bounds])) };
    NSArray *playStageHorizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[playStage]|"
                                            options:0
                                            metrics:nil
                                              views:views];
    [self.view addConstraints:playStageHorizontalConstraints];
    
    NSArray *playStageVerticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[playStage]"
                                            options:0
                                            metrics:matrics
                                              views:views];
    [self.view addConstraints:playStageVerticalConstraints];
    
    /* One useful constraint that cannot be expressed is a fixed aspect ratio 
     * (for example, imageView.width = 2 * imageView.height).
     * To create such a constraint, you must use
     * constraintWithItem:attribute:relatedBy:toItem:attribute:multiplier:constant:.
     */
    NSLayoutConstraint *playStageHeightConstraint =
    [NSLayoutConstraint constraintWithItem:self.playStage
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.playStage
                                 attribute:NSLayoutAttributeWidth
                                multiplier:1.0f
                                  constant:0.0f];
    [self.playStage addConstraint:playStageHeightConstraint];
    
    NSArray *controlPanelHorizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[controlPanel]|"
                                            options:0
                                            metrics:nil
                                              views:views];
    [self.view addConstraints:controlPanelHorizontalConstraints];
    
    NSArray *controlPanelVerticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[playStage]-[controlPanel]|"
                                            options:0
                                            metrics:nil
                                              views:views];
    [self.view addConstraints:controlPanelVerticalConstraints];
}

- (void)initializeControlPanel {
    self.controlPanel.dataSource = self;
    self.controlPanel.delegate = self;
    self.controlActions = [self controlPanelActions];
}

#pragma mark - Accessors

- (void)setControlActions:(NSArray<PlayGroundControlAction *> *)controlActions {
    _controlActions = controlActions;
    [self.controlPanel reloadData];
}

- (NSArray<PlayGroundControlAction *> *)controlPanelActions {
    return nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.controlActions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const ControlPanelTableViewCellID = @"ControlPanelTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ControlPanelTableViewCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ControlPanelTableViewCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    PlayGroundControlAction *action = self.controlActions[indexPath.row];
    cell.textLabel.text = action.name;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayGroundControlAction *action = self.controlActions[indexPath.row];
    [action run];
}

@end
