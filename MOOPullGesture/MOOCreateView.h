//
//  MOOCreateView.h
//  MOOPullGesture
//
//  Created by Peyton Randolph on 2/20/12
//

#import <UIKit/UIKit.h>

#import "MOOTriggerView.h"

@class CATransformLayer, MOOCreateView;

@protocol MOOCreateViewDelegate <NSObject>

@optional
- (void)createView:(MOOCreateView *)createView configureCell:(UITableViewCell *)cell forState:(MOOPullState)state;

@end

typedef void (^MOOCreateViewConfiguration)(MOOCreateView *createView, UITableViewCell *cell, MOOPullState state);

// A view whose layer is a CAGradientLayer. Used for shadows
@interface MOOGradientView : UIView

@end

@interface MOOCreateView : UIView <MOOTriggerView> 
{
    __unsafe_unretained id<MOOCreateViewDelegate> _delegate;
    MOOCreateViewConfiguration _configurationBlock;
    UITableViewCell *_cell;
    
    MOOGradientView *_gradientView;
    UIView *_rotationView;
}

@property (nonatomic, unsafe_unretained) id<MOOCreateViewDelegate> delegate;
@property (nonatomic, strong) MOOCreateViewConfiguration configurationBlock;
@property (nonatomic, strong) UITableViewCell *cell;
@property (nonatomic, strong, readonly) MOOGradientView *gradientView;

- (id)initWithCell:(UITableViewCell *)cell;

@end
