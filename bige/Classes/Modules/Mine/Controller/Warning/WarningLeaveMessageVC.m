//
//  WarningLeaveMessageVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "WarningLeaveMessageVC.h"

//Category
#import "NSString+Check.h"
//V
#import "TLTextView.h"

@interface WarningLeaveMessageVC ()

@property (nonatomic, strong) TLTextView *leaveTV;

@end

@implementation WarningLeaveMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"预警留言";
    
    [self initSubviews];
}

#pragma mark - Init
- (void)initSubviews {
    
    //输入框
    self.leaveTV = [[TLTextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    
    self.leaveTV.placeholderLbl.origin = CGPointMake(15, 15);
    self.leaveTV.placeholderLbl.font = Font(14.0);
    self.leaveTV.textContainerInset = UIEdgeInsetsMake(17, 10, 0, 0);
    self.leaveTV.placholder = @"请填写您的预警留言";
    if ([self.message valid]) {
        
        self.leaveTV.text = self.message;
    }
    [self.view addSubview:self.leaveTV];
    //确定
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"确定"
                                          titleColor:kWhiteColor
                                     backgroundColor:kAppCustomMainColor
                                           titleFont:18.0
                                        cornerRadius:5];
    confirmBtn.frame = CGRectMake(15, self.leaveTV.yy + 35, kScreenWidth - 30, 45);
    [confirmBtn addTarget:self action:@selector(confirmLeave) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmBtn];
}

#pragma mark - Setting
- (void)setMessage:(NSString *)message {
    
    _message = message;
    
}

#pragma mark - Events
- (void)confirmLeave {
    
    if (![self.leaveTV.text valid]) {
        
        [TLAlert alertWithInfo:@"请填写您的预警留言"];
        return ;
    }
    
    [self.view endEditing:YES];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628392";
    http.showView = self.view;
    http.parameters[@"id"] = self.ID;
    http.parameters[@"warnContent"] = self.leaveTV.text;
    
    [http postWithSuccess:^(id responseObject) {
        
        if ([self.message valid]) {
            
            [TLAlert alertWithSucces:@"修改成功"];

        } else {
            
            [TLAlert alertWithSucces:@"留言成功"];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
        if (self.leaveMessageBlock) {
            
            self.leaveMessageBlock();
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
