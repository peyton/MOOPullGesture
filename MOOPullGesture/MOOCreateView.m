//
//  MOORefreshView.m
//  MOOPullGesture
//
//  Created by Peyton Randolph
//  Inspired by Pier-Olivier Thibault's [PHRefreshTriggerView](https://github.com/pothibo/PHRefreshTriggerView)
//

#import "MOOCreateView.h"

@interface MOOCreateView ()

@property (nonatomic, strong) UITableViewCell *cell;

@end

@implementation MOOCreateView
@synthesize delegate = _delegate;
@synthesize cell = _cell;
@dynamic events;

- (id)init;
{
    if (!(self = [self initWithCellClass:[UITableViewCell class] style:UITableViewCellStyleDefault]))
        return nil;
    
    return self;
}

- (id)initWithCellClass:(Class)cellClass style:(UITableViewCellStyle)style;
{
    if (!(self = [super initWithFrame:CGRectZero]))
        return nil;
    
    // Configure view
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor redColor];
    
    self.cell = [[cellClass alloc] initWithStyle:style reuseIdentifier:nil];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame;
{
    NSString *reason = [NSString stringWithFormat:@"Sent %@ to %@. Use %@ or %@ instead.", NSStringFromSelector(_cmd), NSStringFromClass([self class]), NSStringFromSelector(@selector(init)), NSStringFromSelector(@selector(initWithCellClass:style:))];
    @throw([NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil]);
}

- (void)dealloc;
{
    self.delegate = nil;
}

#pragma mark - Subview methods

- (void)layoutSubviews;
{

}

- (CGSize)sizeThatFits:(CGSize)size;
{
    return CGSizeMake(size.width, 44.0f);
}

#pragma mark - MOOTriggerView methods

- (NSUInteger)events;
{
    return MOOEventContentOffsetChanged;
}

- (void)handleEvent:(MOOEvent)event withObject:(id)object;
{
    if (!(event & MOOEventContentOffsetChanged))
        return;
    
    NSLog(@"Content offset changed!");
}

- (void)positionInScrollView:(UIScrollView *)scrollView;
{
    // Size trigger view
    CGSize triggerViewSize = [self sizeThatFits:CGSizeMake(CGRectGetWidth(scrollView.bounds), HUGE_VALF)];
    CGPoint triggerViewOrigin = CGPointMake(0.0, -triggerViewSize.height);
    
    CGRect triggerViewFrame = CGRectZero;
    triggerViewFrame.size = triggerViewSize;
    triggerViewFrame.origin = triggerViewOrigin;
    self.frame = triggerViewFrame;
}

- (void)transitionToPullState:(MOOPullState)pullState;
{
    if ([self.delegate respondsToSelector:@selector(createView:configureCell:forState:)])
        [self.delegate createView:self configureCell:self.cell forState:pullState];
}

#pragma mark - Getters and setters

- (void)setCell:(UITableViewCell *)cell;
{
    if (cell == self.cell)
        return;
    
    [self.cell removeFromSuperview];
    _cell = cell;
    [self addSubview:cell];
    
    [self setNeedsLayout];
}

@end
