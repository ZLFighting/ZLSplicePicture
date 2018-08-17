//
//  ZLImageCell.h
//  ZLSplicePicture
//
//  Created by ZL on 2018/8/17.
//  Copyright © 2018年 ZL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZLImageCell;

@interface ZLImageCell : UITableViewCell

@property (strong, nonatomic) UIImageView *photoView;
@property(nonatomic, weak)NSIndexPath *indexPath;

+ (instancetype)dequeueReusableFromTableView:(UITableView *)tableView;

@end
