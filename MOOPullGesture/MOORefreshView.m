//
//  MOORefreshView.m
//  MOOPullGesture
//
//  Created by Peyton Randolph
//  Inspired by Pier-Olivier Thibault's [PHRefreshTriggerView](https://github.com/pothibo/PHRefreshTriggerView)
//

#import "MOORefreshView.h"

#ifdef __IPHONE_6_0
# define TEXT_ALIGN_CENTER NSTextAlignmentCenter
#else
# define TEXT_ALIGN_CENTER UITextAlignmentCenter
#endif

// KVO key paths
static NSString * const MOORefreshTriggerViewActivityViewKeyPath = @"activityView";
static NSString * const MOORefreshTriggerViewArrowViewKeyPath = @"arrowView";
static NSString * const MOORefreshTriggerViewTitleLabelKeyPath = @"titleLabel";

@interface MOORefreshView ()

@property (nonatomic, assign, getter = isLoading) BOOL loading;
@property (nonatomic, assign, getter = isTriggered) BOOL triggered;

@end

@implementation MOORefreshView
@synthesize activityView = _activityView;
@synthesize arrowView = _arrowView;
@synthesize titleLabel = _titleLabel;

@synthesize loadingText = _loadingText;
@synthesize pullToRefreshText = _pullToRefreshText;
@synthesize releaseText = _releaseText;

@synthesize arrowFadeAnimationDuration = _arrowFadeAnimationDuration;
@synthesize arrowSpinAnimationDuration = _arrowSpinAnimationDuration;
@synthesize contentInsetAnimationDuration = _contentInsetAnimationDuration;

@synthesize loading = _loading;
@synthesize triggered = _triggered;

- (id)initWithFrame:(CGRect)frame;
{
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    // Configure view
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // Initialize KVO
    [self addObserver:self forKeyPath:MOORefreshTriggerViewActivityViewKeyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(__bridge void *)MOORefreshTriggerViewActivityViewKeyPath];
    [self addObserver:self forKeyPath:MOORefreshTriggerViewArrowViewKeyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(__bridge void *)MOORefreshTriggerViewArrowViewKeyPath];
    [self addObserver:self forKeyPath:MOORefreshTriggerViewTitleLabelKeyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(__bridge void *)MOORefreshTriggerViewTitleLabelKeyPath];
    
    // Initialize activityView
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    // Initialize arrowView
    NSString *arrowPath = [[NSBundle mainBundle] pathForResource:@"Circle-Arrow" ofType:@"png"];
    self.arrowView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:arrowPath]];
    
    // Initialize titleLabel
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    self.titleLabel.textAlignment = TEXT_ALIGN_CENTER;
    
    // Set defaults
    self.loadingText = NSLocalizedStringFromTable(@"Loading...", @"MOOPullGesture", @"Loading table view contents");
    self.pullToRefreshText = NSLocalizedStringFromTable(@"Pull to refresh...", @"MOOPullGesture", @"User may pull table view down to refresh");
    self.releaseText = NSLocalizedStringFromTable(@"Release to refresh...", @"MOOPullGesture", @"User pulled table view down past threshold");
    
    self.arrowFadeAnimationDuration = 0.18;
    self.arrowSpinAnimationDuration = 0.18;
    self.contentInsetAnimationDuration = 0.3;
    
    self.loading = NO;
    self.triggered = NO;
    
    return self;
}

- (void)dealloc;
{
    self.activityView = nil;
    self.arrowView  = nil;
    self.titleLabel = nil;
    
    [self removeObserver:self forKeyPath:MOORefreshTriggerViewActivityViewKeyPath];
    [self removeObserver:self forKeyPath:MOORefreshTriggerViewArrowViewKeyPath];
    [self removeObserver:self forKeyPath:MOORefreshTriggerViewTitleLabelKeyPath];
    
    self.loadingText = nil;
    self.pullToRefreshText = nil;
    self.releaseText = nil;
}

#pragma mark - Subview methods

- (void)didAddSubview:(UIView *)subview;
{
    [self setNeedsLayout];
}

- (void)layoutSubviews;
{
    // Note: To eliminate dependency on QuartzCore, views are positioned by their frames instead of by [CALayer position]
    
    // Position activityView
    [self.activityView sizeToFit];
    CGRect activityViewFrame = self.activityView.frame;
    activityViewFrame.origin = CGPointMake(30.0f - CGRectGetWidth(activityViewFrame) / 2.0f, (CGRectGetHeight(self.bounds) - CGRectGetHeight(activityViewFrame)) / 2.0f);
    self.activityView.frame = CGRectIntegral(activityViewFrame);
    
    // Position arrowView
    [self.arrowView sizeToFit];
    CGRect arrowViewFrame = self.arrowView.frame;
    arrowViewFrame.origin = CGPointMake(30.0f - CGRectGetWidth(arrowViewFrame) / 2.0f, (CGRectGetHeight(self.bounds) - CGRectGetHeight(arrowViewFrame)) / 2.0f);
    self.arrowView.frame = CGRectIntegral(arrowViewFrame);
        
    // Position titleLabel
    [self.titleLabel sizeToFit];
    CGRect titleLabelFrame = self.titleLabel.frame;
    titleLabelFrame.origin = CGPointMake((CGRectGetWidth(self.bounds) - CGRectGetWidth(titleLabelFrame)) / 2.0f, (CGRectGetHeight(self.bounds) - CGRectGetHeight(titleLabelFrame)) / 2.0f);
    self.titleLabel.frame = CGRectIntegral(titleLabelFrame);
}

- (CGSize)sizeThatFits:(CGSize)size;
{
    return CGSizeMake(size.width, 64.0f);
}

#pragma mark - MOOTriggerView methods

- (void)positionInScrollView:(UIScrollView *)scrollView;
{
    // Size trigger view
    CGSize triggerViewSize = [self sizeThatFits:CGSizeMake(CGRectGetWidth(scrollView.bounds), HUGE_VALF)];
    CGPoint triggerViewOrigin = CGPointMake(0.0, -triggerViewSize.height);
    
    CGRect triggerViewFrame = CGRectZero;
    triggerViewFrame.size = triggerViewSize;
    triggerViewFrame.origin = triggerViewOrigin;
    self.frame = triggerViewFrame;
}

- (void)transitionToPullState:(MOOPullState)pullState;
{
    switch (pullState) {
        case MOOPullActive:
        {
            [UIView animateWithDuration:self.arrowSpinAnimationDuration delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.arrowView.transform = CGAffineTransformMakeRotation(M_PI);
            } completion:NULL];

            self.titleLabel.text = self.releaseText;
            self.triggered = YES;
            
            break;
        }
        case MOOPullIdle:
        {
            void (^updateTitle)(void) = ^{
                self.titleLabel.text = self.pullToRefreshText;
            };
            if (self.isLoading)
            {
                [UIView animateWithDuration:self.contentInsetAnimationDuration delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    UIScrollView *scrollView = (UIScrollView *)self.superview;
                    scrollView.contentInset = UIEdgeInsetsMake(0.0f, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right);
                } completion:^(BOOL finished) {
                    [self.activityView stopAnimating];
                    self.arrowView.transform = CGAffineTransformIdentity;
                    self.arrowView.alpha = 1.0f;
                    
                    updateTitle();
                }];
                
                self.loading = NO;
            } else if (self.isTriggered)
            {
                [UIView animateWithDuration:self.arrowSpinAnimationDuration delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    self.arrowView.transform = CGAffineTransformMakeRotation(0.0f);
                } completion:NULL];   
                
                updateTitle();
                
                self.triggered = NO;
            } else {
                updateTitle();
            }
            
            break;
        }
        case MOOPullTriggered:
        {
            [UIView animateWithDuration:self.contentInsetAnimationDuration animations:^{
                UIScrollView *scrollView = (UIScrollView *)self.superview;
                scrollView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.bounds), scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right);
            }];
            
            [self.activityView startAnimating];
            [UIView animateWithDuration:self.arrowFadeAnimationDuration delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.arrowView.alpha = 0.0f;
            } completion:NULL];
            
            self.titleLabel.text = self.loadingText;
            
            self.loading = YES;
            
            break;
        }
    }
    
    [self setNeedsLayout];
}

#pragma mark - KVO methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
    id oldObject = [change objectForKey:NSKeyValueChangeOldKey];
    id newObject = [change objectForKey:NSKeyValueChangeNewKey];
    
    // Swap subviews
    if (context == (__bridge void *)MOORefreshTriggerViewActivityViewKeyPath || context == (__bridge void *)MOORefreshTriggerViewArrowViewKeyPath || context == (__bridge void *)MOORefreshTriggerViewTitleLabelKeyPath)
    {
        if (oldObject != [NSNull null])
            [(UIView *)oldObject removeFromSuperview];
        if (newObject != [NSNull null])
            [self addSubview:(UIView *)newObject];
    }
}

@end
