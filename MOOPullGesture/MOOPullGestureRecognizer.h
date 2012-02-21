//
//  MOOPullGestureRecognizer.h
//  MOOPullGesture
//
//  Created by Peyton Randolph on 2/20/12
//  Inspired by Pier-Olivier Thibault's [PHRefreshTriggerView](https://github.com/pothibo/PHRefreshTriggerView)
//

#import <UIKit/UIKit.h>

#import "ARCHelper.h"

typedef enum {
    MOORefreshIdle = 0,
    MOORefreshTriggered,
    MOORefreshLoading
} MOORefreshState;

@protocol MOORefreshView;

@interface MOOPullGestureRecognizer : UIGestureRecognizer {
    MOORefreshState _refreshState;
    UIView<MOORefreshView> *_triggerView;
    
    struct {
        BOOL isBoundToScrollView:1;
    } _triggerFlags;
}

@property (nonatomic, assign) MOORefreshState refreshState;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

@property (nonatomic, strong) UIView<MOORefreshView> *triggerView;

@end

@interface UIScrollView (MOOPullGestureRecognizer)

- (MOOPullGestureRecognizer *)refreshGestureRecognizer;

@end