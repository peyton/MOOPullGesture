//
//  MOORefreshView.m
//  MOOPullGesture
//
//  Created by Peyton Randolph
//  Inspired by Pier-Olivier Thibault's [PHRefreshTriggerView](https://github.com/pothibo/PHRefreshTriggerView)
//

#import "MOOCreateView.h"

#import <QuartzCore/QuartzCore.h>

@implementation MOOCreateView
@synthesize delegate = _delegate;
@synthesize configurationBlock = _configurationBlock;
@synthesize cell = _cell;
@dynamic events;

- (id)init;
{
    if (!(self = [self initWithCell:[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]]))
        return nil;
    
    self.cell.backgroundColor = [UIColor whiteColor];
    
    return self;
}

- (id)initWithCell:(UITableViewCell *)cell;
{
    if (!(self = [super initWithFrame:CGRectZero]))
        return nil;
    
    // Configure view
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor blackColor];
    
    // Configure cell
    self.cell = cell;
    self.cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.cell.layer.shouldRasterize = YES;
    
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
    CGRect cellBounds = self.cell.layer.bounds;
    cellBounds.size = self.bounds.size;
    self.cell.layer.bounds = cellBounds;
}

- (CGSize)sizeThatFits:(CGSize)size;
{
    return size;
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
    
    CGFloat contentOffsetY = [(NSNumber *)object floatValue];

    CGFloat angle = acosf(-contentOffsetY / (CGRectGetHeight(self.cell.bounds)));
    if (isnan(angle))
        angle = 0.0f;
    CATransform3D transform = CATransform3DMakeRotation(angle, 1.0f, 0.0f, 0.0f);
    
    if (angle > 0.0f)
        transform.m24 = -1.f / 1000.f;
    
    self.cell.layer.transform = transform;
    
    self.cell.layer.position = CGPointMake(CGRectGetWidth(self.layer.bounds) / 2.0f, MAX(CGRectGetHeight(self.layer.bounds) + contentOffsetY / 2.0f, CGRectGetHeight(self.layer.bounds) / 2.0f));
    
    self.cell.layer.zPosition = -100.0f;
    CGFloat opacity = MIN((-contentOffsetY / CGRectGetHeight(self.cell.layer.bounds)) * 0.7f + 0.3f, 1.0f);

    self.cell.layer.opacity = opacity;
}

- (void)positionInScrollView:(UIScrollView *)scrollView;
{
    // Size create view
    CGFloat height = ([scrollView isKindOfClass:[UITableView class]]) ? height = ((UITableView *)scrollView).rowHeight : 44.0f;
    CGSize triggerViewSize = [self sizeThatFits:CGSizeMake(CGRectGetWidth(scrollView.bounds), height)];
    
    // Position create view
    CGPoint triggerViewOrigin = CGPointMake(0.0, -triggerViewSize.height);
    
    CGRect triggerViewFrame = CGRectZero;
    triggerViewFrame.size = triggerViewSize;
    triggerViewFrame.origin = triggerViewOrigin;
    self.frame = triggerViewFrame;
}

- (void)transitionToPullState:(MOOPullState)pullState;
{
    if (self.configurationBlock)
        self.configurationBlock(self, self.cell, pullState);
    else if ([self.delegate respondsToSelector:@selector(createView:configureCell:forState:)])
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
