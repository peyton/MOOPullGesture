//
//  MOORefreshView.m
//  MOOPullGesture
//
//  Created by Peyton Randolph
//

#import "MOOCreateView.h"

#import <QuartzCore/QuartzCore.h>

@interface MOOCreateView ()

@property (nonatomic, strong) MOOGradientView *gradientView;
@property (nonatomic, strong) UIView *rotationView;

// Notification handling
- (void)handleContentOffsetChangedNotification:(NSNotification *)notification;

@end

@implementation MOOCreateView
@synthesize delegate = _delegate;
@synthesize configurationBlock = _configurationBlock;
@synthesize cell = _cell;

@synthesize gradientView = _gradientView;
@synthesize rotationView = _rotationView;

- (id)init;
{
    if (!(self = [self initWithCell:[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]]))
        return nil;
    
    // UITableViewCell has, by default, a transparent background. Set to white.
    self.cell.backgroundColor = [UIColor whiteColor];
    
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.shouldRasterize = YES;
    
    return self;
}

- (id)initWithCell:(UITableViewCell *)cell;
{
    if (!(self = [super initWithFrame:CGRectZero]))
        return nil;
    
    // Configure view
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor blackColor];
    self.clipsToBounds = YES;
    
    // Create transform layer
    self.rotationView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Allow antialiasing
    self.rotationView.layer.borderColor = self.backgroundColor.CGColor;
    self.rotationView.layer.borderWidth = 3.0f;
    self.rotationView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.rotationView.layer.shouldRasterize = YES;

    // Configure cell
    self.cell = cell;
    
    // Create gradient view
    self.gradientView = [[MOOGradientView alloc] initWithFrame:CGRectZero];
    self.gradientView.layer.anchorPoint = CGPointZero;
    
    // Configure shadow gradient. If the effect is too strong, you can access the gradient view through the gradientView property and change the gradient colors and locations.
    ((CAGradientLayer *)self.gradientView.layer).colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:0.0f alpha:0.4f].CGColor, (id)[UIColor colorWithWhite:0.0f alpha:0.8f].CGColor, nil];
    ((CAGradientLayer *)self.gradientView.layer).locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.5f], [NSNumber numberWithFloat:1.0f], nil];

    return self;
}

- (id)initWithFrame:(CGRect)frame;
{
    NSString *reason = [NSString stringWithFormat:@"Sent %@ to %@. Use %@ or %@ instead.", NSStringFromSelector(_cmd), NSStringFromClass([self class]), NSStringFromSelector(@selector(init)), NSStringFromSelector(@selector(initWithCellClass:style:))];
    @throw([NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil]);
}

- (void)dealloc;
{
    // Deregister for previous content offset change notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MOONotificationContentOffsetChanged object:nil];
    
    self.delegate = nil;
    self.cell = nil;
    self.configurationBlock = nil;
    self.gradientView = nil;
    self.rotationView = nil;
}

#pragma mark - Subview methods

- (void)layoutSubviews;
{
    // Expand cell, gradientView, and rotationView to fit createView
    self.cell.layer.bounds = self.bounds;
    self.gradientView.layer.bounds = self.bounds;
    self.rotationView.layer.bounds = CGRectInset(self.bounds, -self.rotationView.layer.borderWidth, -self.rotationView.layer.borderWidth);

    // Set rotation view anchorPoint to the max Y, accounting for border width
    self.rotationView.layer.anchorPoint = CGPointMake(0.5f, 1.0f - self.rotationView.layer.borderWidth / CGRectGetHeight(self.rotationView.layer.bounds));
    
    // Position cell in the center of rotation view
    CGPoint rotationCenter = CGPointMake(CGRectGetMidX(self.rotationView.layer.bounds), CGRectGetMidY(self.rotationView.layer.bounds));
    self.cell.layer.position = rotationCenter;
    
    // Position gradientView in the top left
    self.gradientView.layer.position = CGPointZero;
}

- (CGSize)sizeThatFits:(CGSize)size;
{
    return size;
}

#pragma mark - MOOTriggerView methods

- (void)positionInScrollView:(UIScrollView *)scrollView;
{
    // Deregister for previous content offset change notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MOONotificationContentOffsetChanged object:nil];
    
    // Register for content offset change notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleContentOffsetChangedNotification:) name:MOONotificationContentOffsetChanged object:scrollView.pullGestureRecognizer];
    
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
    CGPoint contentOffset = [[notification.userInfo objectForKey:MOOKeyContentOffset] CGPointValue];
    
    // Calculate transition progress
    CGFloat progress = MIN(-contentOffset.y / CGRectGetHeight(self.bounds), 1.0f);
    
    //
    CGFloat angle = acosf(progress);
    if (isnan(angle))
        angle = 0.0f;
    CATransform3D transform = CATransform3DMakeRotation(angle, 1.0f, 0.0f, 0.0f);
    
    // Perspective transform. Gradually decreases based on progress
    if (angle > 0.0f)
        transform.m24 = -1.f / 300.f + 1.f / 300.f * progress;
    self.rotationView.layer.transform = transform;
    
    // Position at bottom of create view
    CGFloat positionY = CGRectGetHeight(self.layer.bounds);
    // 1px adjustment for table views with a 1px cell separator
    if ([self.superview isKindOfClass:[UITableView class]])
        if (((UITableView *)self.superview).separatorStyle == UITableViewCellSeparatorStyleSingleLine)
            positionY -= 1.0f - progress;
    
    self.rotationView.layer.position = CGPointMake(CGRectGetMidX(self.layer.bounds), positionY);
    
    // Set opacity to mimic shadows
    self.gradientView.layer.opacity = MAX(1.0f - progress, 0.0f);
}

#pragma mark - Getters and setters

- (void)setCell:(UITableViewCell *)cell;
{
    if (cell == self.cell)
        return;
    
    [self.cell removeFromSuperview];
    _cell = cell;
    
    // Insert below gradientView if it exists
    if ([self.rotationView.subviews containsObject:self.gradientView])
        [self.rotationView insertSubview:cell belowSubview:self.gradientView];
    else
        [self.rotationView addSubview:cell];
    
    [self setNeedsLayout];
}

- (void)setGradientView:(MOOGradientView *)gradientView;
{
    if (gradientView == self.gradientView)
        return;
    
    [self.gradientView removeFromSuperview];
    _gradientView = gradientView;
    [self.rotationView addSubview:self.gradientView];
    
    [self setNeedsLayout];
}

- (void)setRotationView:(UIView *)rotationView;
{
    if (rotationView == self.rotationView)
        return;
    
    // Moves rotationView subviews to new rotationView
    for (UIView *subview in self.rotationView.subviews)
    {
        [rotationView addSubview:subview];
    }
    
    // Swap rotationViews
    [self.rotationView removeFromSuperview];
    _rotationView = rotationView;
    
    // Configure new rotationView
    [self addSubview:rotationView];
    rotationView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self setNeedsLayout];
}

@end

@implementation MOOGradientView

+ (Class)layerClass;
{
    return [CAGradientLayer class];
}

@end
