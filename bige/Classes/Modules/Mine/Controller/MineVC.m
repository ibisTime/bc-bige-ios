//
//  MineVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/3/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "MineVC.h"
//Manager
#import "TLUploadManager.h"
//Macro
#import "APICodeMacro.h"
#import "AppMacro.h"
//Category
#import "NSString+Extension.h"
#import "UIBarButtonItem+convience.h"
//Extension
#import <UIImageView+WebCache.h>
#import "TLProgressHUD.h"
#import "NSString+Check.h"
#import <MBProgressHUD.h>
#import <ZendeskSDK/ZendeskSDK.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <CDCommon/UIScrollView+TLAdd.h>

//M
#import "MineGroup.h"
//V
#import "MineTableView.h"
#import "MineHeaderView.h"
#import "TLImagePicker.h"
#import "BaseView.h"
//C
#import "LinkUsVC.h"
#import "NavigationController.h"
#import "TLUserLoginVC.h"
#import "MyCollectionListVC.h"
#import "SettingVC.h"
#import "WarningSettingVC.h"
#import "IntegralCenterVC.h"
#import "FollowListVC.h"

@interface MineVC ()<MineHeaderDelegate>
//模型
@property (nonatomic, strong) MineGroup *group;
//
@property (nonatomic, strong) MineTableView *tableView;
//头部
@property (nonatomic, strong) MineHeaderView *headerView;
//选择头像
@property (nonatomic, strong) TLImagePicker *imagePicker;

@end

@implementation MineVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //zendesk
    [self zendeskUIConfig];
    //通知
    [self addNotification];
    //
    [self initTableView];
    //模型
    [self initGroup];
    //
    [self changeInfo];
    
}

#pragma mark - Init

- (void)zendeskUIConfig {
    
    //修改zendesk导航栏文字颜色
    NSDictionary *navbarAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                      kWhiteColor ,UITextAttributeTextColor, nil];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //修改zendesk导航栏背景颜色
    [[UINavigationBar appearance] setBarTintColor:kAppCustomMainColor];
    [[UINavigationBar appearance] setTitleTextAttributes:navbarAttributes];
}

- (void)initGroup {
    
    BaseWeakSelf;
    
    //账号设置
    MineModel *accountSetting = [MineModel new];
    
    accountSetting.text = @"账号设置";
    accountSetting.isSpecial = YES;
    accountSetting.action = ^{
        
        [weakSelf checkLogin:^{
            
            SettingVC *settingVC = [SettingVC new];
            
            [weakSelf.navigationController pushViewController:settingVC animated:YES];
        }];
    };
    
    //预警/通知
    MineModel *notification = [MineModel new];
    
    notification.text = @"预警设置";
    notification.isSpecial = YES;
    notification.action = ^{
        
        [weakSelf checkLogin:^{
            
            WarningSettingVC *warnVC = [WarningSettingVC new];
            
            [weakSelf.navigationController pushViewController:warnVC animated:YES];
        }];
    };
    //反馈
    MineModel *feedback = [MineModel new];
    
    feedback.text = @"反馈";
    feedback.isSpecial = YES;
    feedback.action = ^{
        
        [weakSelf checkLogin:^{
            
            ZDKHelpCenterOverviewContentModel *contentModel = [ZDKHelpCenterOverviewContentModel defaultContent];

//            [ZDKHelpCenter setUIDelegate:weakSelf];

            [ZDKHelpCenter pushHelpCenterOverview:self.navigationController
                                 withContentModel:contentModel];
        }];
    };
    
    //联系我们
    MineModel *aboutUs = [MineModel new];
    
    aboutUs.text = @"联系我们";
    aboutUs.isSpecial = YES;
    aboutUs.action = ^{
        
        LinkUsVC *linkVC = [LinkUsVC new];
        
        [weakSelf.navigationController pushViewController:linkVC animated:YES];
    };
    
    self.group = [MineGroup new];
    
    self.group.sections = @[@[accountSetting, notification],@[feedback, aboutUs]];
    
    self.tableView.mineGroup = self.group;
    
    [self.tableView reloadData];
}

- (void)initTableView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(155 + kStatusBarHeight))];
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = kImage(@"我的背景");
    
    imageView.tag = 1500;
//    imageView.backgroundColor = kAppCustomMainColor;
    
    [self.view addSubview:imageView];
    
    self.tableView = [[MineTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight) style:UITableViewStyleGrouped];
    
    [self.view addSubview:self.tableView];
    
    //tableview的header
    self.headerView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(155 + kStatusBarHeight) + 70)];
    
    self.headerView.delegate = self;
    
    self.tableView.tableHeaderView = self.headerView;

}

- (TLImagePicker *)imagePicker {
    
    if (!_imagePicker) {
        
        BaseWeakSelf;
        
        _imagePicker = [[TLImagePicker alloc] initWithVC:self];
        
        _imagePicker.allowsEditing = NO;
        _imagePicker.clipHeight = kScreenWidth;
        
        _imagePicker.pickFinish = ^(UIImage *photo, NSDictionary *info){
            
            UIImage *image = info == nil ? photo: info[@"UIImagePickerControllerOriginalImage"];
            
            NSData *imgData = UIImageJPEGRepresentation(image, 0.1);
            
            //进行上传
            [TLProgressHUD show];
            
            TLUploadManager *manager = [TLUploadManager manager];
            
            manager.imgData = imgData;
            manager.image = image;
            
            [manager getTokenShowView:weakSelf.view succes:^(NSString *key) {
                
                [weakSelf changeHeadIconWithKey:key imgData:imgData];
                
            } failure:^(NSError *error) {
                
            }];
        };
    }
    
    return _imagePicker;
}

#pragma mark - Notification
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserInfoChange object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:kUserLoginOutNotification object:nil];
}

#pragma mark - Events
- (void)changeInfo {
    //
    [self.headerView.userPhoto sd_setImageWithURL:[NSURL URLWithString:[[TLUser user].photo convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
    
    if (![TLUser user].isLogin) {
        
        [self.headerView.nameBtn setTitle:@"点击登录" forState:UIControlStateNormal];
        self.tableView.tableFooterView.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
        
    } else {
        
        [self.headerView.nameBtn setTitle:[TLUser user].nickname forState:UIControlStateNormal];
    }
}

- (void)loginOut {
    
    [self.headerView.nameBtn setTitle:@"点击登录" forState:UIControlStateNormal];

    self.headerView.userPhoto.image = USER_PLACEHOLDER_SMALL;
    self.navigationItem.rightBarButtonItem = nil;
}

/**
 判断用户是否登录
 */
- (void)checkLogin:(void(^)(void))loginSuccess {
    
    if(![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [TLUserLoginVC new];
        
        loginVC.loginSuccess = loginSuccess;
        
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        return ;
    }
    
    if (loginSuccess) {
        
        loginSuccess();
    }
}

- (void)logout {
    
    [TLAlert alertWithTitle:@"" msg:@"是否确认退出" confirmMsg:@"确认" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
        
    } confirm:^(UIAlertAction *action) {
        
        self.tableView.tableFooterView.hidden = YES;

        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];
    }];
    
}

/**
 清除缓存
 */
- (void)clearCache {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.size = CGSizeMake(100, 100);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[SDImageCache sharedImageCache] clearDisk];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            hud.mode = MBProgressHUDModeAnnularDeterminate;
            hud.labelText = @"清除中...";
            
        });
        
        float progress = 0.0f;
        
        while (progress < 1.0f) {
            
            progress += 0.02f;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                hud.progress = progress;
            });
            usleep(50000);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *image = [UIImage imageNamed:@"clear_complete"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            
            imageView.frame = CGRectMake(0, 0, 35, 35);
            
            hud.customView = imageView;
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"清除完成";
            
            [_tableView reloadData];
            
            [hud hide:YES afterDelay:1];
        });
        
    });
    
}

#pragma mark - Data
- (void)changeHeadIconWithKey:(NSString *)key imgData:(NSData *)imgData {
    
    TLNetworking *http = [TLNetworking new];
    
    //    http.showView = self.view;
    http.code = USER_CHANGE_USER_PHOTO;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"photo"] = key;
    http.parameters[@"token"] = [TLUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
        [TLProgressHUD dismiss];
        
        [TLAlert alertWithSucces:@"修改头像成功"];
        
        [TLUser user].photo = key;
        //替换头像
        [self.headerView.userPhoto sd_setImageWithURL:[NSURL URLWithString:[key convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - MineHeaderSeletedDelegate
- (void)didSelectedWithType:(MineHeaderType)type idx:(NSInteger)idx {
    
    BaseWeakSelf;
    
    switch (type) {
        case MineHeaderTypeLogin:
        {
            [self checkLogin:nil];
        }break;
            
        case MineHeaderTypeIntegralCenter:
        {
//            [self checkLogin:^{
//
//                IntegralCenterVC *centerVC = [IntegralCenterVC new];
//
//                [weakSelf.navigationController pushViewController:centerVC animated:YES];
//            }];
            IntegralCenterVC *centerVC = [IntegralCenterVC new];
            
            [self.navigationController pushViewController:centerVC animated:YES];
        }break;
            
        case MineHeaderTypeCollection:
        {
            [self checkLogin:^{
                
                MyCollectionListVC *collectionVC = [MyCollectionListVC new];
                
                [weakSelf.navigationController pushViewController:collectionVC animated:YES];
            }];
            
        }break;
            
        case MineHeaderTypePhoto:
        {
            [self checkLogin:^{
                
            } event:^{
                
                [weakSelf.imagePicker picker];
            }];
        }break;
            
        case MineHeaderTypeFollow:
        {
            [self checkLogin:^{
                
                FollowListVC *followVC = [FollowListVC new];
                
                [self.navigationController pushViewController:followVC animated:YES];
            }];
        }break;
            
        default:
            break;
    }
}

/**
 VC被释放时移除通知
 */
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
