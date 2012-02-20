//
//  GOODRefreshView.h
//  GOODPullGesture
//
//  Created by Peyton Randolph on 2/20/12
//  Inspired by Pier-Olivier Thibault's [PHRefreshTriggerView](https://github.com/pothibo/PHRefreshTriggerView)
//

#import <UIKit/UIKit.h>

#import "GOODPullGestureRecognizer.h"

@protocol GOODRefreshView

- (void)positionInScrollView:(UIScrollView *)scrollView;
- (void)transitionToRefreshState:(GOODRefreshState)state;

@end

@interface GOODRefreshView : UIView <GOODRefreshView> 
{
    UIActivityIndicatorView *_activityView;
    UIImageView *_arrowView;
    UILabel *_titleLabel;
    
    NSString *_loadingText;
    NSString *_pullToRefreshText;
    NSString *_releaseText;
    
    NSTimeInterval _arrowFadeAnimationDuration;
    NSTimeInterval _arrowSpinAnimationDuration;
    NSTimeInterval _contentInsetAnimationDuration;
    
    BOOL _loading;
    BOOL _triggered;
}

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSString *loadingText;
@property (nonatomic, strong) NSString *pullToRefreshText;
@property (nonatomic, strong) NSString *releaseText;

@property (nonatomic, assign) NSTimeInterval arrowFadeAnimationDuration;
@property (nonatomic, assign) NSTimeInterval arrowSpinAnimationDuration;
@property (nonatomic, assign) NSTimeInterval contentInsetAnimationDuration;

@property (nonatomic, assign, readonly, getter = isLoading) BOOL loading;
@property (nonatomic, assign, readonly, getter = isTriggered) BOOL triggered;

@end
