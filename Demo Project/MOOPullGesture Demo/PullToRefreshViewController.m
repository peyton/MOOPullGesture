//
//  PullToRefreshViewController.m
//  MOOPullGesture Demo
//
//  Created by Peyton Randolph on 2/21/12.
//

#import "PullToRefreshViewController.h"

#import "MOOPullGestureRecognizer.h"

@interface PullToRefreshViewController ()

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer;
- (void)_resetPullRecognizer:(UIGestureRecognizer<MOOPullGestureRecognizer> *)gestureRecognizer;

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
    [self.tableView addGestureRecognizer:[[MOOPullGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - MOOPullGestureRecognizer targets

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer;
{
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        if ([gestureRecognizer conformsToProtocol:@protocol(MOOPullGestureRecognizer)])
            [self performSelector:@selector(_resetPullRecognizer:) withObject:gestureRecognizer afterDelay:2.0];
    }
}

- (void)_resetPullRecognizer:(UIGestureRecognizer<MOOPullGestureRecognizer> *)pullGestureRecognizer;
{
    pullGestureRecognizer.pullState = MOOPullIdle;
}

@end
