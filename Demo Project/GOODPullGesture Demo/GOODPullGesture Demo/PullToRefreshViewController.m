//
//  FirstViewController.m
//  GOODPullGesture Demo
//
//  Created by Peyton Randolph on 2/21/12.
//  Copyright (c) 2012 pandolph. All rights reserved.
//

#import "PullToRefreshViewController.h"

@interface PullToRefreshViewController ()

@end

@implementation PullToRefreshViewController

- (id)initWithDataSource:(id<UITableViewDataSource>)dataSource delegate:(id<UITableViewDelegate>)delegate;
{
    if (!(self = [super initWithStyle:UITableViewStylePlain]))
        return nil;
    
    // Configure tab bar
    self.title = NSLocalizedString(@"Pull to Refresh", @"Pull to Refresh");
    self.tabBarItem.image = [UIImage imageNamed:nil];
    
    // Configure table view
    self.tableView.dataSource = dataSource;
    self.tableView.delegate = delegate;
    
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
