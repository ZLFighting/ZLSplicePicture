//
//  NSObject+showHUDView.h
//  ZLSplicePicture
//
//  Created by ZL on 2018/8/17.
//  Copyright © 2018年 ZL. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (showHUDView)

// 显示失败提示
- (void)showErrorMsg:(NSObject *)msg;
+ (void)showErrorMsg:(NSObject *)msg;

// 显示成功提示
- (void)showSuccessMsg:(NSObject *)msg;
+ (void)showSuccessMsg:(NSObject *)msg;

// 显示等待消息
- (void)showWaitingMsg:(NSString *)msg;
+ (void)showWaitingMsg:(NSString *)msg;

// 显示忙
- (void)showProgress;
+ (void)showProgress;

// 隐藏提示
- (void)hideProgress;
+ (void)hideProgress;

@end
