//
//  EHDoubleScrollViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 02/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "EHDoubleScrollViewController.h"
#import "EHCollectionViewController.h"
#import "UIColor+Helper.h"

@interface EHDoubleScrollViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pages;

@end

@implementation EHDoubleScrollViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pages = @[
                   [self collectionViewController],
                   [self collectionViewController],
                   [self collectionViewController]
                   ];
    }
    return self;
}

#pragma mark - Initialization

- (void)initializeViewController {
    [super initializeViewController];
}

- (void)initializeViews {
    [super initializeViews];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [self.pageViewController willMoveToParentViewController:self];
    [self addChildViewController:self.pageViewController];
    [self.view addSubviewWithoutAutoResizing:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    [self.pageViewController setViewControllers:@[ self.pages[0] ]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
}

- (void)initializeViewConstraints {
    [super initializeViewConstraints];
    
    NSArray *pageViewControllerConstraints = [NSLayoutConstraint constraintsToFitSuperView:self.pageViewController.view];
    [self.view addConstraints:pageViewControllerConstraints];
}

- (UIViewController *)collectionViewController {
    return [EHCollectionViewController new];
}

#pragma mark - UIPageViewControllerDataSource

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self.pages indexOfObject:viewController];
    return index > 0 ? self.pages[index-1] : nil;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self.pages indexOfObject:viewController];
    return index < self.pages.count-1 ? self.pages[index+1] : nil;
}

#pragma mark - UIPageViewControllerDelegate

#pragma mark - Project

+ (NSString *)name {
    return @"Double Scroll Views";
}

+ (NSString *)desc {
    return @"Embed horizontal collection view into page view controller.";
}

+ (NSString *)groupName {
    return ProjectGroupNameEventHandling;
}

+ (instancetype)projectViewController {
    return [self new];
}

@end
