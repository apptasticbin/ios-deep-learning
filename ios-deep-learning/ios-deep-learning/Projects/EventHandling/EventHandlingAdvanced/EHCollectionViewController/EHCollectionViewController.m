//
//  EHCollectionViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 02/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "EHCollectionViewController.h"
#import "EHCollectionView.h"
#import "EHScrollView.h"
#import "UIColor+Helper.h"

static NSString * const CollectionViewCellID = @"CollectionViewCellID";

@interface EHCollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) EHCollectionView *collectionView;
@property (nonatomic, strong) EHScrollView *scrollView;

@end

@implementation EHCollectionViewController

- (void)initializeViews {
    [super initializeViews];
    [self setupScrollView];
//    [self setupCollectionView];
}

- (void)initializeViewConstraints {
    [super initializeViewConstraints];
    [self setupScrollViewConstraints];
//    [self setupCollectionViewConstraints];
}

- (void)setupScrollView {
    _scrollView = [EHScrollView new];
    [self.view addSubviewWithoutAutoResizing:self.scrollView];
}

- (void)setupScrollViewConstraints {
    NSArray *collectionViewConstraints = [NSLayoutConstraint constraintsToFitSuperView:self.scrollView];
    [self.view addConstraints:collectionViewConstraints];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame), 500.0f);
    flowLayout.minimumInteritemSpacing = 0.0f;
    
    self.collectionView = [[EHCollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellID];
    self.collectionView.backgroundColor = [UIColor randomColor];
    // enable paging of collection view
    self.collectionView.pagingEnabled = YES;
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubviewWithoutAutoResizing:self.collectionView];
}

- (void)setupCollectionViewConstraints {
    NSArray *collectionViewConstraints = [NSLayoutConstraint constraintsToFitSuperView:self.collectionView];
    [self.view addConstraints:collectionViewConstraints];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellID forIndexPath:indexPath];
    if (!cell.backgroundColor) {
        cell.backgroundColor = [UIColor randomColor];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

@end
