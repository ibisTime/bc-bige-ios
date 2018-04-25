//
//  CurrencyBottomView.h
//  bige
//
//  Created by 蔡卓越 on 2018/4/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"

//M
#import "PlatformModel.h"
/**
 币种详情底部界面
 */
typedef NS_ENUM(NSInteger, BottomEventType) {
    
    BottomEventTypeEarlyWarning = 0,    //设置预警
    BottomEventTypeFollow,              //关注
    BottomEventTypeBuy,                 //买
    BottomEventTypeSell,                //卖
};

typedef void(^CurrencyBottomBlock)(BottomEventType type);

@interface CurrencyBottomView : BaseView

@property (nonatomic, copy) CurrencyBottomBlock bottomBlock;
//
@property (nonatomic, strong)PlatformModel *platform;

@end
