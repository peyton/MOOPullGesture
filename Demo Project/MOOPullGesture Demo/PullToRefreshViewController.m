//
//  PullToRefreshViewController.m
//  MOOPullGesture Demo
//
//  Created by Peyton Randolph on 2/21/12.
//

#import "PullToRefreshViewController.h"

#import "MOOPullGestureRecognizer.h"

@interface PullToRefreshViewController ()

- (void)_stateChanged:(UIGestureRecognizer *)gestureRecognizer;
- (void)_resetPullRecognizer:(MOOPullGestureRecognizer *)gestureRecognizer;

@end

@implementation PullToRefreshViewController

- (id)initWithDataSource:(id<UITableViewDataSource>)dataSource delegate:(id<UITableViewDelegate>)delegate;
{
    if (!(self = [super initWithStyle:UITableViewStylePlain]))
        return nil;
    
    // Configure tab bar
    self.title = NSLocalizedString(@"Pull to Refresh", @"Pull to Refresh");
    self.tabBarItem.image = [UIImage imageNamed:@"Circle-Arrow.png"];
    
    // Configure table view
    self.tableView.dataSource = dataSource;
    self.tableView.delegate = delegate;
    
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Add pull gesture recognizer
    [self.tableView addGestureRecognizer:[[MOOPullGestureRecognizer alloc] initWithTarget:self action:@selector(_stateChanged:)]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - MOOPullGestureRecognizer targets

- (void)_stateChanged:(UIGestureRecognizer *)gestureRecognizer;
{
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        if ([gestureRecognizer isKindOfClass:[MOOPullGestureRecognizer class]])
            [self performSelector:@selector(_resetPullRecognizer:) withObject:gestureRecognizer afterDelay:2.0];
    }
}

- (void)_resetPullRecognizer:(MOOPullGestureRecognizer *)gestureRecognizer;
{
    [gestureRecognizer setRefreshState:MOORefreshIdle];
}

@end
