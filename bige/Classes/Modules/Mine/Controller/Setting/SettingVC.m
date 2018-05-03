//
//  SettingVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "SettingVC.h"
//Macro
#import "AppMacro.h"
#import "APICodeMacro.h"
//Category
#import "TLAlert.h"
#import "NSString+Check.h"
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>
//M
#import "SettingGroup.h"
#import "SettingModel.h"
//V
#import "SettingTableView.h"
#import "SettingCell.h"
#import "CustomTabBar.h"
#import "BaseView.h"
//C
#import "TLPwdRelatedVC.h"
#import "NavigationController.h"
#import "TLUserLoginVC.h"
#import "EditVC.h"

@interface SettingVC ()

@property (nonatomic, strong) SettingGroup *group;

@property (nonatomic, strong) UIButton *loginOutBtn;

@property (nonatomic, strong) SettingTableView *tableView;
//
@property (nonatomic, strong) BaseView *headerView;
//头像
@property (nonatomic,strong) UIImageView *photoIV;
//
@property (nonatomic, strong) UILabel *textLbl;
//右箭头
@property (nonatomic, strong) UIImageView *rightArrowIV;

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"账号设置";
    //
    [self setGroup];
    //
    [self initTableView];

}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[SettingTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) style:UITableViewStyleGrouped];
    
    self.tableView.group = self.group;
    
    [self.view addSubview:self.tableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    
    [footerView addSubview:self.loginOutBtn];
    
    self.tableView.tableFooterView = footerView;
    
}

#pragma mark - Group
- (void)setGroup {
    
    BaseWeakSelf;
    
    //修改登录密码
    SettingModel *changeLoginPwd = [SettingModel new];
    changeLoginPwd.text = @"修改登录密码";
    [changeLoginPwd setAction:^{
        
        TLPwdRelatedVC *pwdRelatedVC = [[TLPwdRelatedVC alloc] initWithType:TLPwdTypeReset];
        
        pwdRelatedVC.success = ^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            });
        };
        
        [weakSelf.navigationController pushViewController:pwdRelatedVC animated:YES];
        
    }];
    
    //昵称
    UserEditModel *nickNameModel = [UserEditModel new];
    nickNameModel.title = @"";
    nickNameModel.content = [TLUser user].nickname;
    
    SettingModel *changeNickName = [SettingModel new];
    changeNickName.text = @"昵称";
    [changeNickName setAction:^{
        
        EditVC *editVC = [[EditVC alloc] init];
        editVC.title = @"修改昵称";
        editVC.editModel = nickNameModel;
        editVC.type = UserEditTypeNickName;
        
        [weakSelf.navigationController pushViewController:editVC animated:YES];
        
    }];
    
    self.group = [SettingGroup new];
    
    self.group.sections = @[@[changeLoginPwd, changeNickName]];
    
}

#pragma mark- 退出登录

- (UIButton *)loginOutBtn {
    
    if (!_loginOutBtn) {
        
        _loginOutBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 55, kScreenWidth, 45)];
        _loginOutBtn.backgroundColor = kWhiteColor;
        [_loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_loginOutBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
        _loginOutBtn.layer.cornerRadius = 5;
        _loginOutBtn.clipsToBounds = YES;
        _loginOutBtn.titleLabel.font = FONT(15);
        [_loginOutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginOutBtn;
}

- (void)logout {
    
    [TLAlert alertWithTitle:@"" msg:@"是否确认退出" confirmMsg:@"确认" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
        
    } confirm:^(UIAlertAction *action) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
