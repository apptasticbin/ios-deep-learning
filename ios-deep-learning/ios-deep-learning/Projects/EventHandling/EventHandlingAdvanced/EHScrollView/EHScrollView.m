//
//  EHScrollView.m
//  ios-deep-learning
//
//  Created by Bin Yu on 02/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "EHScrollView.h"
#import "UIColor+Helper.h"

static NSInteger SubviewAmount = 5;
static CGFloat SubviewHeight = 300.0f;

@interface EHScrollView ()

@property (nonatomic, strong) NSMutableArray *subviews;
@property (nonatomic, assign) BOOL loaded;

@end

@implementation EHScrollView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _loaded = NO;
        [self loadviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_loaded) {
        return;
    }
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat startX = 0;
    CGFloat y = (height - SubviewHeight) / 2.0f;
    // locate subviews
    for (NSInteger i=0; i<self.subviews.count; i++) {
        UIView *subview = self.subviews[i];
        CGRect frame = CGRectMake(startX, y, width, SubviewHeight);
        subview.frame = frame;
        // move startX
        startX += width;
    }
    
    // setup scallview here, because at this moment, the scroll view has frame itself.
    [self setupScrollView];
    
    _loaded = YES;
}

#pragma mark - Private

- (void)setupScrollView {
    self.pagingEnabled = YES;
    self.contentSize = [self calculateContentSize];
    self.backgroundColor = [UIColor randomColor];
}

- (void)loadviews {
    if (!_subviews) {
        _subviews = [NSMutableArray array];
    }
    for (NSInteger i=0; i<SubviewAmount; i++) {
        UIView *subview = [UIView new];
        subview.backgroundColor = [UIColor randomColor];
        [_subviews addObject:subview];
        [self addSubview:subview];
    }
}

- (CGSize)calculateContentSize {
    CGFloat totalWidth = 0;
    for (UIView *subview in self.subviews) {
        totalWidth += CGRectGetWidth(subview.frame);
    }
    
    return CGSizeMake(totalWidth, CGRectGetHeight(self.frame));
}

@end
