//
//  ZLVerticalButton.m
//  ZLSplicePicture
//
//  Created by ZL on 2018/8/17.
//  Copyright © 2018年 ZL. All rights reserved.
//

#import "ZLVerticalButton.h"
#import "UIView+Frame.h"

@implementation ZLVerticalButton

+ (instancetype)h_buttonWithTitle:(NSString *)title image:(UIImage *)image {
    
    ZLVerticalButton *button = [[ZLVerticalButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button sizeToFit];
    return button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel sizeToFit];
    
    self.imageView.h_y = (self.h_height - self.imageView.h_height - self.titleLabel.h_height - 8 ) * 0.5;
    self.imageView.h_centerX = self.h_width * 0.5;
    self.titleLabel.h_centerX = self.h_width * 0.5;
    
    self.titleLabel.h_y = self.imageView.h_bottom + 8;
}

@end
