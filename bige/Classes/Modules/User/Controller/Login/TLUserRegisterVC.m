//
//  TLUserRegisterVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "TLUserRegisterVC.h"
//#import "SGScanningQRCodeVC.h"
//Macro
#import "APICodeMacro.h"
//Framework
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>
//Category
#import "NSString+Check.h"
#import "UILabel+Extension.h"
//V
#import "CaptchaView.h"
//C
#import "HTMLStrVC.h"
#import "TLUserLoginVC.h"
#import "NavigationController.h"

@interface TLUserRegisterVC ()<CLLocationManagerDelegate>
//验证码
@property (nonatomic,strong) CaptchaView *captchaView;
//手机号
@property (nonatomic,strong) TLTextField *phoneTf;
//密码
@property (nonatomic,strong) TLTextField *pwdTf;
//昵称
@property (nonatomic, strong) TLTextField *nickNameTF;

@property (nonatomic,strong) CLLocationManager *sysLocationManager;
//
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *area;
//同意按钮
@property (nonatomic, strong) UIButton *checkBtn;

@end

@implementation TLUserRegisterVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"注册";
    //取消
    [self setBarButtonItem];
    //
    [self setUpUI];

}

#pragma mark - Init
- (void)setBarButtonItem {
    
    CGFloat btnW = 80;
    //取消按钮
    UIButton *backBtn = [UIButton buttonWithImageName:kCancelIcon];
    
    backBtn.frame = CGRectMake(kScreenWidth - btnW, kStatusBarHeight, btnW, 44);
    
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

- (void)setUpUI {
    
    self.view.backgroundColor = kWhiteColor;
    
    CGFloat margin = 15;
    CGFloat w = kScreenWidth - 2*margin;
    CGFloat h = ACCOUNT_HEIGHT;
    
    CGFloat btnMargin = 15;
    
    //注册
    UILabel *registerLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kTextColor
                                                        font:24];
    //字体加粗
    [registerLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
    registerLbl.frame = CGRectMake(0, kStatusBarHeight+75, 100, 24);
    registerLbl.text = @"注册";
    registerLbl.textAlignment = NSTextAlignmentCenter;
    registerLbl.centerX = self.view.centerX;
    [self.view addSubview:registerLbl];
    
    //账号
    TLTextField *phoneTf = [[TLTextField alloc] initWithFrame:CGRectMake(margin, registerLbl.yy + 45, w, h)
                                                    leftTitle:@""
                                                   titleWidth:0
                                                  placeholder:@"请输入手机号"];
    phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:phoneTf];
    self.phoneTf = phoneTf;
    
    //密码
    TLTextField *pwdTf = [[TLTextField alloc] initWithFrame:CGRectMake(margin, phoneTf.yy + 1, w, h)
                                                  leftTitle:@""
                                                 titleWidth:0
                                                placeholder:@"请输入密码(不少于6位)"];
    pwdTf.secureTextEntry = YES;
    
    [self.view addSubview:pwdTf];
    self.pwdTf = pwdTf;
    //昵称
    TLTextField *nickNameTF = [[TLTextField alloc] initWithFrame:CGRectMake(margin, pwdTf.yy + 1, w, h) leftTitle:@""
                                                      titleWidth:0
                                                     placeholder:@"请设置你的昵称"];
    
    [self.view addSubview:nickNameTF];
    self.nickNameTF = nickNameTF;
    //验证码
    CaptchaView *captchaView = [[CaptchaView alloc] initWithFrame:CGRectMake(0, nickNameTF.yy + 1, w, h)];
    
    captchaView.captchaTf.leftView.width = 15;
    
    [captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:captchaView];

    self.captchaView = captchaView;
    
    for (int i = 0; i < 4; i++) {
    
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(margin, phoneTf.yy + (1+h)*i, w, 0.5)];

        line.backgroundColor = kHexColor(@"#dedede");

        [self.view addSubview:line];
        
    }
    
    //选择按钮
    UIButton *checkBtn = [UIButton buttonWithImageName:@"不打勾" selectedImageName:@"打勾"];
    
    checkBtn.selected = YES;
    
    [checkBtn addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:checkBtn];
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(captchaView.mas_left).offset(15);
        make.top.equalTo(captchaView.mas_bottom).offset(18);
    }];
    
    self.checkBtn = checkBtn;
    
    //用户协议
    UIButton *protocolBtn = [UIButton buttonWithTitle:@"注册即同意《币格财经用户协议》"
                                           titleColor:kTextColor
                                      backgroundColor:kClearColor
                                            titleFont:12.0];
    
    [protocolBtn addTarget:self action:@selector(readProtocal) forControlEvents:UIControlEventTouchUpInside];
    [protocolBtn.titleLabel labelWithString:@"注册即同意《币格财经用户协议》"
                                      title:@"《币格财经用户协议》"
                                       font:Font(12.0)
                                      color:kAppCustomMainColor];
    [self.view addSubview:protocolBtn];
    [protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(checkBtn.mas_right).offset(5);
        make.centerY.equalTo(checkBtn.mas_centerY);
    }];
    
    //
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"注册" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16.0 cornerRadius:5];
    
    [confirmBtn addTarget:self action:@selector(goReg) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(btnMargin);
        make.width.mas_equalTo(kScreenWidth - 2*btnMargin);
        make.height.mas_equalTo(h - 5);
        make.top.mas_equalTo(checkBtn.mas_bottom).mas_equalTo(35);
    }];
    
    //登录
    UIButton *loginBtn = [UIButton buttonWithTitle:@"已有账号？立即登录"
                                           titleColor:kTextColor
                                      backgroundColor:kClearColor
                                            titleFont:14.0];
    
    loginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [loginBtn addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn.titleLabel labelWithString:@"已有账号？立即登录"
                                      title:@"登录"
                                       font:Font(14.0)
                                      color:kAppCustomMainColor];
    [self.view addSubview:loginBtn];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(confirmBtn.mas_bottom).offset(15);
    }];
}

- (CLLocationManager *)sysLocationManager {
    
    if (!_sysLocationManager) {
        
        _sysLocationManager = [[CLLocationManager alloc] init];
        _sysLocationManager.delegate = self;
        _sysLocationManager.distanceFilter = 50.0;
        
    }
    return _sysLocationManager;
    
}

#pragma mark - Events

- (void)back {
    
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 登录
 */
- (void)goLogin {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//--//
- (void)sendCaptcha {
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:@"请输入正确的手机号"];
        
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = CAPTCHA_CODE;
    http.parameters[@"bizType"] = USER_REG_CODE;
    http.parameters[@"mobile"] = self.phoneTf.text;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"验证码已发送,请注意查收"];
        
        [self.captchaView.captchaBtn begin];
        
    } failure:^(NSError *error) {
        
        [TLAlert alertWithError:@"发送失败,请检查手机号"];
        
    }];
    
}

- (void)goReg {
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:@"请输入正确的手机号"];
        
        return;
    }
    
    if (!(self.captchaView.captchaTf.text && self.captchaView.captchaTf.text.length > 3)) {
        [TLAlert alertWithInfo:@"请输入正确的验证码"];
        
        return;
    }
    
    if (!(self.pwdTf.text &&self.pwdTf.text.length > 5)) {
        
        [TLAlert alertWithInfo:@"请输入6位以上密码"];
        return;
    }
    
    if (!self.checkBtn.selected) {
        
        [TLAlert alertWithInfo:@"请同意《币格财经用户协议》"];
        return ;
    }
    
    [self.view endEditing:YES];

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_REG_CODE;
    http.parameters[@"mobile"] = self.phoneTf.text;
    http.parameters[@"loginPwd"] = self.pwdTf.text;
//    http.parameters[@"isRegHx"] = @"0";
    http.parameters[@"smsCaptcha"] = self.captchaView.captchaTf.text;
    http.parameters[@"kind"] = APP_KIND;
    http.parameters[@"nickname"] = self.nickNameTF.text;

    [http postWithSuccess:^(id responseObject) {
        
        [self.view endEditing:YES];
        
        [TLAlert alertWithSucces:@"注册成功"];
        NSString *token = responseObject[@"data"][@"token"];
        NSString *userId = responseObject[@"data"][@"userId"];
        
        //保存用户账号和密码
        [[TLUser user] saveUserName:self.phoneTf.text pwd:self.pwdTf.text];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //获取用户信息
            TLNetworking *http = [TLNetworking new];
            http.showView = self.view;
            http.code = USER_INFO;
            http.parameters[@"userId"] = userId;
            http.parameters[@"token"] = token;
            [http postWithSuccess:^(id responseObject) {
                
                NSDictionary *userInfo = responseObject[@"data"];
                [TLUser user].userId = userId;
                [TLUser user].token = token;
                
                //保存信息
                [[TLUser user] saveUserInfo:userInfo];
                [[TLUser user] setUserInfoWithDict:userInfo];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification object:nil];
                if (self.registerSuccess) {
                    
                    self.registerSuccess();
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self dismissViewControllerAnimated:YES
                                             completion:nil];
                });
                
            } failure:^(NSError *error) {
                
            }];
            
        });
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)clickSelect:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
}

- (void)readProtocal {
    
    HTMLStrVC *htmlVC = [[HTMLStrVC alloc] init];
    
    htmlVC.type = HTMLTypeRegProtocol;
    
    [self.navigationController pushViewController:htmlVC animated:YES];
    
}
@end
