//
//  PullToRefreshViewController.h
//  MOOPullGesture Demo
//
//  Created by Peyton Randolph on 2/21/12.
//


@class PullToRefreshDataSource, PullToRefreshDelegate;

@interface PullToRefreshViewController : UITableViewController
{
    PullToRefreshDataSource *_dataSource;
    PullToRefreshDelegate *_delegate;
}

- (id)initWithDataSource:(PullToRefreshDataSource *)dataSource delegate:(PullToRefreshDelegate *)delegate;

@end
