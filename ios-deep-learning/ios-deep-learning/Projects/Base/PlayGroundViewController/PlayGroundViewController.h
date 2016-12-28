//
//  PlayGroundViewController.h
//  ios-deep-learning
//
//  Created by Bin Yu on 12/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PlayGroundControlAction.h"

@interface PlayGroundViewController : BaseViewController

@property (nonatomic, strong, readonly) UIView *playStage;
@property (nonatomic, strong, readonly) UITableView *controlPanel;
@property (nonatomic, strong) NSArray<PlayGroundControlAction *> *controlActions;
@property (nonatomic, assign) BOOL enableDebugMode;

- (void)initializeControlPanel NS_REQUIRES_SUPER;
- (NSArray<PlayGroundControlAction *> *)controlPanelActions;

@end
