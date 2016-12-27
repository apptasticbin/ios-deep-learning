//
//  VCAnimationPopViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 26/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "VCAnimationPopViewController.h"

@interface VCAnimationPopViewController ()

@end

@implementation VCAnimationPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@", self.transitionCoordinator);
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        UIView *toView = [context viewForKey:UITransitionContextToViewKey];
        toView.backgroundColor = [UIColor purpleColor];
    } completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        UIView *fromView = [context viewForKey:UITransitionContextFromViewKey];
        [UIView animateWithDuration:2.0f animations:^{
            fromView.backgroundColor = [UIColor blueColor];
        }];
    } completion:nil];
}

#pragma mark - Private

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
