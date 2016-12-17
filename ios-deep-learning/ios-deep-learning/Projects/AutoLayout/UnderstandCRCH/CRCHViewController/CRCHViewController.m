//
//  CRCHViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 15/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "CRCHViewController.h"

@interface CRCHViewController ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITextField *nameTextField;

@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UITextField *addressTextField;

@property (nonatomic, strong) UIStackView *verticalStackView;

@end

@implementation CRCHViewController

- (void)initializeViews {
    [super initializeViews];
    
    self.nameLabel = [UILabel new];
    self.nameTextField = [UITextField new];
    self.addressLabel = [UILabel new];
    self.addressTextField = [UITextField new];
    
    [self configLabel:self.nameLabel withText:@"Name"];
    [self configLabel:self.addressLabel withText:@"Address"];
    [self configTextField:self.nameTextField withPlaceholderText:@"Enter name here ..."];
    [self configTextField:self.addressTextField withPlaceholderText:@"Enter address here ..."];
    
    UIStackView *nameHorizontalStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.nameLabel, self.nameTextField]];
    nameHorizontalStackView.axis = UILayoutConstraintAxisHorizontal;
    nameHorizontalStackView.spacing = 15.0f;
    
    UIStackView *addressHorizontalStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.addressLabel, self.addressTextField]];
    addressHorizontalStackView.axis = UILayoutConstraintAxisHorizontal;
    addressHorizontalStackView.spacing = 15.0f;
    
    self.verticalStackView = [[UIStackView alloc] initWithArrangedSubviews:@[nameHorizontalStackView, addressHorizontalStackView]];
    self.verticalStackView.axis = UILayoutConstraintAxisVertical;
    self.verticalStackView.alignment = UIStackViewAlignmentFill;
    self.verticalStackView.spacing = 15.0f;
    self.verticalStackView.backgroundColor = [UIColor greenColor];
    
    [self.playStage addSubviewWithoutAutoResizing:self.verticalStackView];
}

- (void)initializeViewConstraints {
    [super initializeViewConstraints];
    [self.verticalStackView addConstraints:[self textFieldsWidthEqualConstraints]];
    [self.playStage addConstraints:[self verticalStackViewHorizontalConstraints]];
    [self.playStage addConstraints:[self verticalStackViewVerticalConstraints]];
}

#pragma mark - Constraints

- (NSArray *)verticalStackViewHorizontalConstraints {
    return [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[verticalStackView]-20-|"
                                                   options:0
                                                   metrics:nil
                                                     views:[self layoutViews]];
}

- (NSArray *)verticalStackViewVerticalConstraints {
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[verticalStackView]"
                                                   options:0
                                                   metrics:nil
                                                     views:[self layoutViews]];
}

- (NSArray *)textFieldsWidthEqualConstraints {
    return [NSLayoutConstraint constraintsWithVisualFormat:@"[nameTextField(==addressTextField)]"
                                                   options:0
                                                   metrics:nil
                                                     views:[self layoutViews]];
}

- (NSDictionary *)layoutViews {
    return @{
             @"verticalStackView"   :   self.verticalStackView,
             @"nameTextField"       :   self.nameTextField,
             @"addressTextField"    :   self.addressTextField
             };
}

#pragma mark - Private

- (void)configLabel:(UILabel *)label withText:(NSString *)text {
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.layer.borderColor = [[UIColor whiteColor] CGColor];
    label.layer.borderWidth = 1.0f;
    label.layer.cornerRadius = 5.0f;
    label.textAlignment = NSTextAlignmentCenter;
    [label setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)configTextField:(UITextField *)textField withPlaceholderText:(NSString *)placeholderText {
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [textField setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisHorizontal];
}

#pragma mark - Project

+ (NSString *)name {
    return @"Compression Resistance and Content Hugging";
}

+ (NSString *)desc {
    return @"Try to deeply understand how CRCH works for views with intrinsic size.";
}

+ (NSString *)groupName {
    return ProjectGroupNameAutoLayout;
}

+ (__kindof UIViewController *)projectViewController {
    return [CRCHViewController new];
}

@end
