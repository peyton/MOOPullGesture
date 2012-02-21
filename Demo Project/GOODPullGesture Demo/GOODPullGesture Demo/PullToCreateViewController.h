//
//  SecondViewController.h
//  GOODPullGesture Demo
//
//  Created by Peyton Randolph on 2/21/12.
//  Copyright (c) 2012 pandolph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PullToCreateViewController : UITableViewController

- (id)initWithDataSource:(id<UITableViewDataSource>)dataSource delegate:(id<UITableViewDelegate>)delegate;

@end
