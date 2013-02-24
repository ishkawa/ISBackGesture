#import "UIView+SwizzleIsa.h"
#import "ISNavigationItemProgressButtonView.h"
#import "ISUtility.h"
#import <objc/runtime.h>

@implementation UIView (SwizzleIsa)

+ (void)load
{
    @autoreleasepool {
        ISSwizzleInstanceMethod([UIView class], @selector(didMoveToSuperview), @selector(_didMoveToSuperview));
    }
}

- (void)_didMoveToSuperview
{
    Class class = NSClassFromString(@"UINavigationItemButtonView");
    if ([self isKindOfClass:class]) {
        object_setClass(self, [ISNavigationItemProgressButtonView class]);
    }
}

@end
