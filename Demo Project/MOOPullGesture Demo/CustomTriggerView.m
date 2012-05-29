//
//  CustomTriggerView.m
//  MOOPullGesture Demo
//
//  Created by Peyton Randolph on 5/29/12.
//  Copyright (c) 2012 pandolph. All rights reserved.
//

#import "CustomTriggerView.h"

@interface CustomTriggerView ()

- (void)handleContentOffsetChangedNotification:(NSNotification *)notification;

@end

@implementation CustomTriggerView

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    self.backgroundColor = [UIColor greenColor];
    
    // Create state label
    _stateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _stateLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_stateLabel];
    
    // Create offset label
    _offsetLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _offsetLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_offsetLabel];
    
    return self;
}

- (void)dealloc;
{
    // Deregister for previous content offset change notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MOONotificationContentOffsetChanged object:nil];
}

- (void)layoutSubviews;
{
    [_stateLabel sizeToFit];
    [_offsetLabel sizeToFit];
    
    CGRect offsetLabelFrame = _offsetLabel.frame;
    offsetLabelFrame.origin = CGPointMake(0.0f, CGRectGetMaxY(_stateLabel.frame));
    _offsetLabel.frame = offsetLabelFrame;
}

- (void)positionInScrollView:(UIScrollView *)scrollView;
{
    // Deregister for previous content offset change notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MOONotificationContentOffsetChanged object:nil];
    
    // Register for content offset change notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleContentOffsetChangedNotification:) name:MOONotificationContentOffsetChanged object:scrollView.pullGestureRecognizer];
    
    // Size trigger view
    CGSize triggerViewSize = CGSizeMake(CGRectGetWidth(scrollView.bounds), 50.0f);
    CGPoint triggerViewOrigin = CGPointMake(0.0, -triggerViewSize.height);
    
    CGRect triggerViewFrame = CGRectZero;
    triggerViewFrame.size = triggerViewSize;
    triggerViewFrame.origin = triggerViewOrigin;
    self.frame = triggerViewFrame;
}

- (void)transitionToPullState:(MOOPullState)pullState;
{
    NSString *stateString;
    
    switch (pullState)
    {
        case MOOPullActive:
            stateString = @"Active";
            break;
        case MOOPullIdle:
            stateString = @"Idle";
            break;
        case MOOPullTriggered:
            stateString = @"Triggered";
            break;
    }
    
    _stateLabel.text = stateString;
    [self setNeedsLayout];
}

- (void)handleContentOffsetChangedNotification:(NSNotification *)notification;
{
    // Grab content offset
    CGPoint contentOffset = [[notification.userInfo objectForKey:MOOKeyContentOffset] CGPointValue];
    
    _offsetLabel.text = [NSString stringWithFormat:@"%@", NSStringFromCGPoint(contentOffset)];
    [self setNeedsLayout];
}

@end
