//
//  CustomIntransicRect.m
//  ios-deep-learning
//
//  Created by Bin Yu on 14/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "CustomIntransicRect.h"

@interface CustomIntransicRect ()

@property (nonatomic, strong) PlayRect *orangeRect;
@property (nonatomic, strong) PlayRect *greenRect;

@end

@implementation CustomIntransicRect

- (void)initializeView {
    self.orangeRectSize = CGSizeMake(100.0f, 100.0f);
    self.greenRectSize = CGSizeMake(70.0f, 50.0f);
    self.contentMargin = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    self.space = 10.0f;
}

- (void)initializeSubviews {
    _orangeRect = [PlayRect orangeRect];
    _greenRect = [PlayRect greenRect];
    
    [self addSubviewWithoutAutoResizing:_orangeRect];
    [self addSubviewWithoutAutoResizing:_greenRect];
}

- (void)initializeConstraints {
    [self addConstraints:@[[self orangeRectCenterXConstraint], [self orangeRectCenterYConstraint]]];
    [self addConstraints:@[[self greenRectCenterXConstraint], [self greenRectCenterYConstraint]]];
    [self.orangeRect addConstraints:@[[self orangeRectWidthConstraint], [self orangeRectHeightConstraint]]];
    [self.greenRect addConstraints:@[[self greenRectWidthConstraint], [self greenRectHeightConstraint]]];
}

- (CGSize)intrinsicContentSize {
    CGFloat intrinsicContentWidth = self.contentMargin.left + self.orangeRectSize.width + self.space + self.greenRectSize.width + self.contentMargin.right;
    CGFloat intrinsicContentHeight = self.contentMargin.top + self.orangeRectSize.height + self.contentMargin.bottom;
    return CGSizeMake(intrinsicContentWidth, intrinsicContentHeight);
}

#pragma mark - UIView

- (void)updateConstraints {
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Layout Constraints

// Example: when we do center alignment, we can ONLY set the alignment between TWO views
- (NSArray *)orangeToGreenHorizontalConstraints {
    return [NSLayoutConstraint constraintsWithVisualFormat:@"H:[orangeRect]-(>=space)-[greenRect]"
                                                   options:NSLayoutFormatAlignAllCenterY
                                                   metrics:[self viewMetrics]
                                                     views:[self layoutViews]];
}

- (NSLayoutConstraint *)orangeRectWidthConstraint {
    return [NSLayoutConstraint constraintWithItem:self.orangeRect
                                        attribute:NSLayoutAttributeWidth
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:nil
                                        attribute:NSLayoutAttributeNotAnAttribute
                                       multiplier:1.0
                                         constant:self.orangeRectSize.width];
}

- (NSLayoutConstraint *)orangeRectHeightConstraint {
    return [NSLayoutConstraint constraintWithItem:self.orangeRect
                                        attribute:NSLayoutAttributeHeight
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:nil
                                        attribute:NSLayoutAttributeNotAnAttribute
                                       multiplier:1.0
                                         constant:self.orangeRectSize.height];
}

- (NSLayoutConstraint *)orangeRectCenterXConstraint {
    return [NSLayoutConstraint constraintWithItem:self.orangeRect
                                        attribute:NSLayoutAttributeCenterX
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self
                                        attribute:NSLayoutAttributeCenterX
                                       multiplier:1.0
                                         constant:-(self.intrinsicContentSize.width-self.orangeRectSize.width)/2.0f+self.contentMargin.left];
}

- (NSLayoutConstraint *)orangeRectCenterYConstraint {
    return [NSLayoutConstraint constraintWithItem:self.orangeRect
                                        attribute:NSLayoutAttributeCenterY
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self
                                        attribute:NSLayoutAttributeCenterY
                                       multiplier:1.0
                                         constant:0];
}

- (NSLayoutConstraint *)greenRectWidthConstraint {
    return [NSLayoutConstraint constraintWithItem:self.greenRect
                                        attribute:NSLayoutAttributeWidth
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:nil
                                        attribute:NSLayoutAttributeNotAnAttribute
                                       multiplier:1.0
                                         constant:self.greenRectSize.width];
}

- (NSLayoutConstraint *)greenRectHeightConstraint {
    return [NSLayoutConstraint constraintWithItem:self.greenRect
                                        attribute:NSLayoutAttributeHeight
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:nil
                                        attribute:NSLayoutAttributeNotAnAttribute
                                       multiplier:1.0
                                         constant:self.greenRectSize.height];
}

- (NSLayoutConstraint *)greenRectCenterXConstraint {
    return [NSLayoutConstraint constraintWithItem:self.greenRect
                                        attribute:NSLayoutAttributeCenterX
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self
                                        attribute:NSLayoutAttributeCenterX
                                       multiplier:1.0
                                         constant:(self.intrinsicContentSize.width-self.greenRectSize.width)/2.0f-self.contentMargin.right];
}

- (NSLayoutConstraint *)greenRectCenterYConstraint {
    return [NSLayoutConstraint constraintWithItem:self.greenRect
                                        attribute:NSLayoutAttributeCenterY
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self.orangeRect
                                        attribute:NSLayoutAttributeCenterY
                                       multiplier:1.0
                                         constant:0];
}

- (NSDictionary *)layoutViews {
    return @{
             @"orangeRect"  :   self.orangeRect,
             @"greenRect"   :   self.greenRect
             };
}

- (NSDictionary *)viewMetrics {
    return @{
             @"orangeRectWidth"     :   @(self.orangeRectSize.width),
             @"orangeRectHeight"    :   @(self.orangeRectSize.height),
             @"greenRectWidth"      :   @(self.greenRectSize.width),
             @"greenRectHeight"     :   @(self.greenRectSize.height),
             @"contentTopMargin"    :   @(self.contentMargin.top),
             @"contentLeftMargin"   :   @(self.contentMargin.left),
             @"contentBottomMargin" :   @(self.contentMargin.bottom),
             @"contentRightMargin"  :   @(self.contentMargin.right),
             @"space"               :   @(self.space)
             };
}

@end
