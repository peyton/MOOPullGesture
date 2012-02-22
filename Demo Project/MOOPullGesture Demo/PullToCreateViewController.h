//
//  PullToCreateViewController.h
//  MOOPullGesture Demo
//
//  Created by Peyton Randolph on 2/21/12.
//

#import <UIKit/UIKit.h>

@class PullToCreateDataSource, PullToCreateDelegate;

@interface PullToCreateViewController : UITableViewController
{
    PullToCreateDataSource *_dataSource;
    PullToCreateDelegate *_delegate;
}

- (id)initWithDataSource:(PullToCreateDataSource *)dataSource delegate:(PullToCreateDelegate *)delegate;

@end
