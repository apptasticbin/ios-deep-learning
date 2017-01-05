//
//  CPAdvancedViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 04/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "CPAdvancedViewController.h"
#import "PlayRect.h"
#import "NSNumber+Helper.h"
#import "UIColor+Helper.h"

static const NSInteger NumberOfViews = 5;
static const CGFloat ViewsMargin = 10.0f;
static const CGFloat ViewsSpace = 10.0f;
static const CGFloat ExtraSpace = 10.0f;

typedef NS_ENUM(NSUInteger, AnimationDirection) {
    AnimationDirectionUp = 0,
    AnimationDirectionDown,
    AnimationDirectionLeft,
    AnimationDirectionRight
};

typedef void(^AnimationCompleteBlock)(void);

@interface CPAdvancedViewController ()

@property (atomic, strong) NSMutableArray<PlayRect *> *animatableViews;
@property (atomic, strong) NSMapTable<PlayRect*, NSString *> *originalFrames;
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;
@property (nonatomic, assign) CFTimeInterval lastTimeStamp;
@property (nonatomic, assign) CFTimeInterval lifeTime;

@end

@implementation CPAdvancedViewController

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (self) {
        _concurrentQueue = dispatch_queue_create(@"AnimationQueue".UTF8String, DISPATCH_QUEUE_CONCURRENT);
        _lastTimeStamp = 0;
        _lifeTime = 0;
    }
    return self;
}

- (void)initializeViewController {
    [super initializeViewController];
}

- (void)initializeViews {
    [super initializeViews];
    
    NSMutableArray<PlayRect *> *views = [NSMutableArray array];
    for (NSInteger i=0; i<NumberOfViews; i++) {
        PlayRect *view = [PlayRect rectWithColor:[UIColor randomColor]];
        [views addObject:view];
        [self.playStage addSubviewWithoutAutoResizing:view];
    }
    self.animatableViews = views;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    NSMapTable<PlayRect*, NSString *> *originalFrames = [NSMapTable weakToStrongObjectsMapTable];
    // at this moment, the frame of all views has been calculated.
    // then we can get the correct frame size of play stage
    CGFloat width = CGRectGetWidth(self.playStage.frame);
    CGFloat height = CGRectGetHeight(self.playStage.frame);
    CGFloat margin = ViewsMargin;
    CGFloat space = ViewsSpace;
    
    CGFloat widthOfView = (width - margin * 2 - space * (NumberOfViews-1)) / NumberOfViews;
    CGFloat heightOfView = widthOfView;
    CGFloat startX = margin;
    CGFloat startY = height / 3.0f;
    
    for (NSInteger i=0; i<NumberOfViews; i++) {
        PlayRect *view = self.animatableViews[i];
        CGRect frame = CGRectMake(startX+i*(space+widthOfView), startY, widthOfView, heightOfView);
        view.frame = frame;
        // store the original frame information of all views.
        [originalFrames setObject:NSStringFromCGRect(frame) forKey:view];
    }
    self.originalFrames = originalFrames;
}

#pragma mark - Control Panel

- (NSArray<PlayGroundControlAction *> *)controlPanelActions {
    return @[
             [[PlayGroundControlAction alloc] initWithName:@"Dance By GCD"
                                                    target:self
                                                    action:@selector(danceByGCD)],
             [[PlayGroundControlAction alloc] initWithName:@"First To Last"
                                                    target:self
                                                    action:@selector(firstToLast)],
             [[PlayGroundControlAction alloc] initWithName:@"Random Dance"
                                                    target:self
                                                    action:@selector(randomDance)],
             [[PlayGroundControlAction alloc] initWithName:@"Stop Dance"
                                                    target:self
                                                    action:@selector(stopDance)]
             
             ];
}

- (void)danceByGCD {
    [self animateViewsToDirection:AnimationDirectionDown complete:^{
        [self animateViewsToDirection:AnimationDirectionUp complete:nil];
    }];
    
}

// using dispatch semaphore and barrier to control the animation flow
- (void)firstToLast {
    // because that the semaphore will block the main thread. we should dispatch the task to a separate thread.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // use semaphore to block the method until animation done
        dispatch_semaphore_t stopSemaphore = dispatch_semaphore_create(0);
        
        // move first view up
        CGFloat extraSpace = ExtraSpace;
        PlayRect *firstView = self.animatableViews.firstObject;
        CGPoint firstViewPos = firstView.layer.position;
        firstViewPos.y -= CGRectGetHeight(firstView.frame)+extraSpace;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self animateView:firstView toPosition:firstViewPos duration:1.0f complete:^{
                dispatch_semaphore_signal(stopSemaphore);
            }];
        });
        
        dispatch_time_t stopTimeout = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC));
        dispatch_semaphore_wait(stopSemaphore, stopTimeout);
        
        // now move others to left
        dispatch_apply(NumberOfViews-1, self.concurrentQueue, ^(size_t idx) {
            dispatch_semaphore_t waitSemaphore = dispatch_semaphore_create(0);
            
            dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(idx)*0.3*NSEC_PER_SEC);
            dispatch_after(delay, dispatch_get_main_queue(), ^{
                // skip the first one
                UIView *view = self.animatableViews[idx+1];
                CGFloat offset = CGRectGetWidth(view.frame)+ViewsSpace;
                CGPoint newPos = [self movePosition:view.layer.position
                                        toDirection:AnimationDirectionLeft
                                           byPoints:offset];
                [self animateView:view toPosition:newPos duration:1.0f complete:^{
                    dispatch_semaphore_signal(waitSemaphore);
                }];
            });
            
            // we can not let the block exit BEFORE the animation finishing.
            // otherwise the barrier will be called immediately
            dispatch_semaphore_wait(waitSemaphore, delay+10);
        });
        
        // create a barrier block for the final animation after all movements
        dispatch_barrier_async(self.concurrentQueue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                // move right first
                CGPoint newPos = [self movePosition:firstView.layer.position toDirection:AnimationDirectionRight byPoints:(NumberOfViews-1)*(CGRectGetWidth(firstView.frame)+ViewsSpace)];
                [self animateView:firstView toPosition:newPos duration:1.0f complete:^{
                    // then move down
                    CGPoint newPos = [self movePosition:firstView.layer.position toDirection:AnimationDirectionDown byPoints:CGRectGetHeight(firstView.frame)+ExtraSpace];
                    [self animateView:firstView toPosition:newPos duration:1.0f complete:^{
                        // final step is to change the order of the views
                        [self.animatableViews removeObjectAtIndex:0];
                        [self.animatableViews insertObject:firstView atIndex:NumberOfViews-1];
                    }];
                }];
            });
        });
        
    });
}

// we try to use runloop to trigger display link, and using display link to move views randomly.
- (void)randomDance {
    // attach display link to global concurrent queue.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // create a new runloop for updating display link.
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        
        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateFrame:)];
        [displayLink addToRunLoop:runLoop forMode:NSDefaultRunLoopMode];
        
        while (1) {
            // iterate run loop manually.
            [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    });
}

- (void)updateFrame:(CADisplayLink *)sender {
    // change background color every 1 second
    
    if (!self.lastTimeStamp) {
        self.lastTimeStamp = sender.timestamp;
    } else {
        self.lifeTime += sender.timestamp - self.lastTimeStamp;
        self.lastTimeStamp = sender.timestamp;
        
        if (self.lifeTime < 0.5f) {
            return;
        }
        
        self.lifeTime -= 0.5f;
    }
    
    for (NSUInteger idx=0; idx<NumberOfViews; idx++) {
        PlayRect *view = self.animatableViews[idx];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(idx*0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                view.layer.backgroundColor = [[UIColor randomColor] CGColor];
            }];
        });
    }
}

- (void)stopDance {
    
}

#pragma mark - Private

- (CGPoint)movePosition:(CGPoint)position toDirection:(AnimationDirection)direction byPoints:(CGFloat)points {
    switch (direction) {
        case AnimationDirectionUp:
            position.y -= points;
            break;
        case AnimationDirectionDown:
            position.y += points;
            break;
        case AnimationDirectionLeft:
            position.x -= points;
            break;
        case AnimationDirectionRight:
            position.x += points;
            break;
    }
    return position;
}

- (void)animateViewsToDirection:(AnimationDirection)direction complete:(AnimationCompleteBlock)complete {
    // create a group as a sync point for multiple concurrent threads
    dispatch_group_t animationGroup = dispatch_group_create();
    
    dispatch_apply(NumberOfViews, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
        
        // dispatch_apply is a synchronous method, which will return after every iteration done.
        // but if the task inside the dispatch_apply is asynchronous one, then we need to use dispatch_group
        // as a sync point.
        // enter group for each iteration
        dispatch_group_enter(animationGroup);
        
        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(index * 0.1f * NSEC_PER_SEC));
        dispatch_after(delay, dispatch_get_main_queue(), ^{
            // first move down one after one
            UIView *view = self.animatableViews[index];
            CGPoint pos = view.layer.position;
            pos = [self movePosition:pos toDirection:direction byPoints:50.0f];
            [self animateView:view toPosition:pos duration:1.0f complete:^{
                dispatch_group_leave(animationGroup);
            }];
        });
    });
    
    dispatch_group_notify(animationGroup, dispatch_get_main_queue(), ^{
        if (complete) {
            complete();
        }
    });
}

- (void)animateView:(UIView *)view toPosition:(CGPoint)position duration:(CGFloat)duration complete:(AnimationCompleteBlock)complete {
    
    [CATransaction begin];
    
    CGPoint prePos = view.layer.position;
    // set final position first
    view.layer.position = position;
    
    CASpringAnimation *animation = [CASpringAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:prePos];
    animation.toValue = [NSValue valueWithCGPoint:position];
    animation.duration = duration;
    animation.damping = 10.0f;
    animation.initialVelocity = 0.0f;
    
    [CATransaction setCompletionBlock:^{
        if (complete) {
            complete();
        }
    }];
    
    [view.layer addAnimation:animation forKey:@"MoveAnimation"];
    
    [CATransaction commit];
}

#pragma mark - Project

+ (NSString *)name {
    return @"Advanced Playground";
}

+ (NSString *)desc {
    return @"Play more with GCD, NSRunLoop and NSOperation.";
}

+ (NSString *)groupName {
    return ProjectGroupNameConcurrentProgramming;
}

+ (instancetype)projectViewController {
    return [self new];
}

@end
