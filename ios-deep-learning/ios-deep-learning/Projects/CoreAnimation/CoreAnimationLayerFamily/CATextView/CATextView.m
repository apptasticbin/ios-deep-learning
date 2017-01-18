//
//  CATextView.m
//  ios-deep-learning
//
//  Created by Bin Yu on 17/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "CATextView.h"
#import <CoreText/CoreText.h>

@interface CATextView ()

@property (nonatomic, strong) CATextLayer *textLayer;

@end

@implementation CATextView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.textLayer.string = @"CATextLayer provides simple but fast rendering of plain text or attributed strings. Unlike UILabel, a CATextLayer cannot have an assigned UIFont, only a CTFontRef or CGFontRef. \n All layer classes, not just CATextLayer, render at a scale factor of 1 by default. When attached to views, layers automatically have their contentsScale set to the appropriate scale factor for the current screen.";
    self.textLayer.wrapped = YES;
    self.textLayer.foregroundColor = [[UIColor whiteColor] CGColor];
    self.textLayer.alignmentMode = kCAAlignmentLeft;
    self.textLayer.truncationMode = kCATruncationEnd;
    self.textLayer.contentsScale = [[UIScreen mainScreen] scale];
    
    CFStringRef fontName = (__bridge CFStringRef)@"Noteworthy-Light";
    // If the font property is a CTFontRef, a CGFontRef, or an instance of NSFont, the font size of the property is ignored.
    self.textLayer.font = CTFontCreateWithName(fontName, 15.0f, nil);
    self.textLayer.fontSize = 20.0f;
}

- (CATextLayer *)textLayer {
    return (CATextLayer *)self.layer;
}

+ (Class)layerClass {
    return [CATextLayer class];
}

@end
