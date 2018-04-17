//
//  InformationDetailHeaderView.h
//  bige
//
//  Created by 蔡卓越 on 2018/3/20.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"
//M
#import "InfoDetailModel.h"

typedef NS_ENUM(NSInteger, InfoShareType) {
    
    InfoShareTypeWechat = 0,    //微信好友
    InfoShareTypeTimeline,      //朋友圈
};
typedef void(^InfoShareBlock)(InfoShareType type);

@interface InformationDetailHeaderView : UIScrollView
//
@property (nonatomic, strong) InfoDetailModel *detailModel;
//
@property (nonatomic, copy) InfoShareBlock shareBlock;

@end
