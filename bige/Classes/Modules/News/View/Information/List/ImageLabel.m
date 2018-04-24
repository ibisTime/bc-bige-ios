//
//  ImageLabel.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ImageLabel.h"

@interface ImageLabel()


@end

@implementation ImageLabel

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.iconIV = [[UIImageView alloc] init];
    
    [self addSubview:self.iconIV];
    
    self.textLbl = [[UILabel alloc] init];
    
    [self addSubview:self.textLbl];
}

- (void)setMargin:(CGFloat)margin {
    
    _margin = margin;
        CGFloat imageW = self.iconIV.image.size.width;
    
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.centerY.equalTo(@0);
        make.width.lessThanOrEqualTo(@40);
    }];
    
    [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.iconIV.mas_right).offset(margin);
        make.centerY.equalTo(self.iconIV.mas_centerY);
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, imageW + margin, 0, 0));
    }];
}

@end
