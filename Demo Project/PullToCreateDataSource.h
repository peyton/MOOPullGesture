//
//  PullToCreateDataSource.h
//  Demo Project
//
//  Created by Peyton Randolph on 2/21/12.
//


@interface PullToCreateDataSource : NSObject <UITableViewDataSource>
{
    NSMutableArray *_phrases;
    NSUInteger _numberOfRows;
}

@property (nonatomic, assign) NSUInteger numberOfRows;

@end
