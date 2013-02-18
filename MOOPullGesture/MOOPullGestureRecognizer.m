//
//  MOOPullGestureRecognizer.m
//  MOOPullGesture
//
//  Created by Peyton Randolph on 2/20/12
//  Inspired by Pier-Olivier Thibault's [PHRefreshTriggerView](https://github.com/pothibo/PHRefreshTriggerView)
//

#import "MOOPullGestureRecognizer.h"
#import "MOOPullGestureRecognizerSubclass.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

#import "MOOTriggerView.h"
#import "MOORefreshView.h"

static NSString * const MOOAttachedViewKeyPath = @"view";

@implementation MOOPullGestureRecognizer
@synthesize pullState = _pullState;
@synthesize triggerView = _triggerView;

@dynamic failed;
@dynamic scrollView;

- (id)initWithTarget:(id)target action:(SEL)action;
{
    if (!(self = [super initWithTarget:target action:action]))
        return nil;
    
    // Configure KVO
    [self addObserver:self forKeyPath:MOOAttachedViewKeyPath options:NSKeyValueObservingOptionNew context:(__bridge void *)MOOAttachedViewKeyPath];
        
    return self;
}

- (void)dealloc;
{
    // Clean up KVO
    [self removeObserver:self forKeyPath:MOOAttachedViewKeyPath];
    
    // Clean up memory
    self.triggerView = nil;
}

#pragma mark - MOOPullGestureRecognizer methods

- (void)resetPullState;
{
    self.pullState = MOOPullIdle;
}

- (BOOL)shouldFail;
{
    return  self.pullState == MOOPullTriggered || 
            self.state == UIGestureRecognizerStateFailed ||
            !_pullGestureFlags.isBoundToScrollView;
}

#pragma mark - UIGestureRecognizer methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
{
    [super touchesBegan:touches withEvent:event];
    
    if ((self.failed = [self shouldFail]))
        return;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
{
    [super touchesMoved:touches withEvent:event];
    
    if ((self.failed = [self shouldFail]))
        return;
    
    if (self.scrollView.contentOffset.y <= CGRectGetMinY(self.triggerView.frame))
        self.pullState = MOOPullActive;
    else if (self.state != UIGestureRecognizerStateRecognized)
        self.pullState = MOOPullIdle;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    [super touchesEnded:touches withEvent:event];
    
    if ((self.failed = [self shouldFail]))
        return;
    
    if (self.pullState == MOOPullActive)
    {
        self.pullState = MOOPullTriggered;
        self.state = UIGestureRecognizerStateRecognized;
    } else {
        self.pullState = MOOPullIdle;
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
{
    self.failed = YES;
}

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer;
{
    return NO;
}
- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer;
{
    return NO;
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if (scrollView != self.view)
        return;
    
    if (scrollView.contentOffset.y >= 0.0f)
        return;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MOONotificationContentOffsetChanged object:self userInfo:[NSDictionary dictionaryWithObject:[NSValue valueWithCGPoint:scrollView.contentOffset] forKey:MOOKeyContentOffset]];
}

#pragma mark - Getters and setters

- (BOOL)isFailed;
{
    return self.state == UIGestureRecognizerStateFailed;
}

- (void)setFailed:(BOOL)failed;
{
    if (failed == self.isFailed)
        return;
    
    if (failed)
        self.state = UIGestureRecognizerStateFailed;
}

- (void)setPullState:(MOOPullState)pullState;
{
    if (pullState == self.pullState)
        return;
    
    _pullState = pullState;
    [self.triggerView transitionToPullState:pullState];
}

- (UIScrollView *)scrollView;
{
    return (UIScrollView *)self.view;
}

- (UIView<MOOTriggerView> *)triggerView;
{
    if (!_triggerView)
        self.triggerView = [[MOORefreshView alloc] initWithFrame:CGRectZero];
    
    return _triggerView;
}

- (void)setTriggerView:(UIView<MOOTriggerView> *)triggerView;
{
    if (triggerView == _triggerView)
        return;
    
    // Remove trigger view from its previous view
    [_triggerView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:_triggerView name:MOONotificationContentOffsetChanged object:nil];
    
    // Configure new trigger view
    _triggerView = triggerView;
    [_triggerView positionInScrollView:self.scrollView];
    [_triggerView transitionToPullState:self.pullState];
}

#pragma mark - KVO methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
    id newValue = [change valueForKey:NSKeyValueChangeNewKey];
    
    if (context == (__bridge void *)MOOAttachedViewKeyPath)
	{
        if ([newValue isKindOfClass:[UIScrollView class]])
        {
            _pullGestureFlags.isBoundToScrollView = YES;
            [newValue addSubview:self.triggerView];
            [self.triggerView positionInScrollView:newValue];
        } else {
            _pullGestureFlags.isBoundToScrollView = NO;
        }
	}
}

@end

#pragma mark - UIScrollView accessory

@implementation UIScrollView (MOOPullGestureRecognizer)

- (UIGestureRecognizer<MOOPullGestureRecognizer> *)pullGestureRecognizer;
{
    for (UIGestureRecognizer *recognizer in self.gestureRecognizers)
        if ([recognizer conformsToProtocol:@protocol(MOOPullGestureRecognizer)])
            return (UIGestureRecognizer<MOOPullGestureRecognizer> *)recognizer;
    return nil;
}

@end
