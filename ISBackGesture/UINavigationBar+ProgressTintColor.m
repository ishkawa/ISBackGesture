#import "UINavigationBar+ProgressTintColor.h"
#import <objc/runtime.h>

static const char *ISProgressTintColorKey = "ISProgressTintColorKey";

@implementation UINavigationBar (ProgressTintColor)

- (UIColor *)progressTintColor
{
    return objc_getAssociatedObject(self, ISProgressTintColorKey);
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    objc_setAssociatedObject(self, ISProgressTintColorKey, progressTintColor, OBJC_ASSOCIATION_RETAIN);
}

@end
