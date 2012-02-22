//
//  PullToCreateDelegate.m
//  MOOPullGesture Demo
//
//  Created by Peyton Randolph on 2/21/12.
//

#import "PullToCreateDelegate.h"

@implementation PullToCreateDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
