//
//  WarningSettingCell.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "WarningSettingCell.h"
//Category
#import "UILabel+Extension.h"
#import "NSString+CGSize.h"
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>
#import "NSNumber+Extension.h"

@interface WarningSettingCell()
//图标
@property (nonatomic, strong) UIImageView *iconIV;
//币种
@property (nonatomic, strong) UILabel *symbolLbl;
//当前价格
@property (nonatomic, strong) UILabel *priceLbl;
//预警价格
@property (nonatomic, strong) UILabel *warnPriceLbl;
//预警幅度
@property (nonatomic, strong) UILabel *warnPluctLbl;

@end

@implementation WarningSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //图标
    self.iconIV = [[UIImageView alloc] init];
    
    [self addSubview:self.iconIV];
    //币种
    self.symbolLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kTextColor
                                                      font:13.0];
    [self addSubview:self.symbolLbl];
    
    //当前价格
    self.priceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kTextColor
                                                     font:12.0];
    [self addSubview:self.priceLbl];
    
    //留言
    self.leaveBtn = [UIButton buttonWithImageName:@"预警留言"];
    
    [self addSubview:self.leaveBtn];
    
    //预警幅度
    self.warnPluctLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kClearColor
                                                     font:14.0];
    [self addSubview:self.warnPluctLbl];
    //预警价格
    self.warnPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kClearColor
                                                       font:12.0];
    self.warnPriceLbl.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.warnPriceLbl];
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    //图标
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.centerY.equalTo(@0);
        make.width.height.equalTo(@16);
    }];
    //币种
    [self.symbolLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.iconIV.mas_right).offset(10);
        make.centerY.equalTo(@0);
    }];
    //当前价格
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kWidth(140)));
        make.centerY.equalTo(@0);
    }];
    //留言
    [self.leaveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(0));
        make.centerY.equalTo(@0);
        make.width.equalTo(@50);
        make.height.equalTo(@32);
    }];
    //预警幅度
    [self.warnPluctLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.leaveBtn.mas_left).offset(-15);
        make.bottom.equalTo(self.mas_centerY).offset(-5);
    }];
    
    //预警价格
    [self.warnPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.leaveBtn.mas_left).offset(-15);
        make.top.equalTo(self.mas_centerY).offset(5);
    }];
}
#pragma mark - Setting

- (void)setWarning:(WarningModel *)warning {
    
    _warning = warning;
    //图标
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:[warning.symbolPic convertImageUrl]]
                   placeholderImage:kImage(@"默认图标")];
    //币种名称
    self.symbolLbl.text = [warning.symbol uppercaseString];
    //人民币价格
    self.priceLbl.text = [NSString stringWithFormat:@"￥%.2lf", [warning.currentPrice doubleValue]];
    //预警幅度
    
    UIColor *fluctColor = [warning getPercentColorWithPercent:warning.changeRate];
    self.warnPluctLbl.textColor = fluctColor;
    NSString *fluctStr = [warning getResultWithPercent:warning.changeRate];
    self.warnPluctLbl.text = fluctStr;
    //预警价格
    UIColor *priceColor = [warning getPercentColorWithPercent:warning.changeRate];
    self.warnPriceLbl.textColor = priceColor;
    self.warnPriceLbl.text = [NSString stringWithFormat:@"%.2lf", [warning.warnPrice doubleValue]];
}

@end
