//
//  MineHeaderView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MineHeaderSeletedType) {
    MineHeaderSeletedTypeDefault = 0,   //设置
    MineHeaderSeletedTypeLogin,         //登录
};

@protocol MineHeaderSeletedDelegate <NSObject>

- (void)didSelectedWithType:(MineHeaderSeletedType)type idx:(NSInteger)idx;

@end

@interface MineHeaderView : UIView
//头像
@property (nonatomic, strong) UIImageView *userPhoto;
//昵称
@property (nonatomic, strong) UIButton *nameBtn;

@property (nonatomic, weak) id<MineHeaderSeletedDelegate> delegate;


@end
