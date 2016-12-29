//
//  CVHorizontalLayout.m
//  ios-deep-learning
//
//  Created by Bin Yu on 29/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "CVHorizontalLayout.h"

@interface CVHorizontalLayout ()

@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGSize headerSize;
@property (nonatomic, assign) UIEdgeInsets contentMargin;
@property (nonatomic, assign) CGFloat spaceBetweenItems;
@property (nonatomic, assign) CGFloat spaceBetweenHeaderAndItems;
@property (nonatomic, assign) CGRect pinFrame;

@property (nonatomic, strong) NSDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *itemAttributes;
@property (nonatomic, strong) NSDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *headerAttributes;

@end

@implementation CVHorizontalLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        _itemSize = CGSizeMake(50.0f, 100.0f);
        _headerSize = CGSizeMake(80.0f, 40.0f);
        _contentMargin = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        _spaceBetweenItems = 10.0f;
        _spaceBetweenHeaderAndItems = 20.0f;
    }
    return self;
}

#pragma mark - Customization

- (void)prepareLayout {
    [super prepareLayout];
    
    CGFloat collectionViewHeight = CGRectGetHeight(self.collectionView.frame);
    
    // we need to initialize layout attributes for ALL items and header views
    NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> * itemAttributes = [NSMutableDictionary dictionary];
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    CGFloat startItemX = self.contentMargin.left;
    CGFloat startItemY =  (collectionViewHeight - (self.contentMargin.top + self.headerSize.height + self.spaceBetweenHeaderAndItems)) / 2.0f;
    
    CGFloat currentItemX = startItemX;
    
    // locate all items horizontally
    for (NSInteger section=0; section<numberOfSections; section++) {
        NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger index=0; index<numberOfItemsInSection; index++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:section];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            CGFloat itemX = currentItemX;
            CGFloat itemY = startItemY;
            attributes.frame = CGRectMake(itemX, itemY, self.itemSize.width, self.itemSize.height);
            
            itemAttributes[indexPath] = attributes;
            // update current index x
            currentItemX += self.itemSize.width + self.spaceBetweenItems;
        }
    }
    self.itemAttributes = itemAttributes;
    
    // locate headers horizontally
    NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> * headerAttributes = [NSMutableDictionary dictionary];
    
    CGFloat zIndex = 1;
    for (NSInteger section=0; section<numberOfSections; section++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        
        // attach the header to the first item of each
        CGRect frame = self.itemAttributes[indexPath].frame;
        frame.origin.y -= self.spaceBetweenHeaderAndItems + self.headerSize.height;
        frame.size = self.headerSize;
        
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
        attributes.frame = frame;
        attributes.zIndex = zIndex++;
        headerAttributes[indexPath] = attributes;
    }
    self.headerAttributes = headerAttributes;
    
    // setup pin frame
    NSIndexPath *firstHeaderIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    CGRect pinFrame = self.headerAttributes[firstHeaderIndexPath].frame;
    self.pinFrame = pinFrame;
}

- (CGSize)collectionViewContentSize {
    NSInteger numberOfItems = [self numberOfItems];
    CGFloat itemsWidth = numberOfItems * self.itemSize.width;
    CGFloat spaceWidth = (numberOfItems - 1) * self.spaceBetweenItems;
    CGFloat totalWidth = self.contentMargin.left + self.contentMargin.right + itemsWidth + spaceWidth;
    
    CGFloat totalHeight = self.contentMargin.top + self.contentMargin.bottom + self.itemSize.height + self.spaceBetweenHeaderAndItems + self.headerSize.height;
    return CGSizeMake(totalWidth, totalHeight);
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attribute in self.itemAttributes.allValues) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [attributes addObject:attribute];
        }
    }
    
    for (UICollectionViewLayoutAttributes *attribute in self.headerAttributes.allValues) {
        // pin header
        CGPoint contentOffset = self.collectionView.contentOffset;
        CGFloat headerX = CGRectGetMinX(attribute.frame);
        CGFloat pinX = CGRectGetMinX(self.pinFrame);
        if (headerX - pinX <= contentOffset.x) {
            CGRect frame = attribute.frame;
            frame.origin.x = self.pinFrame.origin.x + contentOffset.x;
            attribute.frame = frame;
        }
        [attributes addObject:attribute];
    }
    return attributes;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemAttributes[indexPath];
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        return self.headerAttributes[indexPath];
    }
    return nil;
}

// return YES if we want to continuously call layoutAttributesForElementsInRect: during scrolling.
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

#pragma mark - Private

- (NSInteger)numberOfItems {
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    NSInteger totalNumberOfItems = 0;
    for (NSInteger i=0; i<numberOfSections-1; i++) {
        totalNumberOfItems += [self.collectionView numberOfItemsInSection:i];
    }
    return totalNumberOfItems;
}

@end
