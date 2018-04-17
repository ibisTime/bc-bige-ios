 //
//  TLUser.h
//  bige
//
//  Created by  tianlei on 2016/12/14.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "TLBaseModel.h"
#import "TLUserExt.h"

@class TLUserExt;

@interface TLUser : TLBaseModel

+ (instancetype)user;
/*
 基础
 */
//用户ID
@property (nonatomic, copy) NSString *userId;
//Token
@property (nonatomic, copy) NSString *token;
//手机号
@property (nonatomic, copy) NSString *mobile;
//前端类型
@property (nonatomic, copy) NSString *kind;
//昵称
@property (nonatomic, copy) NSString *nickname;
//公司编号
@property (nonatomic, copy) NSString *companyCode;
//用户名
@property (nonatomic, strong) NSString *userName;
//用户密码
@property (nonatomic, strong) NSString *userPassward;
/*
 业务需求
 */
//状态
@property (nonatomic, strong) NSString *status;
//等级
@property (nonatomic, copy) NSString *level;
//登录名
@property (nonatomic, copy) NSString *loginName;
//头像
@property (nonatomic, copy) NSString *photo;
//性别
@property (nonatomic, copy) NSString *gender;
//生日
@property (nonatomic, copy) NSString *birthday;
//注册时间
@property (nonatomic, copy) NSString *createDatetime;
//邮箱
@property (nonatomic, copy) NSString *email;
//金额
@property (nonatomic, copy) NSString *amount;
//0 未设置交易密码 1已设置
@property (nonatomic, copy) NSString *tradepwdFlag;
//真实姓名
@property (nonatomic, copy) NSString *realName;
//身份证
@property (nonatomic, copy) NSString *idNo;
//
@property (nonatomic, copy) NSString *remark;
//人民币账户
@property (nonatomic, copy) NSString *rmbAccountNumber;
//积分账户
@property (nonatomic, copy) NSString *jfAccountNumber;
//邀请码
@property (nonatomic, copy) NSString *inviteCode;
//邀请人个数
@property (nonatomic, copy) NSString *referrerNum;
//实名认证的 --- 临时参数
@property (nonatomic, copy) NSString *tempBizNo;
@property (nonatomic, copy) NSString *tempRealName;
@property (nonatomic, copy) NSString *tempIdNo;

//检查是否登录
- (BOOL)checkLogin;
//是否为需要登录，如果已登录，取出用户信息
- (BOOL)isLogin;
//用户已登录状态，则重新登录
- (void)reLogin;
//保存登录账号和密码
- (void)saveUserName:(NSString *)userName pwd:(NSString *)pwd;
//登出
- (void)loginOut;
//存储用户信息
- (void)saveUserInfo:(NSDictionary *)userInfo;
//设置用户信息
- (void)setUserInfoWithDict:(NSDictionary *)dict;
//异步更新用户信息
- (void)updateUserInfo;
//获取七牛云域名
- (void)requestQiniuDomain;

@end

FOUNDATION_EXTERN  NSString *const kUserLoginNotification;
FOUNDATION_EXTERN  NSString *const kUserLoginOutNotification;
FOUNDATION_EXTERN  NSString *const kUserInfoChange;
FOUNDATION_EXTERN  NSString *const kUserTokenExpiredNotification;    //Token过期

