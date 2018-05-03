//
//  MineHeaderView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MineHeaderType) {
    MineHeaderTypeDefault = 0,   //设置
    MineHeaderTypeLogin,         //登录
    MineHeaderTypeIntegralCenter,//积分中心
    MineHeaderTypeCollection,    //收藏
    MineHeaderTypePhoto,         //头像
};

@protocol MineHeaderDelegate <NSObject>

- (void)didSelectedWithType:(MineHeaderType)type idx:(NSInteger)idx;

@end

@interface MineHeaderView : UIView
//头像
@property (nonatomic, strong) UIImageView *userPhoto;
//昵称
@property (nonatomic, strong) UIButton *nameBtn;

@property (nonatomic, weak) id<MineHeaderDelegate> delegate;


@end
