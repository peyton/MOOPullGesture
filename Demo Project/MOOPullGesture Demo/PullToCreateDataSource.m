//
//  PullToCreateDataSource.m
//  MOOPullGesture Demo
//
//  Created by Peyton Randolph on 2/21/12.
//

#import "PullToCreateDataSource.h"

@implementation PullToCreateDataSource
@synthesize numberOfRows = _numberOfRows;

- (id)init;
{
    if (!(self = [super init]))
        return nil;
    
    self.numberOfRows = 3;
    
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{    
    return self.numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
	cell.textLabel.text = (self.numberOfRows - indexPath.row > 3) ? @"New cell!" : @"Cell";
	return cell;
}

@end
