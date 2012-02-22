//
//  PullToRefreshDelegate.m
//  MOOPullGesture Demo
//
//  Created by Peyton Randolph on 2/21/12.
//

#import "PullToRefreshDelegate.h"

@implementation PullToRefreshDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
