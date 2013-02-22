#import "UIViewController+BackGesture.h"
#import <objc/runtime.h>

static const char *ISBackGestureEnabledKey    = "ISBackGestureEnabledKey";
static const char *ISBackGestureProgressKey   = "ISBackGestureProgressKey";
static const char *ISBackGestureRecognizerKey = "ISBackGestureRecognizerKey";

static void ISSwizzleInstanceMethod(Class c, SEL original, SEL alternative)
{
    Method orgMethod = class_getInstanceMethod(c, original);
    Method altMethod = class_getInstanceMethod(c, alternative);
    
    if(class_addMethod(c, original, method_getImplementation(altMethod), method_getTypeEncoding(altMethod))) {
        class_replaceMethod(c, alternative, method_getImplementation(orgMethod), method_getTypeEncoding(orgMethod));
    } else {
        method_exchangeImplementations(orgMethod, altMethod);
    }
}

@interface UIViewController ()

@property (nonatomic, strong) UIPanGestureRecognizer *backGestureRecognizer;

@end

@implementation UIViewController (BackGesture)

#pragma mark -

+ (void)load
{
    @autoreleasepool {
        ISSwizzleInstanceMethod(self, @selector(viewDidLoad), @selector(_viewDidLoad));
        ISSwizzleInstanceMethod(self, @selector(viewDidUnload), @selector(_viewDidUnload));
    }
}

#pragma mark - accessors

- (float)backProgress
{
    return [objc_getAssociatedObject(self, ISBackGestureProgressKey) floatValue];
}

- (void)setBackProgress:(float)backProgress
{
    objc_setAssociatedObject(self, ISBackGestureProgressKey, @(backProgress), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)backGestureEnabled
{
    return [objc_getAssociatedObject(self, ISBackGestureEnabledKey) boolValue];
}

- (void)setBackGestureEnabled:(BOOL)backGestureEnabled
{
    objc_setAssociatedObject(self, ISBackGestureEnabledKey, @(backGestureEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIPanGestureRecognizer *)backGestureRecognizer
{
    return objc_getAssociatedObject(self, ISBackGestureRecognizerKey);
}

- (void)setBackGestureRecognizer:(UIPanGestureRecognizer *)backGestureRecognizer
{
    objc_setAssociatedObject(self, ISBackGestureRecognizerKey, backGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -

- (void)_viewDidLoad
{
    [self startRecognizing];
}

- (void)_viewDidUnload
{
    self.backGestureRecognizer = nil;
}

#pragma mark -

- (void)startRecognizing
{
    if (!self.isViewLoaded || !self.backGestureEnabled) {
        return;
    }
    
    self.backGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.view addGestureRecognizer:self.backGestureRecognizer];
}

- (void)stopRecognizing
{
    if (!self.isViewLoaded || self.backGestureEnabled) {
        return;
    }
    
    [self.view removeGestureRecognizer:self.backGestureRecognizer];
    self.backGestureRecognizer = nil;
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    if ([self.navigationController.viewControllers count] < 2) {
        return;
    }
    
    CGPoint translation = [self.backGestureRecognizer translationInView:self.backGestureRecognizer.view];
    if (self.backGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.backProgress = 0.f;
        return;
    }
    
    CGFloat progress = translation.x / 150.f;
    if (progress < 0.f) {
        progress = 0.f;
    }
    if (progress > 1.f) {
        progress = 1.f;
    }
    self.backProgress = progress;
    
    if (self.backProgress >= 1.f) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
