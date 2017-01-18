//
//  CAScrollView.m
//  ios-deep-learning
//
//  Created by Bin Yu on 16/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "CAScrollView.h"

@interface CAScrollView ()

@property (nonatomic, strong) CAScrollLayer *scrollLayer;

@end

@implementation CAScrollView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (CAScrollLayer *)scrollLayer {
    return (CAScrollLayer *)self.layer;
}

- (void)setup {
    // NOTICE: we MUST add image as image view and subview into ScrollView
    // We CAN NOT assign image as content of scroll layer, which doesn't work!
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stains_gate"]];
    [self addSubview:imageView];
    self.scrollLayer.contentsGravity = kCAGravityCenter;
    // cast view layer into CAScrollLayer
    // make scroll layer scroll in both horizontal and vertical directions
    self.scrollLayer.scrollMode = kCAScrollBoth;
    // add gesture recognizer for the view
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:panGestureRecognizer];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint newPoint = self.bounds.origin;
    newPoint.x -= [sender translationInView:self].x;
    newPoint.y -= [sender translationInView:self].y;
    /* IMPORTANT in order to ALWAYS get instant translation delta,
     * we can set translation back to zero AFTER getting the current
     * translation value fron gesture recognizer.
     */
    [sender setTranslation:CGPointZero inView:self];    
    [self.scrollLayer scrollToPoint:newPoint];
}

+ (Class)layerClass {
    return [CAScrollLayer class];
}

@end
