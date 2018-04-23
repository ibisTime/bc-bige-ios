//
//  TLUserLoginVC.m
//  bige
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "TLUserLoginVC.h"

//Macro
#import "APICodeMacro.h"
#import "AppMacro.h"
//Category
#import "NSString+Check.h"
#import "UIBarButtonItem+convience.h"
#import "UILabel+Extension.h"
#import "UIButton+EnLargeEdge.h"
//M
#import "ThirdLoginModel.h"
//V
#import "TLTextField.h"
#import "TLPickerTextField.h"
#import "BaseView.h"
//C
#import "TLUserRegisterVC.h"
#import "TLUserForgetPwdVC.h"
#import "NavigationController.h"

@interface TLUserLoginVC ()

@property (nonatomic, strong) TLTextField *phoneTf;
@property (nonatomic,strong) TLTextField *pwdTf;
//第三方登录
@property (nonatomic, strong) BaseView *thirdLoginView;
//手机号
@property (nonatomic, copy) NSString *mobile;

@end

@implementation TLUserLoginVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //取消
    [self setBarButtonItem];
    //
    [self setUpUI];
    //登录成功回调
    [self setUpNotification];
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

    //登录
    UILabel *loginLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kTextColor
                                                        font:24];
    //字体加粗
    [loginLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
    loginLbl.frame = CGRectMake(0, kStatusBarHeight+75, 100, 24);
    loginLbl.text = @"登录";
    loginLbl.textAlignment = NSTextAlignmentCenter;
    loginLbl.centerX = self.view.centerX;
    [self.view addSubview:loginLbl];
    
    UIView *bgView = [[UIView alloc] init];
    
    bgView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(loginLbl.mas_bottom).offset(45);
        make.left.equalTo(@(margin));
        make.height.equalTo(@(2*h+1));
        make.width.equalTo(@(w));
    }];
    
    //账号
    TLTextField *phoneTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, w, h)
                                                     leftTitle:@""
                                                   titleWidth:0
                                                  placeholder:@"手机号码"];
    
    phoneTf.keyboardType = UIKeyboardTypeNumberPad;

    [bgView addSubview:phoneTf];
    self.phoneTf = phoneTf;
    
    //密码
    TLTextField *pwdTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, phoneTf.yy + 1, w, h)
                                                  leftTitle:@""
                                                 titleWidth:0
                                                placeholder:@"请输入密码"];
    pwdTf.secureTextEntry = YES;
    [bgView addSubview:pwdTf];
    self.pwdTf = pwdTf;
    
    for (int i = 0; i < 2; i++) {
        
        UIView *line = [[UIView alloc] init];
        
        line.backgroundColor = kLineColor;
        
        [bgView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@0.5);
            make.top.equalTo(@((i+1)*h));
        }];
    }
    //登录
    UIButton *loginBtn = [UIButton buttonWithTitle:@"登录"
                                        titleColor:kWhiteColor
                                   backgroundColor:kAppCustomMainColor
                                         titleFont:17.0
                                      cornerRadius:5];
    [loginBtn addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.height.equalTo(@(h - 5));
        make.width.equalTo(@(kScreenWidth - 30));
        make.top.equalTo(bgView.mas_bottom).offset(60);
    }];
    
    //找回密码
    UIButton *forgetPwdBtn = [UIButton buttonWithTitle:@"忘记密码?"
                                            titleColor:kTextColor2
                                       backgroundColor:kClearColor
                                             titleFont:14.0];
    
    forgetPwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgetPwdBtn addTarget:self action:@selector(findPwd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPwdBtn];
    
    [forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(loginBtn.mas_right);
        make.top.equalTo(pwdTf.mas_bottom).offset(10);
    }];
    //注册
    UIButton *registerBtn = [UIButton buttonWithTitle:@"没有账号？立即注册"
                                           titleColor:kTextColor
                                      backgroundColor:kClearColor
                                            titleFont:14.0];
    
    registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [registerBtn addTarget:self action:@selector(goRegister) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn.titleLabel labelWithString:@"没有账号？立即注册"
                                      title:@"注册"
                                       font:Font(14.0)
                                      color:kAppCustomMainColor];
    [self.view addSubview:registerBtn];
    
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(loginBtn.mas_bottom).offset(15);
    }];
    
}

- (void)setUpNotification {

    //登录成功之后，给予回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:kUserLoginNotification object:nil];
}

#pragma mark - Events

- (void)back {
    
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//登录成功
- (void)login {

    [self dismissViewControllerAnimated:YES completion:nil];

    if (self.loginSuccess) {

        self.loginSuccess();
    }
}
//忘记密码
- (void)findPwd {
    
    TLUserForgetPwdVC *vc = [[TLUserForgetPwdVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//注册
- (void)goRegister {
    
    BaseWeakSelf;
    TLUserRegisterVC *registerVC = [[TLUserRegisterVC alloc] init];
    
    registerVC.registerSuccess = ^{
        
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:registerVC];
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 登录
 */
- (void)goLogin {
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:@"请输入正确的手机号"];
        
        return;
    }

    if (!(self.pwdTf.text &&self.pwdTf.text.length > 5)) {
        
        [TLAlert alertWithInfo:@"请输入6位以上密码"];
        return;
    }
    
    [self.view endEditing:YES];

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_LOGIN_CODE;
    
    http.parameters[@"loginName"] = self.phoneTf.text;
    http.parameters[@"loginPwd"] = self.pwdTf.text;
    http.parameters[@"kind"] = APP_KIND;

    [http postWithSuccess:^(id responseObject) {
        
        [self requesUserInfoWithResponseObject:responseObject];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requesUserInfoWithResponseObject:(id)responseObject {
    
    NSString *token = responseObject[@"data"][@"token"];
    NSString *userId = responseObject[@"data"][@"userId"];
    
    //1.获取用户信息
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_INFO;
    http.parameters[@"userId"] = userId;
    http.parameters[@"token"] = token;
    [http postWithSuccess:^(id responseObject) {
        
        NSDictionary *userInfo = responseObject[@"data"];
        
        [TLUser user].userId = userId;
        [TLUser user].token = token;
        
        //保存用户信息
        [[TLUser user] saveUserInfo:userInfo];
        //初始化用户信息
        [[TLUser user] setUserInfoWithDict:userInfo];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification object:nil];
        
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark - 推送
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,
     [self logSet:tags], alias];
    
    NSLog(@"TagsAlias回调:%@", callbackString);
}

- (NSString *)logSet:(NSSet *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}


/**
 VC被释放时移除通知
 */
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
