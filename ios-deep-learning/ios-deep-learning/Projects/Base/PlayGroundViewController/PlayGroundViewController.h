//
//  PlayGroundViewController.h
//  ios-deep-learning
//
//  Created by Bin Yu on 12/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayGroundControlAction.h"

@interface PlayGroundViewController : UIViewController

@property (nonatomic, strong, readonly) UIView *playStage;
@property (nonatomic, strong, readonly) UITableView *controlPanel;
@property (nonatomic, strong) NSArray<PlayGroundControlAction *> *controlActions;
@property (nonatomic, assign) BOOL enableDebugMode;

- (void)initializeViewController NS_REQUIRES_SUPER;
- (void)initializeViews NS_REQUIRES_SUPER;
- (void)initializeViewConstraints NS_REQUIRES_SUPER;
- (void)initializeControlPanel NS_REQUIRES_SUPER;
- (NSArray<PlayGroundControlAction *> *)controlPanelActions;

@end
