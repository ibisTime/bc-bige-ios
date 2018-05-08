//
//  SimulationTradeVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "SimulationTradeVC.h"

//Macro
//Framework
//Category
#import "UIButton+EnLargeEdge.h"
//Extension
#import <ZendeskSDK/ZendeskSDK.h>
//M
#import "SimulationTradeInfoModel.h"
#import "TradeManager.h"

//V
#import "SimulationTradeView.h"
#import "TLBannerView.h"
//C
#import "SimulationTradeDetailVC.h"
#import "SimulationContactVC.h"
#import "KLineTrainCampVC.h"
#import "RealAssetLinkVC.h"

@interface SimulationTradeVC ()<ZDKHelpCenterConversationsUIDelegate>
//
@property (nonatomic, strong) SimulationTradeView *tradeView;
//模拟交易信息
@property (nonatomic, strong) SimulationTradeInfoModel *infoModel;
//
@property (nonatomic, strong) TLBannerView *bannerView;
//
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation SimulationTradeVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //获取资产概况
    [self requestAssetInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //头部
    [self initTradeView];
    //链接
    [self initBannerView];
    //底部按钮
    [self initBottomView];
}

#pragma mark - Init
- (void)zendeskUIConfig {
    
    //修改zendesk导航栏文字颜色
    NSDictionary *navbarAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                      kWhiteColor ,UITextAttributeTextColor, nil];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:navbarAttributes];
}

- (void)initTradeView {
    
    BaseWeakSelf;
    
    self.tradeView = [[SimulationTradeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 270)];
    
    self.tradeView.tradeBlock = ^(NSInteger type) {
        
        [weakSelf tradeEventWithType:type];
    };
    
    [self.bgSV addSubview:self.tradeView];
    
}

- (void)initBannerView {
    
    //轮播图
    TLBannerView *bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, self.tradeView.yy + 10, kScreenWidth, kWidth(85))];
    
    bannerView.backgroundColor = kWhiteColor;
    bannerView.imgUrls = @[@"快讯分析"];
    
    [self.bgSV addSubview:bannerView];
    
    self.bannerView = bannerView;
}

- (void)initBottomView {
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bannerView.yy + 10, kScreenWidth, 160)];
    
    self.bottomView.backgroundColor = kWhiteColor;
    
    [self.bgSV addSubview:self.bottomView];
    NSArray *textArr = @[@"模拟大赛", @"投资教程", @"真实资产链接", @"K线训练营"];
    
    for (int i = 0; i < textArr.count; i++) {
        
        CGFloat h = 80;
        CGFloat w = kScreenWidth/2.0;
        CGFloat x = i%2*w;
        CGFloat y = i/2*h;
        
        UIButton *btn = [UIButton buttonWithTitle:@""
                                       titleColor:kTextColor
                                  backgroundColor:kClearColor
                                        titleFont:14.0];
        btn.tag = 1700 + i;
        btn.frame = CGRectMake(x, y, w, h);
        [btn addTarget:self action:@selector(clickBottomBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:btn];
        //
        UIImageView *iconIV = [[UIImageView alloc] initWithImage:kImage(textArr[i])];
        
        [btn addSubview:iconIV];
        [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@20);
            make.centerY.equalTo(@0);
        }];
        //text
        UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                            
                                                   textColor:kTextColor font:14.0];
        textLbl.text = textArr[i];
        
        [btn addSubview:textLbl];
        [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(iconIV.mas_right).offset(15);
            make.centerY.equalTo(@0);
        }];
    }
    
    //横线
    UIView *hLine = [[UIView alloc] init];
    
    hLine.backgroundColor = kLineColor;
    
    [self.bottomView addSubview:hLine];
    [hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.height.equalTo(@0.5);
        make.centerY.equalTo(@0);
    }];
    //竖线
    UIView *vLine = [[UIView alloc] init];
    
    vLine.backgroundColor = kLineColor;
    
    [self.bottomView addSubview:vLine];
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(@0);
        make.width.equalTo(@0.5);
        make.centerX.equalTo(@0);
    }];
}

#pragma mark - Events
- (void)clickLineBtn:(UIButton *)sender {
    
    
}

- (void)clickBottomBtn:(UIButton *)sender {
    
    NSInteger index = sender.tag - 1700;
    
    switch (index) {
        case 0:
        {
            SimulationContactVC *contactVC = [SimulationContactVC new];
            
            [self.navigationController pushViewController:contactVC animated:YES];
        }break;
           
        case 1:
        {
            //zendesk
            [self zendeskUIConfig];
            
            ZDKHelpCenterOverviewContentModel *contentModel = [ZDKHelpCenterOverviewContentModel defaultContent];
            
            [ZDKHelpCenter setUIDelegate:self];
            
            [ZDKHelpCenter pushHelpCenterOverview:self.navigationController
                                 withContentModel:contentModel];
        }break;
        
        case 2:
        {
            RealAssetLinkVC *linkVC = [RealAssetLinkVC new];
            
            [self.navigationController pushViewController:linkVC animated:YES];
        }break;
            
        case 3:
        {
            KLineTrainCampVC *campVC = [KLineTrainCampVC new];
            
            [self.navigationController pushViewController:campVC animated:YES];
        }break;
            
        default:
            break;
    }
}

- (void)tradeEventWithType:(NSInteger )type {
    
    switch (type) {
        //买入
        case 0:
        {
            SimulationTradeDetailVC *detailVC = [SimulationTradeDetailVC new];
            
            detailVC.direction = @"0";
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }break;
        //卖出
        case 1:
        {
            SimulationTradeDetailVC *detailVC = [SimulationTradeDetailVC new];
            
            detailVC.direction = @"1";
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }break;
        //撤单
        case 2:
        {
            
        }break;
        //持仓
        case 3:
        {
            
        }break;
        //查询
        case 4:
        {
            
        }break;
            
        default:
            break;
    }
    
}

#pragma mark - Data
- (void)requestAssetInfo {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628511";
    http.showView = self.view;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.infoModel = [SimulationTradeInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        self.tradeView.infoModel = self.infoModel;
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - ZDKHelpCenterConversationsUIDelegate

- (ZDKContactUsVisibility)active {

    return ZDKContactUsVisibilityOff;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
