//
//  DetailWebView.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/17.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <WebKit/WebKit.h>

typedef void(^WebviewBlock)(CGFloat height);

@interface DetailWebView : UIView

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, copy) WebviewBlock webViewBlock;
//富文本
- (void)loadWebWithString:(NSString *)string;
//加载网页
- (void)loadRequestWithString:(NSString *)string;

@end
