//
//  InfoListVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "InfoListVC.h"
//Manager
#import "TLWXManager.h"
#import "QQManager.h"
//Extension
#import <TFHpple.h>
//M
#import "InformationModel.h"
#import "InfoManager.h"
//V
#import "InformationListTableView.h"
#import "TLPlaceholderView.h"
#import "InfoDetailShareView.h"
//C
#import "InfoDetailVC.h"

@interface InfoListVC ()<RefreshDelegate>
//资讯
@property (nonatomic, strong) InformationListTableView *infoTableView;
//infoList
@property (nonatomic, strong) NSArray <InformationModel *>*infos;
//
@property (nonatomic, strong) TLPageDataHelper *flashHelper;
//分享
@property (nonatomic, strong) InfoDetailShareView *shareView;
//分享链接
@property (nonatomic, copy) NSString *shareUrl;
//
@property (nonatomic, strong) InformationModel *shareModel;

@end

@implementation InfoListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加通知
//    [self addNotification];
    //资讯
    [self initInfoTableView];
    //获取资讯列表
    [self requestInfoList];
    //刷新
    [self.infoTableView beginRefreshing];
}

#pragma mark - Init
- (InfoDetailShareView *)shareView {
    
    if (!_shareView) {
        
        BaseWeakSelf;
        
        _shareView = [[InfoDetailShareView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        _shareView.shareBlock = ^(ThirdType type) {
            
            [weakSelf shareEventsWithType:type];
        };
    }
    return _shareView;
}

- (void)initInfoTableView {
    
    self.infoTableView = [[InformationListTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.infoTableView.refreshDelegate = self;
    self.infoTableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无记录" text:@"暂无新闻"];
    
    [self.view addSubview:self.infoTableView];
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - 分享
- (void)shareEventsWithType:(ThirdType)type {
    
    NSString *previewImage;
    
    if (self.shareModel.pics.count > 0) {
        
        previewImage = [self.shareModel.pics[0] convertImageUrl];
    }
    
    NSString *desc = [self substringFromArticleContent:self.shareModel.content];
    
    switch (type) {
        case ThirdTypeWeChat:
        {
            [TLWXManager wxShareWebPageWithScene:WXSceneSession
                                           title:self.shareModel.title
                                            desc:desc
                                             url:self.shareUrl];
            [TLWXManager manager].wxShare = ^(BOOL isSuccess, int errorCode) {
                
                if (isSuccess) {
                    
                    [TLAlert alertWithSucces:@"分享成功"];
                } else {
                    
                    [TLAlert alertWithError:@"分享失败"];
                }
            };
            
        }break;
            
        case ThirdTypeTimeLine:
        {
            [TLWXManager wxShareWebPageWithScene:WXSceneTimeline
                                           title:self.shareModel.title
                                            desc:desc
                                             url:self.shareUrl];
            [TLWXManager manager].wxShare = ^(BOOL isSuccess, int errorCode) {
                
                if (isSuccess) {
                    
                    [TLAlert alertWithSucces:@"分享成功"];
                } else {
                    
                    [TLAlert alertWithError:@"分享失败"];
                }
            };
            
        }break;
            
        case ThirdTypeQQ:
        {
            [QQManager manager].qqShare = ^(BOOL isSuccess, int errorCode) {
                
                if (isSuccess) {
                    
                    [TLAlert alertWithSucces:@"分享成功"];
                }else {
                    
                    [TLAlert alertWithError:@"分享失败"];
                }
            };
            
            [QQManager qqShareWebPageWithScene:0
                                         title:self.shareModel.title
                                          desc:desc
                                           url:self.shareUrl
                                  previewImage:previewImage];
            
        }break;
            
        case ThirdTypeWeiBo:
        {
            
        }break;
            
        default:
            break;
    }
}

/**
 截取文章内容
 @param content 文章内容
 @return 截取后的内容
 */
- (NSString *)substringFromArticleContent:(NSString *)content {
    
    //截取富文本的内容
    NSData *htmlData = [self.shareModel.content dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    NSArray *classArr = [hpple searchWithXPathQuery:@"//div"];
    
    NSMutableString *string = [NSMutableString string];
    
    for (TFHppleElement *element in classArr) {
        
        if (element.content) {
            
            [string add:element.content];
        }
    }
    //文章描述
    //    NSString *desc = [string substringToIndex:50];
    
    return @"";
}

#pragma mark - Data

- (void)requestInfoList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628205";
    
    helper.tableView = self.infoTableView;
    
    [helper modelClass:[InformationModel class]];
    
    [self.infoTableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.infos = objs;
            
            weakSelf.infoTableView.infos = objs;
            
            [weakSelf.infoTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.infoTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.infos = objs;
            
            weakSelf.infoTableView.infos = objs;
            
            [weakSelf.infoTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.infoTableView endRefreshingWithNoMoreData_tl];
}

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseWeakSelf;
    
    InfoDetailVC *detailVC = [InfoDetailVC new];
    
    detailVC.code = self.infos[indexPath.row].code;
//    detailVC.title = self.titleStr;
    detailVC.collectionBlock = ^{
        
        [weakSelf.infoTableView beginRefreshing];
    };
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)refreshTableViewEventClick:(TLTableView *)refreshTableview selectRowAtIndex:(NSInteger)index {
    
    InformationModel *info = self.infos[index];
    
    self.shareModel = info;
    
    [self.shareView show];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
