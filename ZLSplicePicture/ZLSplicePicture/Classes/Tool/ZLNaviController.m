//
//  ZLNaviController.m
//  ZLSplicePicture
//
//  Created by ZL on 2018/8/17.
//  Copyright © 2018年 ZL. All rights reserved.
//

#import "ZLNaviController.h"
#import "UIBarButtonItem+BlocksKit.h"

@interface ZLNaviController ()

@end

@implementation ZLNaviController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi_bg"] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSAttachmentAttributeName:[UIFont systemFontOfSize:17]};
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        /* 设置导航栏上面的内容 */
        __weak typeof(self) _weakSelf = self;
        __weak typeof(viewController) _weakVC = viewController;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"goback"] style:0 handler:^(id sender) {
            if ([_weakVC respondsToSelector:@selector(goBack)]) {
                [_weakVC performSelector:@selector(goBack)];
            }else{
                [_weakSelf popViewControllerAnimated:YES];
            }
            
        }];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
