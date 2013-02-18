//
//  CustomTriggerDelegate.m
//  Demo Project
//
//  Created by Peyton Randolph on 5/29/12.
//  Copyright (c) 2012 pandolph. All rights reserved.
//

#import "CustomTriggerDelegate.h"

#import "MOOPullGestureRecognizer.h"

@implementation CustomTriggerDelegate

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if (scrollView.pullGestureRecognizer)
        [scrollView.pullGestureRecognizer scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    if (scrollView.pullGestureRecognizer)
        [scrollView.pullGestureRecognizer resetPullState];
}

@end
