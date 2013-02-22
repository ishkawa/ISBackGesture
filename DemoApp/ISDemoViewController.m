#import "ISDemoViewController.h"
#import "UIViewController+BackGesture.h"
#import <objc/runtime.h>

@implementation ISDemoViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.backGestureEnabled = YES;
        
        [self addObserver:self forKeyPath:@"backProgress" options:0 context:NULL];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"backProgress"];
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:@"backProgress"]) {
        NSString *title = [NSString stringWithFormat:@"%.2f", self.backProgress];
        
        NSInteger index = [self.navigationController.viewControllers count] - 2;
        if (index >= 0) {
            UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:index];
            
            viewController.navigationItem.backBarButtonItem =
            [[UIBarButtonItem alloc] initWithTitle:title
                                             style:UIBarButtonItemStyleBordered
                                            target:nil
                                            action:nil];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)push
{
    ISDemoViewController *viewController = [[ISDemoViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
