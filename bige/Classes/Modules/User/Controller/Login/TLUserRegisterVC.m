//
//  TLUserRegisterVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "TLUserRegisterVC.h"
//#import "SGScanningQRCodeVC.h"
#import <Photos/Photos.h>
#import "HTMLStrVC.h"

#import <CoreLocation/CoreLocation.h>

#import "CaptchaView.h"

#import "APICodeMacro.h"
#import "NSString+Check.h"

@interface TLUserRegisterVC ()<CLLocationManagerDelegate>

@property (nonatomic,strong) CaptchaView *captchaView;
//昵称
@property (nonatomic, strong) TLTextField *nickNameTF;

@property (nonatomic,strong) TLTextField *phoneTf;

@property (nonatomic,strong) TLTextField *pwdTf;

@property (nonatomic,strong) TLTextField *rePwdTf;

@property (nonatomic,strong) CLLocationManager *sysLocationManager;
//
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *area;
//同意按钮
@property (nonatomic, strong) UIButton *checkBtn;

@end

@implementation TLUserRegisterVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"注册";
    
    [self setUpUI];

}

#pragma mark - Events

- (void)setUpUI {
    
    self.view.backgroundColor = kBackgroundColor;
    
    CGFloat margin = ACCOUNT_MARGIN;
    CGFloat w = kScreenWidth - 2*margin;
    CGFloat h = ACCOUNT_HEIGHT;
    
    CGFloat btnMargin = 15;
    
    //昵称
    TLTextField *nickNameTF = [[TLTextField alloc] initWithFrame:CGRectMake(margin, 10, w, h) leftTitle:@"昵称" titleWidth:100 placeholder:@"请设置你的昵称"];
    
    [self.view addSubview:nickNameTF];
    self.nickNameTF = nickNameTF;
    
    //账号
    TLTextField *phoneTf = [[TLTextField alloc] initWithFrame:CGRectMake(margin, nickNameTF.yy + 1, w, h) leftTitle:@"手机号" titleWidth:100 placeholder:@"请输入手机号"];
    phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:phoneTf];
    self.phoneTf = phoneTf;
    
    //验证码
    CaptchaView *captchaView = [[CaptchaView alloc] initWithFrame:CGRectMake(margin, phoneTf.yy + 1, w, h)];
    [captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:captchaView];

    self.captchaView = captchaView;
    
    //密码
    TLTextField *pwdTf = [[TLTextField alloc] initWithFrame:CGRectMake(margin, captchaView.yy + 10, w, h) leftTitle:@"新密码" titleWidth:100 placeholder:@"请输入密码(不少于6位)"];
    pwdTf.secureTextEntry = YES;
    
    [self.view addSubview:pwdTf];
    self.pwdTf = pwdTf;
    
    //re密码
    TLTextField *rePwdTf = [[TLTextField alloc] initWithFrame:CGRectMake(margin, pwdTf.yy + 1, w, h) leftTitle:@"确认密码" titleWidth:100 placeholder:@"确认密码"];
    rePwdTf.secureTextEntry = YES;
    [self.view addSubview:rePwdTf];
    self.rePwdTf = rePwdTf;
    
//    for (int i = 0; i < 2; i++) {
    
//        UIView *line = [[UIView alloc] init];
//
//        line.backgroundColor = kLineColor;
//
//        [self.view addSubview:line];
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.left.mas_equalTo(margin);
//            make.right.mas_equalTo(0);
//            make.height.mas_equalTo(0.5);
//            make.top.mas_equalTo(10 + h + i*(2*h + 10 + 1));
//
//        }];
//    }
    
    //
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"确认注册" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16.0 cornerRadius:5];
    
    [confirmBtn addTarget:self action:@selector(goReg) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(btnMargin);
        make.width.mas_equalTo(kScreenWidth - 2*btnMargin);
        make.height.mas_equalTo(h - 5);
        make.top.mas_equalTo(rePwdTf.mas_bottom).mas_equalTo(40);
        
    }];
    
    //选择按钮
    UIButton *checkBtn = [UIButton buttonWithImageName:@"不打勾" selectedImageName:@"打勾"];
    
    checkBtn.selected = YES;
    
    [checkBtn addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:checkBtn];
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(confirmBtn.mas_left).offset(5);
        make.top.equalTo(confirmBtn.mas_bottom).offset(18);
    }];
    
    self.checkBtn = checkBtn;
    
    NSString *text = @"我已阅读并同意";
    
    //text
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:12];
    
    textLbl.text = text;
    
    textLbl.userInteractionEnabled = YES;
    
    [self.view addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(checkBtn.mas_right).offset(5);
        make.centerY.equalTo(checkBtn.mas_centerY);
        
    }];
    
    UIButton *protocolBtn = [UIButton buttonWithTitle:@"《注册协议》" titleColor:kAppCustomMainColor backgroundColor:kClearColor titleFont:12.0];
    
    [protocolBtn addTarget:self action:@selector(readProtocal) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:protocolBtn];
    [protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(textLbl.mas_right);
        make.centerY.equalTo(checkBtn.mas_centerY);
        
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
    
    if (![self.nickNameTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请设置你的昵称"];
        
        return ;
    }
    
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
    
    if (![self.pwdTf.text isEqualToString:self.rePwdTf.text]) {
        
        [TLAlert alertWithInfo:@"输入的密码不一致"];
        return;
        
    }
    
    if (!self.checkBtn.selected) {
        
        [TLAlert alertWithInfo:@"请同意《注册协议》"];
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
