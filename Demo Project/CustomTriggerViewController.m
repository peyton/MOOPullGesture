//
//  CustomTriggerViewController.m
//  Demo Project
//
//  Created by Peyton Randolph on 5/29/12.
//

#import "CustomTriggerViewController.h"

#import "MOOPullGestureRecognizer.h"

#import "CustomTriggerDataSource.h"
#import "CustomTriggerDelegate.h"
#import "CustomTriggerView.h"

@interface CustomTriggerViewController ()

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer;
- (void)_pulled:(UIGestureRecognizer<MOOPullGestureRecognizer> *)pullGestureRecognizer;

@end

@implementation CustomTriggerViewController

- (id)initWithDataSource:(CustomTriggerDataSource *)dataSource delegate:(CustomTriggerDelegate *)delegate;
{
    if (!(self = [super initWithStyle:UITableViewStylePlain]))
        return nil;
    
    // Retain data source and delegate
    _dataSource = dataSource;
    _delegate = delegate;
    
    // Configure tab bar
    self.title = NSLocalizedString(@"Custom Trigger", @"Custom Trigger");
    self.tabBarItem.image = [UIImage imageNamed:@"Square.png"];
    
    // Configure table view
    self.tableView.dataSource = dataSource;
    self.tableView.delegate = delegate;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Create custom trigger view
    CustomTriggerView *triggerView = [[CustomTriggerView alloc] initWithFrame:CGRectZero];
    
    // Add pull gesture recognizer
    MOOPullGestureRecognizer *pullGesture = [[MOOPullGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    pullGesture.triggerView = triggerView;
    [self.tableView addGestureRecognizer:pullGesture];
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
            [self _pulled:(UIGestureRecognizer<MOOPullGestureRecognizer> *)gestureRecognizer];
    }
}

- (void)_pulled:(UIGestureRecognizer<MOOPullGestureRecognizer> *)pullGestureRecognizer;
{
    NSLog(@"Pulled!");
    [pullGestureRecognizer resetPullState];
}

@end
