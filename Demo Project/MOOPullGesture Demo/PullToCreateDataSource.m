//
//  PullToCreateDataSource.m
//  MOOPullGesture Demo
//
//  Created by Peyton Randolph on 2/21/12.
//

#import "PullToCreateDataSource.h"

#import "HipsterIpsumGenerator.h"

@implementation PullToCreateDataSource
@synthesize numberOfRows = _numberOfRows;

- (id)init;
{
    if (!(self = [super init]))
        return nil;
    
    _phrases = [NSMutableArray array];
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
    
	cell.textLabel.text = [_phrases objectAtIndex:indexPath.row];
	return cell;
}

#pragma mark - Getters and setters

- (void)setNumberOfRows:(NSUInteger)numberOfRows;
{
    if (numberOfRows == self.numberOfRows)
        return;
    
    NSInteger difference = numberOfRows - self.numberOfRows;
    _numberOfRows = numberOfRows;
    
    for (NSUInteger i = 0; i < difference; i++)
        [_phrases insertObject:[HipsterIpsumGenerator phraseOfLength:3] atIndex:0];
}

@end
