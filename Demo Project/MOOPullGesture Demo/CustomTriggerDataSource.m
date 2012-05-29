//
//  CustomTriggerDataSource.m
//  MOOPullGesture Demo
//
//  Created by Peyton Randolph on 5/29/12.
//

#import "CustomTriggerDataSource.h"

#import "HipsterIpsumGenerator.h"

@implementation CustomTriggerDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
	cell.textLabel.text = [HipsterIpsumGenerator phraseOfLength:3];
	return cell;
}

@end
