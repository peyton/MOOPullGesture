//
//  MOOTriggerView.h
//  MOOPullGesture
//
//  Created by Peyton Randolph on 2/21/12.
//

#import <UIKit/UIKit.h>

#import "MOOPullGestureRecognizer.h"

@protocol MOOTriggerView <NSObject>

- (void)positionInScrollView:(UIScrollView *)scrollView;
- (void)transitionToPullState:(MOOPullState)pullState;

@end
