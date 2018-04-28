//
//  SetWarningView.h
//  bige
//
//  Created by 蔡卓越 on 2018/4/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"
//M
#import "PlatformModel.h"
/**
 设置预警
 */
@interface SetWarningView : BaseView
//
@property (nonatomic, strong) PlatformModel *platform;
//显示
- (void)show;
//隐藏
- (void)hide;

@end
