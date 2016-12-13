//
//  AutoLayoutRect.m
//  ios-deep-learning
//
//  Created by Bin Yu on 11/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "AutoLayoutRect.h"

@implementation AutoLayoutRect

- (void)willMoveToSuperview:(nullable UIView *)newSuperview {
    MarkStart;
    [super willMoveToSuperview:newSuperview];
    MarkEnd;
}

- (void)didMoveToSuperview {
    MarkStart;
    [super didMoveToSuperview];
    MarkEnd;
}

- (void)willMoveToWindow:(nullable UIWindow *)newWindow {
    MarkStart;
    [super willMoveToWindow:newWindow];
    MarkEnd;
}

- (void)didMoveToWindow {
    MarkStart;
    [super didMoveToWindow];
    MarkEnd;
}

- (void)layoutSubviews {
    MarkStart;
    [super layoutSubviews];
    MarkEnd;
}

- (void)updateConstraints {
    MarkStart;
    [super updateConstraints];
    MarkEnd;
}

- (void)drawRect:(CGRect)rect {
    MarkStart;
    [super drawRect:rect];
    MarkEnd;
}

@end
