//
//  PullToCreateViewController.m
//  MOOPullGesture Demo
//
//  Created by Peyton Randolph on 2/21/12.
//

#import "PullToCreateViewController.h"

#import "PullToCreateDataSource.h"
#import "PullToCreateDelegate.h"

#import "MOOPullGestureRecognizer.h"
#import "MOOCreateView.h"

@interface PullToCreateViewController ()

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer;
- (void)_resetPullRecognizer:(UIGestureRecognizer<MOOPullGestureRecognizer> *)pullGestureRecognizer;

@end

@implementation PullToCreateViewController

- (id)initWithDataSource:(PullToCreateDataSource *)dataSource delegate:(PullToCreateDelegate *)delegate;
{
    if (!(self = [super initWithStyle:UITableViewStylePlain]))
        return nil;
    
    // Retain data source and delegate
    _dataSource = dataSource;
    _delegate = delegate;
    
    // Configure tab bar
    self.title = NSLocalizedString(@"Pull to Create", @"Pull to Create");
    self.tabBarItem.image = [UIImage imageNamed:@"Arrow-Bucket.png"];
    
    // Configure table view
    self.tableView.dataSource = dataSource;
    self.tableView.delegate = delegate;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Remove cell separators for aesthetic effect
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Add pull gesture recognizer
    MOOPullGestureRecognizer *recognizer = [[MOOPullGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    
    // Create cell
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor = self.tableView.backgroundColor;
    cell.imageView.image = [UIImage imageNamed:@"Arrow-Bucket.png"];
    // Create create view
    MOOCreateView *createView = [[MOOCreateView alloc] initWithCell:cell];
    createView.configurationBlock = ^(MOOCreateView *view, UITableViewCell *cell, MOOPullState state){
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
    };
    recognizer.triggerView = createView;
    [self.tableView addGestureRecognizer:recognizer];
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
            [self _resetPullRecognizer:(UIGestureRecognizer<MOOPullGestureRecognizer> *)gestureRecognizer];
    }
}

- (void)_resetPullRecognizer:(UIGestureRecognizer<MOOPullGestureRecognizer> *)pullGestureRecognizer;
{
    _dataSource.numberOfRows++;
    CGPoint contentOffset = self.tableView.contentOffset;
    contentOffset.y -= CGRectGetMinY(pullGestureRecognizer.triggerView.frame);
    [self.tableView reloadData];
    self.tableView.contentOffset = contentOffset;
}

@end
