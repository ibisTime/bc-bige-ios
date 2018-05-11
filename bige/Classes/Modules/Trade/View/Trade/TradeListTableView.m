//
//  TradeListTableView.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TradeListTableView.h"

//Manager
#import "TradeManager.h"
//Macro
//Framework
//Category
#import "NSNumber+Extension.h"
#import "NSString+Check.h"
//Extension
//M
//V
#import "TradeListCell.h"

@interface TradeListTableView() <UITableViewDelegate, UITableViewDataSource>

@end

@implementation TradeListTableView

static NSString *identifierCell = @"TradeListCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        self.scrollEnabled = NO;
        [self registerClass:[TradeListCell class] forCellReuseIdentifier:identifierCell];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TradeListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    cell.tradeInfo = indexPath.section == 0 ? self.tradeList.asks[(self.tradeList.asks.count - indexPath.row - 1)]: self.tradeList.bids[indexPath.row];
    
    cell.priceLbl.textColor = indexPath.section == 0 ? kThemeColor: kRiseColor;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 22;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 40;
    }
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        UIView *section1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2.0, 37)];
        
        section1.backgroundColor = kWhiteColor;
        
        UILabel *priceTextLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                        textColor:kHexColor(@"#c2c2c2")
                                                             font:10.0];
        priceTextLbl.text = @"价格";
        [section1 addSubview:priceTextLbl];
        [priceTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@15);
            make.centerY.equalTo(@0);
        }];
        
        UILabel *numTextLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                      textColor:kHexColor(@"#c2c2c2")
                                                           font:10.0];
        numTextLbl.text = @"数量";
        [section1 addSubview:numTextLbl];
        [numTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(@(-15));
            make.centerY.equalTo(@0);
        }];
        
        return section1;
    }
    
    UIColor *priceColor = [[TradeManager manager].direction isEqualToString:@"0"] ? kRiseColor: kThemeColor;
    
    UIView *section2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2.0, 37)];
    
    section2.backgroundColor = kWhiteColor;

    //币种价格
    UILabel *lastPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                    textColor:priceColor
                                                         font:14.0];
    if ([[TradeManager manager].direction isEqualToString:@"0"]) {
        
        if (self.tradeList.bids.count > 0) {
            
            TradeInfoModel *tradeInfo = self.tradeList.asks[0];
            
            lastPriceLbl.text = [tradeInfo.price convertToRealMoneyWithNum:8];
            lastPriceLbl.textColor = kThemeColor;
            
            [TradeManager manager].price = tradeInfo.price;
        }
        
    } else {
        
        if (self.tradeList.asks.count > 0) {
            
            TradeInfoModel *tradeInfo = self.tradeList.bids[0];
            
            lastPriceLbl.text = [tradeInfo.price convertToRealMoneyWithNum:8];
            lastPriceLbl.textColor = kRiseColor;

            [TradeManager manager].price = tradeInfo.price;
        }
    }
    
    [section2 addSubview:lastPriceLbl];
    [lastPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(15));
        make.top.equalTo(@5);
    }];
    //相对于人民币价格
    UILabel *cnyPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kTextColor2
                                                        font:10.0];
    
    if ([lastPriceLbl.text valid] && [[[TradeManager manager].cnyPrice stringValue] valid]) {
        
        NSString *cnyPrice = [NSNumber mult1:lastPriceLbl.text mult2:[[TradeManager manager].cnyPrice stringValue] scale:2];
        cnyPriceLbl.text = [NSString stringWithFormat:@"≈%@CNY", cnyPrice];
    }
   
    [section2 addSubview:cnyPriceLbl];
    [cnyPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(lastPriceLbl.mas_left);
        make.top.equalTo(lastPriceLbl.mas_bottom).offset(4);
    }];
    
    return section2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

@end
