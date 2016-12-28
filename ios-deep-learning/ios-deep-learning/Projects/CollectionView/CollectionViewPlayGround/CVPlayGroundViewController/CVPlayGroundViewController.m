//
//  CVPlayGroundViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 27/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "CVPlayGroundViewController.h"
#import "CVCellView.h"
#import "CVFlowLayout.h"
#import "CVSupplementaryView.h"

NSString * const CollectionViewCellId = @"CollectionViewCellId";
NSString * const CollectionViewSupplementaryId = @"CollectionViewSupplementaryId";

@interface CVPlayGroundViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CVFlowLayout *flowLayout;

@end

@implementation CVPlayGroundViewController

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

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 60;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CVCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellId forIndexPath:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    CVSupplementaryView *supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CollectionViewSupplementaryId forIndexPath:indexPath];
    
    supplementaryView.color = [UIColor redColor];
    return supplementaryView;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(50.0f, 50.0f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(20.0f, 50.0f);
}


#pragma mark - Accessors

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        
        [_collectionView registerClass:[CVCellView class]
            forCellWithReuseIdentifier:CollectionViewCellId];
        
        [_collectionView registerClass:[CVSupplementaryView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:CollectionViewSupplementaryId];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (CVFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [CVFlowLayout new];
//        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
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

#pragma mark - Project

+ (NSString *)name {
    return @"Collection View Playground";
}

+ (NSString *)desc {
    return @"Deeply understand each part of UICollectionView";
}

+ (NSString *)groupName {
    return ProjectGroupNameCollectionView;
}

+ (instancetype)projectViewController {
    return [self new];
}

@end
