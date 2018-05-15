//
//  InformationModel.h
//  bige
//
//  Created by 蔡卓越 on 2018/3/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface InformationModel : BaseModel
//编号
@property (nonatomic, copy) NSString *code;
//标题
@property (nonatomic, copy) NSString *title;
//时间
@property (nonatomic, copy) NSString *showDatetime;
//收藏数
@property (nonatomic, assign) NSInteger collectCount;
//阅读数
@property (nonatomic, assign) NSInteger readCount;
//评论数
@property (nonatomic, assign) NSInteger commentCount;
//缩略图
@property (nonatomic, copy) NSString *advPic;
//缩略图类型(1:正常 2:大图)
@property (nonatomic, copy) NSString *advPicType;
//
@property (nonatomic, strong) NSArray <NSString *>*pics;
//作者
@property (nonatomic, copy) NSString *auther;
//作者头像
@property (nonatomic, copy) NSString *autherPic;
//来源
@property (nonatomic, copy) NSString *source;
//内容
@property (nonatomic, copy) NSString *content;
//图文详情
@property (nonatomic, copy) NSString *desc;
//toCoin
@property (nonatomic, copy) NSString *toCoin;
//cellHeight
@property (nonatomic, assign) CGFloat cellHeight;

@end

