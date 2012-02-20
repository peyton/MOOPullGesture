//
//  GOODPullGestureRecognizer.m
//  GOODPullGesture
//
//  Created by Peyton Randolph on 2/20/12
//  Inspired by Pier-Olivier Thibault's [PHRefreshTriggerView](https://github.com/pothibo/PHRefreshTriggerView)
//

#import "GOODPullGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

#import "GOODRefreshView.h"

static NSString * const GOODRefreshViewKeyPath = @"view";

@implementation GOODPullGestureRecognizer
@synthesize triggerView = _triggerView;
@synthesize refreshState = _refreshState;

- (id)initWithTarget:(id)target action:(SEL)action;
{    
    if (!(self = [super initWithTarget:target action:action]))
        return nil;
    
    // Create trigger view
    self.triggerView = [[GOODRefreshView alloc] initWithFrame:CGRectZero];
    
    // Configure KVO
    [self addObserver:self forKeyPath:GOODRefreshViewKeyPath options:NSKeyValueObservingOptionNew context:NULL];
        
    return self;
}

- (void)dealloc;
{
    [self removeObserver:self forKeyPath:GOODRefreshViewKeyPath];
    self.triggerView = nil;
}

#pragma mark - Getters and setters

- (void)setRefreshState:(GOODRefreshState)refreshState;
{
    if (refreshState == self.refreshState)
        return;
    
    _refreshState = refreshState;
    [self.triggerView transitionToRefreshState:refreshState];
}

- (UIScrollView *)scrollView;
{
    return (UIScrollView *)self.view;
}

- (void)setTriggerView:(UIView<GOODRefreshView> *)triggerView;
{
    if (triggerView == self.triggerView)
        return;
    
    [_triggerView removeFromSuperview];
    _triggerView = triggerView;
    [_triggerView transitionToRefreshState:self.refreshState];
}

#pragma mark - KVO methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
    id newValue = [change valueForKey:NSKeyValueChangeNewKey];
    
    if ([keyPath isEqualToString:GOODRefreshViewKeyPath])
        if ([newValue isKindOfClass:[UIScrollView class]])
        {
            _triggerFlags.isBoundToScrollView = YES;
            [newValue addSubview:self.triggerView];
            [self.triggerView positionInScrollView:newValue];
        } else
            _triggerFlags.isBoundToScrollView = NO;

}

#pragma mark - UIGestureRecognizer methods
- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer;
{
    return NO;
}
- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer;
{
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
{
    if (self.refreshState == GOODRefreshLoading || !_triggerFlags.isBoundToScrollView)
    {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
{
    if (self.refreshState == GOODRefreshLoading)
    {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    
    if (_triggerFlags.isBoundToScrollView)
        if (self.scrollView.contentOffset.y < CGRectGetMinY(self.triggerView.frame))
            self.refreshState = GOODRefreshTriggered;
        else if (self.state != UIGestureRecognizerStateRecognized)
            self.refreshState = GOODRefreshIdle;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    if (self.refreshState == GOODRefreshLoading)
    {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    
    if (_triggerFlags.isBoundToScrollView)
        if (self.refreshState == GOODRefreshTriggered)
        {
            self.refreshState = GOODRefreshLoading;
            self.state = UIGestureRecognizerStateRecognized;
        } else {
            self.refreshState = GOODRefreshIdle;
            self.state = UIGestureRecognizerStateFailed;
        }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
{
    self.state = UIGestureRecognizerStateFailed;
}

@end

#pragma mark - UIScrollView category

@implementation UIScrollView (GOODPullGestureRecognizer)

- (GOODPullGestureRecognizer *)refreshGestureRecognizer;
{
    for (UIGestureRecognizer *recognizer in self.gestureRecognizers)
        if ([recognizer isKindOfClass:[GOODPullGestureRecognizer class]])
            return (GOODPullGestureRecognizer *)recognizer;
    return nil;
}

@end
