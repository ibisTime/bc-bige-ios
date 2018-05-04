//
//  SimulationTradeView.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "SimulationTradeView.h"
//Macro
#import "AppMacro.h"
//Framework
#import <UIImageView+WebCache.h>
//Category
#import "UIButton+EnLargeEdge.h"
#import "NSString+Extension.h"
//M
#import "TradeManager.h"

@interface SimulationTradeView()
//头像
@property (nonatomic, strong) UIImageView *userPhoto;
//昵称
@property (nonatomic, strong) UILabel *nickNameLbl;
//成绩
@property (nonatomic, strong) UILabel *achieveLbl;

@end

@implementation SimulationTradeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.backgroundColor = kWhiteColor;
    //头像
    CGFloat imgWidth = 44;
    
    self.userPhoto = [[UIImageView alloc] initWithImage:USER_PLACEHOLDER_SMALL];
    
    self.userPhoto.frame = CGRectMake(15, 13, imgWidth, imgWidth);
    self.userPhoto.image = USER_PLACEHOLDER_SMALL;
    self.userPhoto.layer.cornerRadius = imgWidth/2.0;
    self.userPhoto.layer.masksToBounds = YES;
    self.userPhoto.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:self.userPhoto];
    //昵称
    self.nickNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:16.0];
    self.nickNameLbl.text = @"模拟练习区";
    [self addSubview:self.nickNameLbl];
    [self.nickNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.userPhoto.mas_right).offset(20);
        make.top.equalTo(self.userPhoto.mas_top).offset(5);
    }];
    //成绩
    self.achieveLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor2
                                                    font:12.0];
    [self addSubview:self.achieveLbl];
    [self.achieveLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nickNameLbl.mas_left);
        make.top.equalTo(self.nickNameLbl.mas_bottom).offset(10);
    }];
    //topLine
    UIView *topLine = [[UIView alloc] init];
    
    topLine.backgroundColor = kLineColor;
    
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.top.equalTo(@70);
        make.height.equalTo(@0.5);
    }];
    
    NSArray *textArr = @[@"总资产", @"浮动盈亏", @"交易所数量", @"总市值", @"当日参考盈亏", @"持有币种"];
    
    for (int i = 0; i < 6; i++) {
        
        CGFloat x = kScreenWidth/3.0*(i%3);
        CGFloat y = 50*(i/3) + 15 + 70;
        //text
        UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kTextColor2
                                                       font:12.0];
        textLbl.text = textArr[i];
        [self addSubview:textLbl];
        [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(15+x));
            make.top.equalTo(@(y));
        }];
        //数值
        UILabel *numLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kTextColor
                                                       font:17.0];
        numLbl.tag = 1500 + i;
        [self addSubview:numLbl];
        [numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(15+x));
            make.top.equalTo(textLbl.mas_bottom).offset(10);
        }];
    }

    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@(-80));
        make.height.equalTo(@0.5);
    }];
    NSArray *titleArr = @[@"买入", @"卖出", @"撤单", @"持仓", @"查询"];
    
    CGFloat btnW = kScreenWidth/5.0;
    
    for (int i = 0; i < 5; i++) {
        
        
        UIButton *btn = [UIButton buttonWithTitle:titleArr[i]
                                       titleColor:kTextColor3
                                  backgroundColor:kClearColor
                                        titleFont:13.0];
        
        [btn setImage:kImage(titleArr[i]) forState:UIControlStateNormal];
        btn.tag = 1600 + i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(bottomLine.mas_bottom);
            make.width.equalTo(@(btnW));
            make.height.equalTo(@(80));
            make.left.equalTo(@(i*btnW));
        }];
        [btn setTitleBottom];
    }
    
}

#pragma mark - Events
- (void)clickBtn:(UIButton *)sender {
    
    NSInteger index = sender.tag - 1600;
        
    if (self.tradeBlock) {
        
        self.tradeBlock(index);
    }
}

#pragma mark - Setting
- (void)setInfoModel:(SimulationTradeInfoModel *)infoModel {
    
    _infoModel = infoModel;
    //头像
    [self.userPhoto sd_setImageWithURL:[NSURL URLWithString:[infoModel.userPhoto convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
    //成绩
    CGFloat rank = [infoModel.rank doubleValue]*100;
    
    self.achieveLbl.text = [NSString stringWithFormat:@"战胜了%.2lf%%的用户", rank];
    //总资产
    NSString *cnyAmount = [NSString stringWithFormat:@"%.2lf", [infoModel.cnyAmount doubleValue]];
    //浮动盈亏
    NSString *totalFloat = [NSString stringWithFormat:@"%.2lf", [infoModel.totalFloat doubleValue]];
    //交易所数量
    NSString *exchangeCount = [infoModel.exchangeCount stringValue];
    //总市值
    NSString *marketAmount = [NSString stringWithFormat:@"%.2lf", [infoModel.marketAmount doubleValue]];
    //当日参考盈亏
    NSString *dailyFloat = [NSString stringWithFormat:@"%.2lf", [infoModel.dailyFloat doubleValue]];
    //持有币种
    NSString *symbolCount = [infoModel.symbolCount stringValue];

    NSArray *valueArr = @[cnyAmount, totalFloat, exchangeCount, marketAmount, dailyFloat, symbolCount];
    
    for (int i = 0; i < 6; i++) {
        
        UILabel *valueLbl = (UILabel *)[self viewWithTag:1500+i];
        
        valueLbl.text = valueArr[i];
    }
}

@end
