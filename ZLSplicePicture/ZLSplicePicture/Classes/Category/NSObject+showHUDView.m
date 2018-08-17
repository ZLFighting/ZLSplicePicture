//
//  NSObject+showHUDView.m
//  ZLSplicePicture
//
//  Created by ZL on 2018/8/17.
//  Copyright © 2018年 ZL. All rights reserved.
//

#import "NSObject+showHUDView.h"
#import <MBProgressHUD/MBProgressHUD.h>

#define kToastDuration 1

@implementation NSObject (showHUDView)

// 显示失败提示
+ (void)showErrorMsg:(NSObject *)msg {
    [self hideProgress];
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
    progressHUD.mode = MBProgressHUDModeText;
    progressHUD.label.text = msg.description;
    [progressHUD hideAnimated:YES afterDelay:kToastDuration];
    
}

// 显示失败提示
- (void)showErrorMsg:(NSObject *)msg {
    [self.class showErrorMsg:msg];
}

// 显示成功提示
+ (void)showSuccessMsg:(NSObject *)msg {
    [self hideProgress];
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
    progressHUD.mode = MBProgressHUDModeText;
    progressHUD.label.text = msg.description;
    [progressHUD hideAnimated:YES afterDelay:kToastDuration];
}

// 显示成功提示
- (void)showSuccessMsg:(NSObject *)msg {
    [self.class showSuccessMsg:msg];
}

// 显示等待消息
+ (void)showWaitingMsg:(NSString *)msg {
    [self hideProgress];
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    progressHUD.label.text = msg;
}

// 显示等待消息
- (void)showWaitingMsg:(NSString *)msg {
    [self.class showWaitingMsg:msg];
}

// 显示忙
+ (void)showProgress {
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
    [progressHUD hideAnimated:YES afterDelay:kToastDuration];
}

// 显示忙
- (void)showProgress {
    [self.class showProgress];
}

// 隐藏提示
+ (void)hideProgress {
    [MBProgressHUD hideHUDForView:[self currentView] animated:YES];
}

// 隐藏提示
- (void)hideProgress {
    [self.class hideProgress];
}

+ (UIView *)currentView {
    UIViewController *controller = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    if ([controller isKindOfClass:[UITabBarController class]]) {
        controller = [(UITabBarController *)controller selectedViewController];
    }
    if([controller isKindOfClass:[UINavigationController class]]) {
        controller = [(UINavigationController *)controller visibleViewController];
    }
    if (!controller) {
        return [UIApplication sharedApplication].keyWindow;
    }
    return controller.view;
}

- (UIView *)currentView {
    return [self.class currentView];
}


@end
