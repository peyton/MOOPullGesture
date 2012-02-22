//
//  MOOPullGestureRecognizer.h
//  MOOPullGesture
//
//  Created by Peyton Randolph on 2/20/12
//  Inspired by Pier-Olivier Thibault's [PHRefreshTriggerView](https://github.com/pothibo/PHRefreshTriggerView)
//

#import <UIKit/UIKit.h>

#import "Support/ARCHelper.h"

typedef enum {
    MOOPullIdle = 0,
    MOOPullActive,
    MOOPullTriggered
} MOOPullState;

@protocol MOOTriggerView;

@protocol MOOPullGestureRecognizer <NSObject>

@property (nonatomic, assign) MOOPullState pullState;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong) UIView<MOOTriggerView> *triggerView;

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
