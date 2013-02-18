//
//  CustomTriggerViewController.h
//  Demo Project
//
//  Created by Peyton Randolph on 5/29/12.
//

@class CustomTriggerDataSource, CustomTriggerDelegate;

@interface CustomTriggerViewController : UITableViewController
{
    CustomTriggerDataSource *_dataSource;
    CustomTriggerDelegate *_delegate;
}

- (id)initWithDataSource:(CustomTriggerDataSource *)dataSource delegate:(CustomTriggerDelegate *)delegate;

@end
