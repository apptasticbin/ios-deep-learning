//
//  NumberCounter.m
//  ios-deep-learning
//
//  Created by Bin Yu on 26/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "NumberCounter.h"

@implementation NumberCounter

@dynamic count;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _subtype = kCATransitionFromTop;
        self.backgroundColor = [[UIColor redColor] CGColor];
    }
    return self;
}

- (void)layoutSublayers {
    [super layoutSublayers];
    [self setNeedsDisplay];
}

- (id<CAAction>)actionForKey:(NSString *)event {
    if ([event isEqualToString:@"count"]) {
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionReveal;
        transition.subtype = self.subtype;
        transition.duration = 0.5f;        
        return transition;
    }
    return [super actionForKey:event];
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"count"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)display {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, [[UIScreen mainScreen] scale]);
    UIBezierPath *outlinePath = [UIBezierPath bezierPathWithRect:self.bounds];
    [[UIColor redColor] setFill];
    [outlinePath fill];
    
    NSString *countStr = [NSString stringWithFormat:@"%@", @(self.count)];
    NSDictionary *attribute = @{
                                NSForegroundColorAttributeName : [UIColor whiteColor],
                                NSFontAttributeName : [UIFont boldSystemFontOfSize:80]
                                };
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    CGSize textSize = [countStr sizeWithAttributes:attribute];
    CGRect textRect = CGRectMake((width - textSize.width)/2.0f,
                                 (height - textSize.height)/2.0f,
                                 textSize.width,
                                 textSize.height);
    
    [countStr drawInRect:textRect withAttributes:attribute];
    UIImage *content = UIGraphicsGetImageFromCurrentImageContext();
    self.contents = (__bridge id)content.CGImage;
    UIGraphicsEndImageContext();
}

@end
