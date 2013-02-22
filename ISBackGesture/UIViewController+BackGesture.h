#import <UIKit/UIKit.h>

@interface UIViewController (BackGesture)

@property (nonatomic) BOOL backGestureEnabled;
@property (nonatomic, readonly) float backProgress;

@end
