//
//  DynamicHeightViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 17/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "DynamicHeightViewController.h"

@interface DynamicHeightViewController ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation DynamicHeightViewController

#pragma mark - Initialization

- (void)initializeViews {
    [super initializeViews];
    self.label = [UILabel new];
    self.label.text = @"Label";
    self.label.textColor = [UIColor whiteColor];
    self.label.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.label.layer.borderWidth = 1.0f;
    [self.label setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal];
    [self.label setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisVertical];
    
    self.textField = [UITextField new];
    self.textField.borderStyle = UITextBorderStyleBezel;
    self.textField.textColor = [UIColor whiteColor];
    self.textField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Text Field"
                                    attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    
    [self.playStage addSubviewWithoutAutoResizing:self.label];
    [self.playStage addSubviewWithoutAutoResizing:self.textField];
}

- (void)initializeViewConstraints {
    [super initializeViewConstraints];
    [self.playStage addConstraints:[self horizontalConstraints]];
    [self.playStage addConstraints:[self labelToTopLayoutGuideOptionalConstraints]];
    [self.playStage addConstraints:[self labelToTopLayoutGuideRequiredConstraints]];
    [self.playStage addConstraints:[self textFieldToTopLayoutGuideOptionalConstraints]];
    [self.playStage addConstraints:[self textFieldToTopLayoutGuideRequiredConstraints]];
    [self.playStage addConstraint:[self labelToTextFieldBaselineConstraints]];
}

#pragma mark - Constraints

- (NSArray *)horizontalConstraints {
    return [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[label]-10-[textField]-20-|"
                                                   options:0
                                                   metrics:nil
                                                     views:[self layoutViews]];
}

- (NSArray *)labelToTopLayoutGuideOptionalConstraints {
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(40@249)-[label]"
                                                   options:0
                                                   metrics:nil
                                                     views:[self layoutViews]];
}

- (NSArray *)labelToTopLayoutGuideRequiredConstraints {
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=40)-[label]"
                                                   options:0
                                                   metrics:nil
                                                     views:[self layoutViews]];
}

- (NSArray *)textFieldToTopLayoutGuideOptionalConstraints {
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(40@249)-[textField]"
                                                   options:0
                                                   metrics:nil
                                                     views:[self layoutViews]];
}

- (NSArray *)textFieldToTopLayoutGuideRequiredConstraints {
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=40)-[textField]"
                                                   options:0
                                                   metrics:nil
                                                     views:[self layoutViews]];
}

- (NSLayoutConstraint *)labelToTextFieldBaselineConstraints {
    return [NSLayoutConstraint constraintWithItem:self.label
                                        attribute:NSLayoutAttributeBaseline
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self.textField
                                        attribute:NSLayoutAttributeBaseline
                                       multiplier:1.0
                                         constant:0];
}

#pragma mark - Private

- (NSDictionary *)layoutViews {
    return @{
             @"label"           : self.label,
             @"textField"       : self.textField,
             @"topLayoutGuide"  :   self.topLayoutGuide
             };
}

- (NSArray<PlayGroundControlAction *> *)controlPanelActions {
    return @[
             [[PlayGroundControlAction alloc] initWithName:@"Increase Text Size"
                                                    target:self
                                                    action:@selector(increaseTextSize)],
             [[PlayGroundControlAction alloc] initWithName:@"Decrease Text Size"
                                                    target:self
                                                    action:@selector(decreaseTextSize)]
             ];
}

- (void)increaseTextSize {
    self.label.font = [UIFont systemFontOfSize:self.label.font.pointSize+1];
}

- (void)decreaseTextSize {
    self.label.font = [UIFont systemFontOfSize:self.label.font.pointSize-1];
}

#pragma mark - Project

+ (NSString *)name {
    return @"Dynamic Height";
}

+ (NSString *)desc {
    return @"Dynamic height label and text field";
}

+ (NSString *)groupName {
    return ProjectGroupNameAutoLayout;
}

+ (instancetype)projectViewController {
    return [self new];
}

@end
