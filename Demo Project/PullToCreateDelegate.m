//
//  PullToCreateDelegate.m
//  Demo Project
//
//  Created by Peyton Randolph on 2/21/12.
//

#import "PullToCreateDelegate.h"

#import "MOOPullGestureRecognizer.h"

@implementation PullToCreateDelegate

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

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
