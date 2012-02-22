//
//  MOORefreshView.h
//  MOOPullGesture
//
//  Created by Peyton Randolph on 2/20/12
//  Inspired by Pier-Olivier Thibault's [PHRefreshTriggerView](https://github.com/pothibo/PHRefreshTriggerView)
//

#import <UIKit/UIKit.h>

#import "Support/ARCHelper.h"
#import "MOOPullGestureRecognizer.h"
#import "MOOTriggerView.h"

@class CATransformLayer, MOOCreateView;

@protocol MOOCreateViewDelegate <NSObject>

@optional
- (void)createView:(MOOCreateView *)createView configureCell:(UITableViewCell *)cell forState:(MOOPullState)state;

@end

typedef void (^MOOCreateViewConfiguration)(MOOCreateView *createView, UITableViewCell *cell, MOOPullState state);

@interface MOOCreateView : UIView <MOOTriggerView> 
{
    __unsafe_unretained id<MOOCreateViewDelegate> _delegate;
    MOOCreateViewConfiguration _configurationBlock;
    UITableViewCell *_cell;
    
    CATransformLayer *_transformLayer;
}

@property (nonatomic, unsafe_unretained) id<MOOCreateViewDelegate> delegate;
@property (nonatomic, strong) MOOCreateViewConfiguration configurationBlock;
@property (nonatomic, strong) UITableViewCell *cell;

- (id)initWithCell:(UITableViewCell *)cell;

@end
