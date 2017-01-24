//
//  SwizzlingRect+Tracking.m
//  ios-deep-learning
//
//  Created by Bin Yu on 23/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "SwizzlingRect+Tracking.h"
#import <objc/objc-runtime.h>

@implementation SwizzlingRect (Tracking)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // first get method selectors
        SEL shakeSelector = @selector(shake);
        SEL shakeAndTrackSelector = @selector(shakeAndTrack);
        // then get Method structure by selector
        Method shakeMethod = class_getInstanceMethod([self class], shakeSelector);
        Method shakeAndTrackMethod = class_getInstanceMethod([self class], shakeAndTrackSelector);
        
        /* To swizzle a method is to change a class’s dispatch table in order to:
         * - resolve messages from an existing selector to a different implementation
         * - while aliasing the original method implementation to a new selector.
         */
        
        // we can try to first add the original method with swizzling implementation
        /* return YES if the method was added successfully, otherwise NO
         * (for example, the class already contains a method implementation with that name).
         */
        BOOL didAddMethod = class_addMethod([self class],
                                            shakeSelector,
                                            method_getImplementation(shakeAndTrackMethod),
                                            method_getTypeEncoding(shakeAndTrackMethod));
        // if the method is not implemented yet, we just replace (aliasing) the swizzling method to original implementation
        if (didAddMethod) {
            class_replaceMethod([self class],
                                shakeAndTrackSelector,
                                method_getImplementation(shakeMethod),
                                method_getTypeEncoding(shakeMethod));
        } else {
            // if both original and swizzling methods are already implemented, then just exchange their implementation.
            method_exchangeImplementations(shakeMethod, shakeAndTrackMethod);
        }
    });
}

- (void)shakeAndTrack {
    /* here, 'shakeAndTrack' method implementation has already been replaced by 'shake' implementation
     * so no infinite loop here
     */
    [self shakeAndTrack];
    NSLog(@"Track counter: %@", @(++self.trackCount));
}

- (NSInteger)trackCount {
    return [objc_getAssociatedObject(self, @selector(trackCount)) integerValue];
}

- (void)setTrackCount:(NSInteger)count {
    objc_setAssociatedObject(self, @selector(trackCount), @(count), OBJC_ASSOCIATION_ASSIGN);
}

@end
