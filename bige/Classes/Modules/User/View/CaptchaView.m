//
//  CaptchaView.m
//  bige
//
//  Created by 蔡卓越 on 2017/7/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "CaptchaView.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"

@implementation CaptchaView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUIWith:frame];
        
    }
    return self;
}

- (void)setUpUIWith:(CGRect)frame
{
    
    CGFloat btnWidth = 95;
    
    self.captchaTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - btnWidth, frame.size.height)
                                              leftTitle:@""
                                             titleWidth:100
                                            placeholder:@"请输入验证码"];
    self.captchaTf.rightViewMode = UITextFieldViewModeAlways;
    self.captchaTf.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:self.captchaTf];

    //获得验证码按钮
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(self.captchaTf.xx, 0, btnWidth, frame.size.height)];
    
    rightView.backgroundColor = kWhiteColor;
    
    [self addSubview:rightView];

    TLTimeButton *captchaBtn = [[TLTimeButton alloc] initWithFrame:CGRectMake(0, 0, 95, frame.size.height - 15) totalTime:60.0];
    captchaBtn.titleLabel.font = Font(15);
    captchaBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    captchaBtn.layer.borderWidth = 1.0;
    captchaBtn.layer.cornerRadius = 5;
    captchaBtn.clipsToBounds = YES;
    captchaBtn.backgroundColor = kClearColor;
    captchaBtn.centerY = rightView.height/2.0;
    [rightView addSubview:captchaBtn];
    
    self.captchaBtn = captchaBtn;

    //    //2.1 添加分割线
    //    UIView *sLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 20)];
    //    sLine.centerY = captchaBtn.centerY;
    //    sLine.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    //    [captchaBtn addSubview:sLine];
    
}

@end
