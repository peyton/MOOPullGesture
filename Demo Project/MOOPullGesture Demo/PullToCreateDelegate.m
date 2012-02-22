//
//  PullToCreateDelegate.m
//  MOOPullGesture Demo
//
//  Created by Peyton Randolph on 2/21/12.
//

#import "PullToCreateDelegate.h"

@implementation PullToCreateDelegate

#pragma mark - MOOCreateViewDelegate methods

- (void)createView:(MOOCreateView *)createView configureCell:(UITableViewCell *)cell forState:(MOOPullState)state;
{
    if (![cell isKindOfClass:[UITableViewCell class]])
        return;

    switch (state)
    {
        case MOOPullActive:
        case MOOPullTriggered:
            cell.textLabel.text = NSLocalizedStringFromTable(@"Release to create item\u2026", @"MOOPullGesture", @"Release to create item");
            break;
        case MOOPullIdle:
            cell.textLabel.text = NSLocalizedStringFromTable(@"Pull to create item\u2026", @"MOOPullGesture", @"Pull to create item");
            break;
            
    }
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
