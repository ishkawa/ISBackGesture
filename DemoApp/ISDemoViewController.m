#import "ISDemoViewController.h"
#import "UIViewController+BackGesture.h"
#import <objc/runtime.h>

@implementation ISDemoViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.backGestureEnabled = YES;
        self.navigationItem.title = @"ISBackGesture";
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(120, 200, 80, 40);
    [button setTitle:@"Push" forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(push)
     forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)push
{
    ISDemoViewController *viewController = [[ISDemoViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
