//
//  ZLImageCell.m
//  ZLSplicePicture
//
//  Created by ZL on 2018/8/17.
//  Copyright © 2018年 ZL. All rights reserved.
//

#import "ZLImageCell.h"
#import "UIControl+BlocksKit.h"
#import <Masonry.h>


@implementation ZLImageCell

+ (instancetype)dequeueReusableFromTableView:(UITableView *)tableView {
    
    ZLImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"image"];
    if (cell == nil) {
        cell = [[ZLImageCell alloc] initWithStyle:0 reuseIdentifier:@"image"];
    }
    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = NO;
        [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(8, 8, 8, 8));
        }];
    }
    return self;
}

- (UIImageView *)photoView {
    if (_photoView == nil) {
        _photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        _photoView.clipsToBounds = YES;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [_photoView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_photoView);
        }];
        imageView.image = [UIImage imageNamed:@"删除"];
        
        [self.contentView addSubview:_photoView];
    }
    return _photoView;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
