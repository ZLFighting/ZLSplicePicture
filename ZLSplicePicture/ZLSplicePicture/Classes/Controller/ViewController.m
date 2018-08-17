//
//  ViewController.m
//  ZLSplicePicture
//
//  Created by ZL on 2018/8/17.
//  Copyright © 2018年 ZL. All rights reserved.
//

#import "ViewController.h"
#import "ZLNaviController.h"
#import "ZLImageCell.h"
#import "ZLVerticalButton.h"
#import "ZLResultVC.h"
#import "NSObject+showHUDView.h"
#import "UIControl+BlocksKit.h"
#import "UIView+Frame.h"
#import "ZLConst.h"
#import <Masonry.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *toolView;
@property(nonatomic,strong)NSMutableArray *photos;
@property(nonatomic,strong)UIImagePickerController *imagePicker;

@end

@implementation ViewController

#pragma mark - 生命周期 Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title = @"拼接图片";
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    
    [self setupHomeView];
}

#pragma mark - 私有方法 private Methods

- (void)setupHomeView {
    
    __weak typeof(self) _weakSelf = self;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
    }];
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(_weakSelf.tableView.mas_bottom).offset(1);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.photos removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZLImageCell *cell = [ZLImageCell dequeueReusableFromTableView:tableView];
    cell.photoView.image = self.photos[indexPath.row];
    cell.indexPath = indexPath;
    return cell;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.photos addObject:image];
    __weak typeof(self) _weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        [_weakSelf.tableView reloadData];
    }];
}


#pragma mark - getter and stter

- (UITableView *)tableView {
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 200, 100) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 128;
        [self.view addSubview:_tableView];
        
        // 添加图片
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HScreenW, 64)];
        UIButton *button = [UIButton buttonWithType:0];
        [button setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
        [footView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(10);
        }];
        __weak typeof(self) _weakSelf = self;
        [button bk_addEventHandler:^(id sender) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                [_weakSelf presentViewController:_weakSelf.imagePicker animated:YES completion:nil];
            }else{
                [_weakSelf showErrorMsg:@"没有访问相册的权限"];
            }
        } forControlEvents:UIControlEventTouchUpInside];
        _tableView.tableFooterView = footView;
    }
    return _tableView;
}

-(UIView *)toolView {
    
    if (_toolView == nil) {
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        _toolView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_toolView];
        
        // 清空按钮
        UIButton *clearButton = [ZLVerticalButton buttonWithType:0];
        [clearButton setTitleColor:HTextColor forState:UIControlStateNormal];
        [_toolView addSubview:clearButton];
        [clearButton setImage:[UIImage imageNamed:@"清空"] forState:UIControlStateNormal];
        [clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.bottom.mas_equalTo(0);
            make.top.mas_equalTo(6);
            make.width.mas_equalTo(88);
            
        }];
        __weak typeof(self) _weakSelf = self;
        [clearButton bk_addEventHandler:^(id sender) {
            if (_weakSelf.photos.count) {
                [_weakSelf.photos removeAllObjects];
                [_weakSelf.tableView reloadData];
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        // 合并按钮
        UIButton *mergeButton = [ZLVerticalButton buttonWithType:0];
        [mergeButton setTitleColor:HTextColor forState:UIControlStateNormal];
        [_toolView addSubview:mergeButton];
        [mergeButton setImage:[UIImage imageNamed:@"合并"] forState:UIControlStateNormal];
        [mergeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(6);
            make.width.mas_equalTo(88);
        }];
        [mergeButton bk_addEventHandler:^(id sender) {
            
            if (_weakSelf.photos.count == 0) {
                [_weakSelf showErrorMsg:@"请添加至少2张照片"];
            }else if (_weakSelf.photos.count == 1) {
                [_weakSelf showErrorMsg:@"请再添加一张照片"];
            }else{
                
                ZLResultVC *resultVC = [ZLResultVC new];
                resultVC.photos = _weakSelf.photos;
                [_weakSelf.navigationController pushViewController:resultVC animated:YES];
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _toolView;
}

-(NSMutableArray *)photos{
    if (_photos == nil) {
        _photos = [NSMutableArray new];
    }
    return _photos;
}

-(UIImagePickerController *)imagePicker{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    return _imagePicker;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - 公开方法 public Methods
//
//+ (UIViewController *)homeVC {
//    ViewController *homeVC = [self new];
//    ZLNaviController *naviC = [[ZLNaviController alloc] initWithRootViewController:homeVC];
//    return naviC;
//}



@end
