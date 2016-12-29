//
//  CVCustomLayoutViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 29/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "CVCustomLayoutViewController.h"
#import "CVCellView.h"
#import "CVSupplementaryView.h"
#import "CVHorizontalLayout.h"
#import "UIColor+Helper.h"

NSString * const CustomLayoutCellId = @"CollectionViewCellId";
NSString * const CustomLayoutSupplementaryId = @"CollectionViewSupplementaryId";

@interface CVCustomLayoutViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CVHorizontalLayout *customLayout;

@end

@implementation CVCustomLayoutViewController

#pragma mark - Initialization

- (void)initializeViews {
    [super initializeViews];
    [self.view addSubviewWithoutAutoResizing:self.collectionView];
    [self.collectionView reloadData];
}

- (void)initializeViewConstraints {
    [super initializeViewConstraints];
    [self.view addConstraints:[self collectionViewHorizontalConstraints]];
    [self.view addConstraints:[self collectionViewVerticalConstraints]];
}

#pragma mark - Accessors

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.customLayout];
        
        [_collectionView registerClass:[CVCellView class]
            forCellWithReuseIdentifier:CustomLayoutCellId];
        
        [_collectionView registerClass:[CVSupplementaryView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:CustomLayoutSupplementaryId];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (CVHorizontalLayout *)customLayout {
    if (!_customLayout) {
        _customLayout = [CVHorizontalLayout new];
    }
    return _customLayout;
}

#pragma mark - Constraints

- (NSArray *)collectionViewHorizontalConstraints {
    return [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|"
                                                   options:0
                                                   metrics:nil
                                                     views:[self layoutViews]];
}

- (NSArray *)collectionViewVerticalConstraints {
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|"
                                                   options:0
                                                   metrics:nil
                                                     views:[self layoutViews]];
}

- (NSDictionary *)layoutViews {
    return @{
             @"collectionView" : self.collectionView
             };
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 5;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CVCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CustomLayoutCellId forIndexPath:indexPath];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    CVSupplementaryView *supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CustomLayoutSupplementaryId forIndexPath:indexPath];
    return supplementaryView;
}

#pragma mark <UICollectionViewDelegate>



#pragma mark - Project

+ (NSString *)name {
    return @"Custom Collection View Layout";
}

+ (NSString *)desc {
    return @"Play with customized collection view layouts.";
}

+ (NSString *)groupName {
    return ProjectGroupNameCollectionView;
}

+ (instancetype)projectViewController {
    return [self new];
}


@end
