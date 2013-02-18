//
//  MOOPullGestureRecognizerSubclass.h
//  MOOPullGesture
//
//  Created by Peyton Randolph on 2/21/12.
//

#import "MOOPullGestureRecognizer.h"

#import "MOOTriggerView.h"

@interface MOOPullGestureRecognizer (ForSubclassEyesOnly)

@property (nonatomic, assign, getter = isFailed) BOOL failed;

- (BOOL)shouldFail;

@end
