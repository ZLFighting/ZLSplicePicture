//
//  ZLResultVC.m
//  ZLSplicePicture
//
//  Created by ZL on 2018/8/17.
//  Copyright © 2018年 ZL. All rights reserved.
//

#import "ZLResultVC.h"
#import "ZLConst.h"
#import "UIBarButtonItem+BlocksKit.h"
#import "NSObject+showHUDView.h"
#import "UIControl+BlocksKit.h"
#import <Masonry.h>

@interface ZLResultVC ()

@property(nonatomic, strong) UIImageView *photoView;
@property(nonatomic, strong) UIScrollView *resultView;
@property(nonatomic, strong) UIImage *resultPhoto;
@property(nonatomic, strong) UIView *toolView;

@end

@implementation ZLResultVC

#pragma mark - 生命周期 Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"拼接结果";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    [self.view addSubview:self.toolView];
    
    self.photoView.image = self.photos[0];
    
    [self updateInterface:YES];
    __weak typeof(self) _weakSelf = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"返回"] style:0 handler:^(id sender) {
        [_weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
}

#pragma mark - 私有方法 private Methods

/**
 更新页面
 
 @param isVertical 是否竖向
 */
-(void)updateInterface:(BOOL)isVertical{
    
    CGFloat w = HScreenW - 16;
    CGFloat h = HScreenH - 80 - 44;
    
    if (isVertical) {
        h = 0;
        for (UIImage *photo in self.photos) {
            CGSize size = photo.size;
            h += size.height / size.width * (HScreenW - 16 );
        }
        self.resultView.contentSize = CGSizeMake(0, h+16);
    }else{
        
        w = 0;
        for (UIImage *photo in self.photos) {
            CGSize size = photo.size;
            w += size.width / size.height * (HScreenH - 80 - 44);
        }
        self.resultView.contentSize = CGSizeMake(w+16, 0);
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self mergePhoto:isVertical];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photoView.image = self.resultPhoto;
            self.photoView.frame = CGRectMake(8, 8, w, h);
        });
    });
}


/**
 合并图片
 
 @param isVertical 是否竖向
 @return 拼接好的图片
 */
-(UIImage *)mergePhoto:(BOOL)isVertical{
    
    
    if (isVertical) {
        
        CGFloat w = HScreenW - 16;
        CGFloat h = 0;
        for (UIImage *photo in self.photos) {
            CGSize size = photo.size;
            h += size.height / size.width * w;
        }
        // 开启一个位图上下文
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), NO, 0.0);
        h = 0;
        for (UIImage *photo in self.photos) {
            
            CGSize size = photo.size;
            CGFloat temp_h = size.height / size.width * w;
            [photo drawInRect:CGRectMake(0, h, w, temp_h)];
            h += temp_h;
        }
        self.resultPhoto = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
    } else {
        
        CGFloat h = HScreenH - 80 - 44;
        CGFloat w = 0;
        for (UIImage *photo in self.photos) {
            CGSize size = photo.size;
            w += size.width / size.height * h;
        }
        // 开启一个位图上下文
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), NO, 0.0);
        w = 0;
        for (UIImage *photo in self.photos) {
            
            CGSize size = photo.size;
            CGFloat temp_w = size.width / size.height * h;
            [photo drawInRect:CGRectMake(w, 0, temp_w, h)];
            w += temp_w;
        }
        
        self.resultPhoto = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return self.resultPhoto;
}

/**
 保存图片到相册
 
 @param image 图片
 */
- (void)saveImage:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

/**
 保存图片到项目，成功的回调
 
 @param image 图片
 @param error 失败信息
 @param contextInfo nil
 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (error) {
        ZLLog(@"%@",error.userInfo);
        [self showErrorMsg:@"图片保存失败，请稍后再试"];
    }else{
        [self showSuccessMsg:@"图片保存成功"];
    }
}


#pragma mark - getter and stter
- (UIScrollView *)resultView {
    if (_resultView == nil) {
        _resultView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, HScreenW, HScreenH-64-44)];
        _resultView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
        [self.view addSubview:_resultView];
    }
    return _resultView;
}

- (UIImageView *)photoView {
    if (_photoView == nil) {
        _photoView = [[UIImageView alloc] init];
        _photoView.backgroundColor = [UIColor orangeColor];
        _photoView.contentMode = UIViewContentModeScaleAspectFit;
        [self.resultView addSubview:_photoView];
    }
    return _photoView;
}

- (UIView *)toolView {
    if (_toolView == nil) {
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, HScreenH - 44 - 64, HScreenW, 44)];
        _toolView.backgroundColor = [UIColor whiteColor];
        
        // 转向按钮
        UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [changeButton setTitleColor:HTextColor forState:UIControlStateNormal];
        [_toolView addSubview:changeButton];
        [changeButton setTitle:@"横向拼接" forState:UIControlStateNormal];
        [changeButton setTitle:@"竖向拼接" forState:UIControlStateSelected];
        [changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(88);
            
        }];
        __weak typeof(self) _weakSelf = self;
        [changeButton bk_addEventHandler:^(UIButton *sender) {
            
            if (sender.isSelected) {
                [sender setSelected:NO];
                [_weakSelf updateInterface:YES];
            }else{
                [sender setSelected:YES];
                [_weakSelf updateInterface:NO];
            }
            
        } forControlEvents:UIControlEventTouchUpInside];
        
        // 保存按钮
        UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];;
        [saveButton setTitleColor:HTextColor forState:UIControlStateNormal];
        [_toolView addSubview:saveButton];
        [saveButton setTitle:@"保存到相册" forState:UIControlStateNormal];
        [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(110);
        }];
        [saveButton bk_addEventHandler:^(id sender) {
            
            [_weakSelf saveImage:_weakSelf.resultPhoto];
            
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _toolView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
