//
//  CurrencyKLineHScreenVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CurrencyKLineHScreenVC.h"
//Manager
#import "AppConfig.h"
//Category
#import "UILabel+Extension.h"
//V
#import "DetailWebView.h"

@interface CurrencyKLineHScreenVC ()
//k线横屏
@property (nonatomic, strong) DetailWebView *kLineView;

@end

@implementation CurrencyKLineHScreenVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kBlackColor;
    //
    [self initSubviews];
}

#pragma mark - Init
- (DetailWebView *)kLineView {
    
    if (!_kLineView) {
        
        BaseWeakSelf;
        
        CGFloat w = kScreenHeight;
        CGFloat h = kScreenWidth;
        
        _kLineView = [[DetailWebView alloc] initWithFrame:CGRectMake(0,0, w, h)];
//        _kLineView.center = CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0);
        
//        _kLineView.transform = CGAffineTransformMakeRotation(M_PI_2);
        [self.view addSubview:_kLineView];
    }
    return _kLineView;
}

- (void)initSubviews {
    
    //返回
    UIButton *backBtn = [UIButton buttonWithImageName:@""];
    
    [backBtn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.kLineView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@10);
        make.right.equalTo(@(-(kHeight(40)+10)));
        make.width.equalTo(@(kHeight(40)));
        make.height.equalTo(@(kHeight(40)));
    }];
}

#pragma mark - Setting
- (void)setPlatform:(PlatformModel *)platform {
    
    _platform = platform;
    
    //k线图
    //交易对
    NSString *symbol = [NSString stringWithFormat:@"%@/%@", platform.symbol, platform.toSymbol];
    NSString *html = [NSString stringWithFormat:@"%@/index.html?symbol=%@&exchange=%@&isfull=1",@"http://47.52.236.63:2303", symbol, platform.exchangeEname];
    
    [self.kLineView loadRequestWithString:html];
    //
    [self rightAction];
}

#pragma mark - Events
- (void)clickBack {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [self leftAction];
}

#pragma mark - 横屏
- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)leftAction
{
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
}

- (void)rightAction
{
    [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
