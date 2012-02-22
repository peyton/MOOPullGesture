//
//  PullToRefreshViewController.h
//  MOOPullGesture Demo
//
//  Created by Peyton Randolph on 2/21/12.
//

#import <UIKit/UIKit.h>

@class PullToRefreshDataSource, PullToRefreshDelegate;

@interface PullToRefreshViewController : UITableViewController
{
    PullToRefreshDataSource *_dataSource;
    PullToRefreshDelegate *_delegate;
}

- (id)initWithDataSource:(PullToRefreshDataSource *)dataSource delegate:(PullToRefreshDelegate *)delegate;

@end
