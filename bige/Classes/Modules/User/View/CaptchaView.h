//
//  CaptchaView.h
//  bige
//
//  Created by 蔡卓越 on 2017/7/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTimeButton.h"
#import "TLTextField.h"

@interface CaptchaView : UIView

@property (nonatomic,strong) TLTextField *captchaTf;

@property (nonatomic,strong) TLTimeButton *captchaBtn;

@end
