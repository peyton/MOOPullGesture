//
//  MOOPullGestureRecognizerSubclass.h
//  MOOPullGesture Demo
//
//  Created by Peyton Randolph on 2/21/12.
//  Copyright (c) 2012 pandolph. All rights reserved.
//

#import "MOOPullGestureRecognizer.h"

@interface MOOPullGestureRecognizer (ForSubclassEyesOnly)

@property (nonatomic, assign, getter = isFailed) BOOL failed;

- (BOOL)shouldFail;

@end