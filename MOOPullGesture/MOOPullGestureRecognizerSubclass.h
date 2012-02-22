//
//  MOOPullGestureRecognizerSubclass.h
//  MOOPullGesture Demo
//
//  Created by Peyton Randolph on 2/21/12.
//  Copyright (c) 2012 pandolph. All rights reserved.
//

#import "MOOPullGestureRecognizer.h"

#import "MOOTriggerView.h"

@interface MOOPullGestureRecognizer (ForSubclassEyesOnly)

@property (nonatomic, assign, getter = isFailed) BOOL failed;

- (void)dispatchEvent:(MOOEvent)event toTriggerView:(UIView<MOOTriggerView> *)triggerView withObject:(id)object;
- (BOOL)shouldFail;

@end