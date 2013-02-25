#import "ISNavigationItemProgressButtonView.h"
#import "UINavigationBar+ProgressTintColor.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

static const char *ISProgressViewKey = "progressView";
static const char *ISLabelKey = "label";

@implementation ISNavigationItemProgressButtonView

+ (void)load
{
    @autoreleasepool {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        Class class = NSClassFromString(@"UINavigationItemButtonView");
        class_setSuperclass([self class], class);
#pragma clang diagnostic pop
    }
}

#pragma mark - accessors

- (float)progress
{
    UIView *progressView = objc_getAssociatedObject(self, ISProgressViewKey);
    return progressView.alpha;
}

- (void)setProgress:(float)progress
{
    UIView *progressView = objc_getAssociatedObject(self, ISProgressViewKey);
    CGRect frame = progressView.frame;
    frame.origin.x = self.frame.size.width * (1.f - progress);
    
    progressView.frame = frame;
    progressView.alpha = pow(progress, 1.2) * .25f + .1f;
}

#pragma mark - UIView events

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    self.progress = 0.f;
}

- (void)layoutSubviews
{
    for (UIView *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    
    CGRect containerFrame = self.frame;
    containerFrame.origin = CGPointZero;
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"ISBackGesture" ofType:@"bundle"];
    NSString *imagePath = [[NSBundle bundleWithPath:bundlePath] pathForResource:@"mask" ofType:@"png"];
    UIImage *maskImage = [UIImage imageWithContentsOfFile:imagePath];
    UIEdgeInsets insets = UIEdgeInsetsMake(maskImage.size.width/2.f,
                                           maskImage.size.width/2.f,
                                           maskImage.size.height/2.f,
                                           maskImage.size.height/2.f);
    
    maskImage = [maskImage resizableImageWithCapInsets:insets];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:maskImage];
    imageView.frame = containerFrame;
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = CGRectMake(0,0, containerFrame.size.width ,containerFrame.size.height);
    [maskLayer addSublayer:imageView.layer];
    
    UIView *containerView = [[UIView alloc] initWithFrame:containerFrame];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    containerView.layer.mask = maskLayer;
    [self addSubview:containerView];
    
    CGRect maskFrame = self.frame;
    maskFrame.origin.x = self.frame.size.width;
    maskFrame.origin.y = 0.f;
    
    UIColor *progressTintColor = [(UINavigationBar *)self.superview progressTintColor];
    UIView *progressView = [[UIView alloc] initWithFrame:maskFrame];
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    progressView.backgroundColor = [UIColor blackColor];
    progressView.alpha = 0.f;
    progressView.backgroundColor = progressTintColor ? progressTintColor : [UIColor blueColor];
    [containerView addSubview:progressView];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(13, -1, self.frame.size.width-13, self.frame.size.height);
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:12];
    label.backgroundColor = [UIColor clearColor];
    label.shadowOffset = CGSizeMake(0, -1.f);
    label.shadowColor = [UIColor darkGrayColor];
    [self addSubview:label];
    
    objc_setAssociatedObject(self, ISLabelKey, label, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, ISProgressViewKey, progressView, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - draw rect

- (void)drawText:(NSString *)text inRect:(CGRect)rect barStyle:(UIBarStyle)style
{
    UILabel *label = objc_getAssociatedObject(self, ISLabelKey);
    label.text = text;
}

@end
