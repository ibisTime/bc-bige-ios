//
//  LinkUsVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "LinkUsVC.h"

//Macro
//Framework
//Category
//Extension
//M
//V

@interface LinkUsVC ()

@property (nonatomic, strong) UIView *bgView;
//appicon
@property (nonatomic, strong) UIImageView *iconIV;
//名称
@property (nonatomic, strong) UIImageView *nameIV;
//版本号
@property (nonatomic, strong) UILabel *versionLbl;
//联系电话
@property (nonatomic, strong) UILabel *mobileLbl;
//客服微信
@property (nonatomic, strong) UILabel *wechatLbl;

@end

@implementation LinkUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"联系我们";
    
    [self initSubviews];
}

#pragma mark - Init
- (void)initSubviews {
    //appicon
    self.iconIV = [[UIImageView alloc] initWithImage:kImage(@"Appicon圆角")];
    
    [self.view addSubview:self.iconIV];
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(@(kHeight(40)));
        make.width.height.equalTo(@(kWidth(100)));
    }];
    //APP名称
    self.nameIV = [[UIImageView alloc] initWithImage:kImage(@"币格财经")];
    
    [self.view addSubview:self.nameIV];
    [self.nameIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.iconIV.mas_bottom).offset(20);
        make.centerX.equalTo(@0);
    }];
    //版本号
    self.versionLbl = [UILabel labelWithBackgroundColor:kClearColor
                                              textColor:kTextColor
                                                   font:17.0];
    
    self.versionLbl.text = @"V1.0.0";
    
    [self.view addSubview:self.versionLbl];
    [self.versionLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameIV.mas_bottom).offset(20);
        make.centerX.equalTo(@0);
    }];
    //联系电话
    UILabel *mobileTextLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                     textColor:kTextColor
                                                          font:15.0];
    mobileTextLbl.text = @"联系电话";
    [self.view addSubview:mobileTextLbl];
    [mobileTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.versionLbl.mas_bottom).offset(kHeight(35));
        make.left.equalTo(@15);
        make.height.equalTo(@50);
    }];
    
    self.mobileLbl = [UILabel labelWithBackgroundColor:kClearColor
                                             textColor:kTextColor2
                                                  font:15.0];
    
    self.mobileLbl.text = @"0571-8765650";
    
    [self.view addSubview:self.mobileLbl];
    [self.mobileLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.versionLbl.mas_bottom).offset(kHeight(35));
        make.right.equalTo(@(-15));
        make.height.equalTo(@50);
    }];
    
    //mobileLine
    UIView *mobileLine = [[UIView alloc] init];
    
    mobileLine.backgroundColor = kLineColor;
    
    [self.view addSubview:mobileLine];
    [mobileLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.height.equalTo(@0.5);
        make.top.equalTo(mobileTextLbl.mas_bottom);
    }];
    //微信客服
    UILabel *wechatTextLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                     textColor:kTextColor
                                                          font:15.0];
    wechatTextLbl.text = @"微信客服";
    [self.view addSubview:wechatTextLbl];
    [wechatTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(mobileLine.mas_bottom);
        make.left.equalTo(@15);
        make.height.equalTo(@50);
    }];
    
    self.wechatLbl = [UILabel labelWithBackgroundColor:kClearColor
                                             textColor:kTextColor2
                                                  font:15.0];
    self.wechatLbl.text = @"354545667";
    
    [self.view addSubview:self.wechatLbl];
    [self.wechatLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(mobileLine.mas_bottom);
        make.right.equalTo(@(-15));
        make.height.equalTo(@50);
    }];
    //wechatLine
    UIView *wechatLine = [[UIView alloc] init];
    
    wechatLine.backgroundColor = kLineColor;
    
    [self.view addSubview:wechatLine];
    [wechatLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.height.equalTo(@0.5);
        make.top.equalTo(wechatTextLbl.mas_bottom);
    }];
    
    //协议
    UILabel *protocolLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kTextColor
                                                        font:13.0];
    protocolLbl.text = @"币格财经网络协议";
    protocolLbl.textAlignment = NSTextAlignmentCenter;

    [self.view addSubview:protocolLbl];
    [protocolLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(@(-kHeight(60)));
        make.left.equalTo(@0);
        make.width.equalTo(@(kScreenWidth));
    }];
    //版权
    UILabel *copyrightLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                    textColor:kTextColor
                                                         font:13.0];
    copyrightLbl.text = @"©2018bigecaijing.com All right reserived";
    copyrightLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:copyrightLbl];
    [copyrightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.width.equalTo(@(kScreenWidth));
        make.bottom.equalTo(protocolLbl.mas_top).offset(-15);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
