//
//  WarningLeaveMessageVC.h
//  bige
//
//  Created by 蔡卓越 on 2018/5/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

/**
 预警留言
 */
@interface WarningLeaveMessageVC : BaseViewController
//留言
@property (nonatomic, copy) NSString *message;
//id
@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) void(^leaveMessageBlock)();

@end
