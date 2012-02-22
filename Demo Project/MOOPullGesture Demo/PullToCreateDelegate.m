//
//  PullToCreateDelegate.m
//  MOOPullGesture Demo
//
//  Created by Peyton Randolph on 2/21/12.
//

#import "PullToCreateDelegate.h"

@implementation PullToCreateDelegate

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if (scrollView.pullGestureRecognizer == nil)
        return;
    
    if (scrollView.contentOffset.y >= 0.0f)
        return;
    
    [scrollView.pullGestureRecognizer dispatchEvent:MOOEventContentOffsetChanged toTriggerView:scrollView.pullGestureRecognizer.triggerView withObject:[NSNumber numberWithFloat:scrollView.contentOffset.y]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    if (scrollView.pullGestureRecognizer)
        [scrollView.pullGestureRecognizer resetPullState];
}

@end
