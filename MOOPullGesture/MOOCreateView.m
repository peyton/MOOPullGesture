//
//  MOORefreshView.m
//  MOOPullGesture
//
//  Created by Peyton Randolph
//

#import "MOOCreateView.h"

#import <QuartzCore/QuartzCore.h>

@interface MOOCreateView ()

@property (nonatomic, strong) CATransformLayer *transformLayer;

// Notification handling
- (void)handleContentOffsetChangedNotification:(NSNotification *)notification;

@end

@implementation MOOCreateView
@synthesize delegate = _delegate;
@synthesize configurationBlock = _configurationBlock;
@synthesize cell = _cell;
@synthesize transformLayer = _transformLayer;

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
    
    // Create transform layer
    self.transformLayer = [CATransformLayer layer];
    
    // Configure cell
    self.cell = cell;
    self.cell.layer.anchorPoint = CGPointMake(0.5f, 1.0f);
    self.cell.layer.borderColor = [UIColor whiteColor].CGColor;
    self.cell.layer.borderWidth = 1.0f;
    self.cell.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge;
    self.cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.cell.layer.shouldRasterize = YES;
    
    // Register for notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleContentOffsetChangedNotification:) name:MOONotificationContentOffsetChanged object:nil];
    
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
    
    switch (pullState)
    {
        case MOOPullIdle:
            self.hidden = NO;
            break;
        case MOOPullTriggered:
            self.hidden = YES;
            break;
        case MOOPullActive:
        default:
            break;
    }
}

#pragma mark - Notification handling

- (void)handleContentOffsetChangedNotification:(NSNotification *)notification;
{

    
    /*
     * Layer folding effect
     */
    
    // Grab content offset
    CGPoint contentOffet = [[notification.userInfo objectForKey:MOOKeyContentOffset] CGPointValue];
    
    // Calculate transition progress
    CGFloat progress = MIN(-contentOffet.y / CGRectGetHeight(self.cell.bounds), 1.0f);
    
    //
    CGFloat angle = acosf(progress);
    if (isnan(angle))
        angle = 0.0f;
    CATransform3D transform = CATransform3DMakeRotation(angle, 1.0f, 0.0f, 0.0f);
    
    // Perspective transform. Gradually decreases based on progress
    if (angle > 0.0f)
        transform.m24 = -1.f / 300.f + 1.f / 300.f * progress;
    self.cell.layer.transform = transform;
    
    // Position at bottom of create view
    CGFloat positionY = CGRectGetHeight(self.layer.bounds);
    // 1px adjustment for table views with a 1px cell separator
    if ([self.superview isKindOfClass:[UITableView class]])
        if (((UITableView *)self.superview).separatorStyle == UITableViewCellSeparatorStyleSingleLine)
            positionY -= 1.0f - progress;
    
    self.cell.layer.position = CGPointMake(CGRectGetWidth(self.layer.bounds) / 2.0f, positionY);
    
    // Set opacity to mimic shadows
    self.cell.layer.opacity = MIN(progress * 0.7f + 0.3f, 1.0f);

}

#pragma mark - Getters and setters

- (void)setCell:(UITableViewCell *)cell;
{
    if (cell == self.cell)
        return;
    
    [self.cell.layer removeFromSuperlayer];
    _cell = cell;
    [self.transformLayer addSublayer:cell.layer];
    
    [self setNeedsLayout];
}

- (void)setTransformLayer:(CATransformLayer *)transformLayer;
{
    if (transformLayer == self.transformLayer)
        return;
    
    for (CALayer *sublayer in self.transformLayer.sublayers)
    {
        [transformLayer addSublayer:sublayer];
    }
    [self.transformLayer removeFromSuperlayer];
    _transformLayer = transformLayer;
    [self.layer addSublayer:transformLayer];
}

@end
