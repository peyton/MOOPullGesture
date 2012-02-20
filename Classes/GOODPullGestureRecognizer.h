//
//  GOODPullGestureRecognizer.h
//  GOODPullGesture
//
//  Created by Peyton Randolph on 2/20/12
//  Inspired by Pier-Olivier Thibault's [PHRefreshTriggerView](https://github.com/pothibo/PHRefreshTriggerView)
//

#import <UIKit/UIKit.h>

typedef enum {
    GOODRefreshIdle = 0,
    GOODRefreshTriggered,
    GOODRefreshLoading
} GOODRefreshState;

@protocol GOODRefreshView;

@interface GOODPullGestureRecognizer : UIGestureRecognizer {
    GOODRefreshState _refreshState;
    UIView<GOODRefreshView> *_triggerView;
    
    struct {
        BOOL isBoundToScrollView:1;
    } _triggerFlags;
}

@property (nonatomic, assign) GOODRefreshState refreshState;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

@property (nonatomic, strong) UIView<GOODRefreshView> *triggerView;

@end

@interface UIScrollView (GOODPullGestureRecognizer)

- (GOODPullGestureRecognizer *)refreshGestureRecognizer;

@end