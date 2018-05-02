//
//  MineHeaderView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "MineHeaderView.h"

//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//Category
#import "UIButton+EnLargeEdge.h"
//M
#import "TLUser.h"

@interface MineHeaderView()

@end

@implementation MineHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.backgroundColor = kClearColor;
    
    UIImageView *bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(155 + kStatusBarHeight))];
    
    bgIV.contentMode = UIViewContentModeScaleToFill;
    
    [self addSubview:bgIV];
    
    //头像
    CGFloat imgWidth = 60;
    
    self.userPhoto = [[UIImageView alloc] init];
    
    self.userPhoto.frame = CGRectMake(15, 50 + kStatusBarHeight, imgWidth, imgWidth);
    self.userPhoto.image = USER_PLACEHOLDER_SMALL;
    self.userPhoto.layer.cornerRadius = imgWidth/2.0;
    self.userPhoto.layer.masksToBounds = YES;
    self.userPhoto.contentMode = UIViewContentModeScaleAspectFill;
    
    self.userPhoto.userInteractionEnabled = YES;
    
    [self addSubview:self.userPhoto];
    
//    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPhoto:)];
//
//    [self.userPhoto addGestureRecognizer:tapGR];
    //昵称
    self.nameBtn = [UIButton buttonWithTitle:@""
                                  titleColor:kWhiteColor
                             backgroundColor:kClearColor
                                   titleFont:17.0];
    [self.nameBtn addTarget:self action:@selector(clickLogin) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.nameBtn];
    [self.nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.userPhoto.mas_centerY);
        make.left.equalTo(self.userPhoto.mas_right).offset(15);
    }];
    
    CGFloat btnW = kScreenWidth/2.0;
    //积分中心
    UIButton *integralBtn = [UIButton buttonWithTitle:@"积分中心"
                                           titleColor:kTextColor
                                      backgroundColor:kWhiteColor
                                            titleFont:14.0];
    [integralBtn addTarget:self action:@selector(selectInteralCenter) forControlEvents:UIControlEventTouchUpInside];
    [integralBtn setImage:kImage(@"积分中心") forState:UIControlStateNormal];
    [self addSubview:integralBtn];
    [integralBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.bottom.equalTo(@0);
        make.width.equalTo(@(btnW));
        make.height.equalTo(@70);
    }];
    [integralBtn setTitleBottom];
    //收藏
    UIButton *collectionBtn = [UIButton buttonWithTitle:@"我的收藏"
                                           titleColor:kTextColor
                                      backgroundColor:kWhiteColor
                                            titleFont:14.0];
    [collectionBtn addTarget:self action:@selector(selectCollection) forControlEvents:UIControlEventTouchUpInside];
    [collectionBtn setImage:kImage(@"我的收藏") forState:UIControlStateNormal];

    [self addSubview:collectionBtn];
    [collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(integralBtn.mas_right);
        make.bottom.equalTo(@0);
        make.width.equalTo(@(btnW));
        make.height.equalTo(@70);
    }];
    [collectionBtn setTitleBottom];
}

#pragma mark - Events
- (void)clickLogin {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithType:idx:)] && ![TLUser user].isLogin) {
        
        [self.delegate didSelectedWithType:MineHeaderTypeLogin idx:0];
    }
}

- (void)selectInteralCenter {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithType:idx:)]) {
        
        [self.delegate didSelectedWithType:MineHeaderTypeIntegralCenter idx:0];
    }
}

- (void)selectCollection {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithType:idx:)]) {
        
        [self.delegate didSelectedWithType:MineHeaderTypeCollection idx:0];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithType:idx:)]) {
        
        [self.delegate didSelectedWithType:MineHeaderTypeDefault idx:0];
    }
    
}

@end
