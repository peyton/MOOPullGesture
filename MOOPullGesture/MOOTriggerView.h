//
//  MOOView.h
//  MOOPullGesture Demo
//
//  Created by Peyton Randolph on 2/21/12.
//

#import <UIKit/UIKit.h>

#import "MOOPullGestureRecognizer.h"

@protocol MOOTriggerView <NSObject>

- (void)positionInScrollView:(UIScrollView *)scrollView;
- (void)transitionToPullState:(MOOPullState)pullState;

@optional

@property (nonatomic, assign, readonly) NSUInteger events;
- (void)handleEvent:(MOOEvent)event withObject:(id)object;

@end
