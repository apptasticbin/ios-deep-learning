//
//  CVFlowLayout.m
//  ios-deep-learning
//
//  Created by Bin Yu on 28/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "CVFlowLayout.h"
#import "CVSupplementaryView.h"

NSString * const CollectionViewDecorationKind = @"CollectionViewDecorationView";

@interface CVFlowLayout ()

@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *decorationAttributes;

@end

@implementation CVFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        _decorationAttributes = [NSMutableDictionary dictionary];
        // register decoration view class
        [self registerClass:[CVSupplementaryView class] forDecorationViewOfKind:CollectionViewDecorationKind];
    }
    return self;
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    // get current attributes
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    // here we add decoration views JUST at the top-right of each cell items
    // so we create layout attributes for decoration views
    NSMutableArray *newAttributes = [attributes mutableCopy];
    
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        if (attribute.representedElementCategory == UICollectionElementCategoryCell) {
            // if the cell item is in the rect, then we can calculate the frame of decoration view
            if (CGRectIntersectsRect(rect, attribute.frame)) {
                NSIndexPath *indexPath = attribute.indexPath;
                UICollectionViewLayoutAttributes *decorationAttribute = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:CollectionViewDecorationKind withIndexPath:indexPath];
                decorationAttribute.zIndex = 1;
                
                CGFloat width = CGRectGetWidth(attribute.frame) * 0.3f;
                CGFloat height = CGRectGetHeight(attribute.frame) * 0.3f;
                decorationAttribute.center = CGPointMake(CGRectGetMaxX(attribute.frame), CGRectGetMinY(attribute.frame));
                decorationAttribute.size = CGSizeMake(width, height);
                
                [newAttributes addObject:decorationAttribute];
                self.decorationAttributes[indexPath] = decorationAttribute;
            }
        }
    }
    return newAttributes;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [super layoutAttributesForItemAtIndexPath:indexPath];
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath {
    Mark;
    return self.decorationAttributes[indexPath];
}

- (CGSize)collectionViewContentSize {
    return [super collectionViewContentSize];
}

@end
