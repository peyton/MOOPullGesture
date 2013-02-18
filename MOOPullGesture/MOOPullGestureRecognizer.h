//
//  MOOPullGestureRecognizer.h
//  MOOPullGesture
//
//  Created by Peyton Randolph on 2/20/12
//  Inspired by Pier-Olivier Thibault's [PHRefreshTriggerView](https://github.com/pothibo/PHRefreshTriggerView)
//

#import <UIKit/UIKit.h>

// States
typedef enum {
    MOOPullIdle = 0, // Threshold not reached, e.g. "Pull to refresh..."
    MOOPullActive, // Threshold reached, e.g. "Release to refresh..."
    MOOPullTriggered // Gesture ended past threshold, e.g. "Loading..."
} MOOPullState;

// Notifications
static NSString * const MOONotificationContentOffsetChanged = @"MOONotificationContentOffsetChanged";

// Keys
static NSString * const MOOKeyContentOffset = @"MOOKeyContentOffset";

@protocol MOOTriggerView;

@protocol MOOPullGestureRecognizer <UIScrollViewDelegate>

@property (nonatomic, assign) MOOPullState pullState;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong) UIView<MOOTriggerView> *triggerView;

- (void)resetPullState;

@end
@interface MOOPullGestureRecognizer : UIGestureRecognizer <MOOPullGestureRecognizer> {
    UIView<MOOTriggerView> *_triggerView;
    
    BOOL _failed;
    MOOPullState _pullState;
    
    struct {
        BOOL isBoundToScrollView:1;
    } _pullGestureFlags;
}

@property (nonatomic, assign, getter = isFailed, readonly) BOOL failed;

@end

@interface UIScrollView (MOOPullGestureRecognizer)

@property (nonatomic, strong, readonly) UIGestureRecognizer<MOOPullGestureRecognizer> *pullGestureRecognizer;

@end
