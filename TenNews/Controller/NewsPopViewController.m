//
//  NewsPopViewController.m
//  TenNews
//
//  Created by 崔旺 on 2017/12/28.
//  Copyright © 2017年 崔旺. All rights reserved.
//

#import "NewsPopViewController.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "AFNHttpsManager.h"
#import "M_SiteDetail.h"
#import "M_SiteList.h"
#import "SiteDetailCellView.h"
#import "SiteCollectionViewItem.h"
#import "Colours.h"
#import "HoverTableRowView.h"
#import "MyEGOCache.h"

#define LASTSITEID @"LAST_SITE_ID"
#define LASTSITEINDEX @"LAST_SITE_INDEX"

@interface NewsPopViewController ()<NSTableViewDelegate,NSTableViewDataSource,NSCollectionViewDataSource,NSCollectionViewDelegate> {
      NSMutableArray *rightTableDatasArray;
      NSMutableArray *leftTableDatasArray;
}
@property (weak) IBOutlet NSTableView *contentTableView;
@property (weak) IBOutlet NSCollectionView *siteCollectionView;
@property (weak) IBOutlet NSScrollView *siteScrollCollectionView;
@property (weak) IBOutlet NSScrollView *contentScrollTableView;
@property (weak) IBOutlet NSView *loadingView;
@property (weak) IBOutlet NSProgressIndicator *loadingProgressIndicator;
@property (weak) IBOutlet NSTextField *loadingTextField;
@property (weak) IBOutlet NSButton *fixButton;

@end

@implementation NewsPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      [self initView];
      [self initData];
}

- (void)initView {
      //注册tableview cellview
      [self.contentTableView registerNib:[[NSNib alloc] initWithNibNamed:@"SiteDetailCellView" bundle:nil] forIdentifier:@"SiteDetailCellView"];
      //设置collectionview item属性
      NSCollectionViewFlowLayout *conllectionViewFlowLayout = _siteCollectionView.collectionViewLayout;
      conllectionViewFlowLayout.itemSize = NSMakeSize(50.0, 50.0);
      conllectionViewFlowLayout.sectionInset = NSEdgeInsetsMake(0, 0, 0, 0);
      //修改collectionview 背景言责
      [_siteCollectionView setBackgroundColors:@[[NSColor colorFromHexString:@"#eeeeee"]]];
      //隐藏collectionview滚动条
      [[self.siteScrollCollectionView verticalScroller] setAlphaValue:0];
      //窗口是否固定
      NSString* fixCache =  [MyEGOCache getCacheStringForKey:@"FIX_WINDOW"];
      if (fixCache.length > 0 && [fixCache isEqualToString:@"FIX"]) {
            [self.fixButton setImage:[NSImage imageNamed:@"fix"]];
      }else {
            [self.fixButton setImage:[NSImage imageNamed:@"fix_gray"]];
      }
}

- (void)initData {
      rightTableDatasArray = [NSMutableArray array];
      leftTableDatasArray = [NSMutableArray array];
      //最后一次点击的站点
      NSString * lastSiteId = [MyEGOCache getCacheStringForKey:LASTSITEID];
      if (lastSiteId.length > 0) {
            //加载最后一次点击的站点10条数据
            [self getSiteDetailWithId:lastSiteId];
      }else{
            //默认加载1号站点的10条数据
            [self getSiteDetailWithId:@"1"];
      }
      //获取站点列表
      [self getSiteListWithSize:@"30"];
      //检测更新
      [self checkUpdateWithVersion:@"1.0.0"];
}



#pragma mark - LoadingView

- (void)showLoadingView {
      [self.loadingView setHidden:NO];
      self.loadingTextField.stringValue = @"Loading...";
      [self.loadingProgressIndicator startAnimation:nil];
      [self.contentTableView setHidden:YES];
}

- (void)hideLoadingView {
      [self.loadingView setHidden:YES];
      [self.loadingProgressIndicator stopAnimation:nil];
      [self.contentTableView setHidden:NO];
}

- (void)showNoDataView {
      [self.loadingView setHidden:NO];
      [self.loadingProgressIndicator setHidden:YES];
      self.loadingTextField.stringValue = @"Sorry,No Data.";
      [self.contentTableView setHidden:YES];
}

#pragma mark - 网络数据

- (void)checkUpdateWithVersion:(NSString *) version {
      // 创建请求类
      AFHTTPSessionManager *manager = [AFNHttpsManager manager];
      [manager GET:[NSString stringWithFormat:@"https://youdongtai.com/checkUpdate/%@",version] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            // 这里可以获取到目前数据请求的进度
      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 请求成功
            if(responseObject){
                  NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                  NSString *updateInfo = [dict objectForKey:@"data"];
                 
                  if ([updateInfo isEqualToString:@"最新版本!"] ) {
                        NSLog(@"%@",updateInfo);
                  }else{
                        NSAlert *alert = [NSAlert new];
                        [alert addButtonWithTitle:@"确定"];
                        [alert addButtonWithTitle:@"取消"];
                        [alert setMessageText:@"发现新版本,是否更新?"];
                        [alert setInformativeText:updateInfo];
                        [alert setAlertStyle:NSAlertStyleWarning];
                        long reCode = [alert runModal];
                        if (reCode == NSAlertFirstButtonReturn) {
                              NSLog(@"确定");
                              NSString *url = [dict objectForKey:@"url"];
                              [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:url]];
                        } else if(reCode == NSAlertSecondButtonReturn) {
                           NSLog(@"取消");
                        }
                  }
                 
            } else {
                  NSLog(@"暂无数据");
            }
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 请求失败
            NSLog(@"%@",error);
      }];
}

- (void)getSiteListWithSize:(NSString *) size {
      // 创建请求类
      AFHTTPSessionManager *manager = [AFNHttpsManager manager];
      [manager GET:[NSString stringWithFormat:@"https://youdongtai.com/siteList/%@",size] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            // 这里可以获取到目前数据请求的进度
      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 请求成功
            if(responseObject){
                  NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                  NSArray *userArray = [M_SiteList mj_objectArrayWithKeyValuesArray:[dict objectForKey:@"data"]];
                  [leftTableDatasArray addObjectsFromArray:userArray];
                  [_siteCollectionView reloadData];
            } else {
                  NSLog(@"暂无数据");
            }
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 请求失败
            NSLog(@"%@",error);
      }];
}

- (void)getSiteDetailWithId:(NSString *) index {
      //显示加载中
      [self showLoadingView];
      // 创建请求类
      AFHTTPSessionManager *manager = [AFNHttpsManager manager];
      [manager GET:[NSString stringWithFormat:@"https://youdongtai.com/siteDetail/%@",index] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            // 这里可以获取到目前数据请求的进度
      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 请求成功
            if(responseObject){
                  NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                  
                  NSArray *userArray = [M_SiteDetail mj_objectArrayWithKeyValuesArray:[dict objectForKey:@"data"]];
                  [rightTableDatasArray removeAllObjects];
                  [rightTableDatasArray addObjectsFromArray:userArray];
                  [_contentTableView reloadData];
                  if (rightTableDatasArray.count > 0) {
                        //隐藏加载中
                        [self hideLoadingView];
                  }else {
                        [self showNoDataView];
                        NSLog(@"暂无数据");
                  }
                  
            } else {
                  [self showNoDataView];
                  NSLog(@"暂无数据");
            }
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 请求失败
            NSLog(@"%@",error);
      }];
}


#pragma mark  - collectionview

//collectionview 点击
- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths NS_AVAILABLE_MAC(10_11) {
      
      NSArray *indexs = [indexPaths allObjects];
      if(indexs.count > 0) {
           NSIndexPath * indexPath = [indexs objectAtIndex:0];
            M_SiteList * data = [leftTableDatasArray objectAtIndex:indexPath.item];
            NSString * lastSiteIndex = [MyEGOCache getCacheStringForKey:LASTSITEINDEX];
            NSInteger index = [lastSiteIndex integerValue];
            if(index>=0 && index<leftTableDatasArray.count) {
                  SiteCollectionViewItem *viewItem = (SiteCollectionViewItem *)[collectionView itemAtIndex:index];
                  viewItem.bgBox.fillColor = [NSColor colorFromHexString:@"eeeeee"];
            }
            [MyEGOCache cacheString:data.ID ForKey:LASTSITEID];
            [MyEGOCache cacheString:[@(indexPath.item) stringValue] ForKey:LASTSITEINDEX];
            [self getSiteDetailWithId:data.ID];
      }
     
      
}

//rows
- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section NS_AVAILABLE_MAC(10_11) {
      return leftTableDatasArray.count;
}

//collectionview items
- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_MAC(10_11) {
      //
      
      SiteCollectionViewItem *view = [collectionView makeItemWithIdentifier:@"SiteCollectionViewItem" forIndexPath:indexPath];
      //获取数据
      M_SiteList * data = [leftTableDatasArray objectAtIndex:indexPath.item];
      
      //设置鼠标放入提示
      [view.view setToolTip:[NSString stringWithFormat:@"%@-%@",data.site,data.name]];
      [view.imageView setToolTip:[NSString stringWithFormat:@"%@-%@",data.site,data.name]];
      
      //设置点击样式
      NSString * lastSiteId = [MyEGOCache getCacheStringForKey:LASTSITEID];
      if([lastSiteId isEqualToString:data.ID]) {
            view.bgBox.fillColor = [NSColor colorFromHexString:@"cccccc"];
            [MyEGOCache cacheString:[@(indexPath.item) stringValue] ForKey:LASTSITEINDEX];
            [collectionView selectItemsAtIndexPaths:[NSSet setWithObject:indexPath] scrollPosition:NSCollectionViewScrollPositionCenteredVertically];

      }else{
            view.bgBox.fillColor = [NSColor colorFromHexString:@"eeeeee"];
      }
      
      //设置数据
      view.titleTextField.stringValue = data.name;
       [view.imageView downloadImageFromURL: data.icon withPlaceholderImage:[NSImage imageNamed:@"icon"] errorImage:[NSImage imageNamed:@"icon"] andDisplaySpinningWheel:YES];
      
      return view;
}

#pragma mark - tableview
//rows
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
      return rightTableDatasArray.count;
}

//tableview item
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
     
            SiteDetailCellView * view = [tableView makeViewWithIdentifier:@"SiteDetailCellView" owner:self];

      //获取数据
            M_SiteDetail * data = [rightTableDatasArray objectAtIndex:row];
      
      //设置点击样式
      NSString * lastSiteId = [MyEGOCache getCacheStringForKey:LASTSITEID];
      NSString * theKey = [NSString stringWithFormat:@"%@-%@",lastSiteId,data.ID];
      Boolean hasCachekey = [MyEGOCache hasCacheForkey:theKey];
      if (hasCachekey) {
            [view.titleTextField setTextColor:[NSColor colorFromHexString:@"#999999"]];
      }else{
            [view.titleTextField setTextColor:[NSColor colorFromHexString:@"#333333"]];
      }
      

      //设置数据
            view.titleTextField.stringValue = data.title;
            view.subTitleTextField.stringValue = data.subtitle;

            return view;
      
}


//tableview 点击
- (void)tableViewSelectionDidChange:(NSNotification *)notification {
      [self.contentTableView enumerateAvailableRowViewsUsingBlock:^(NSTableRowView *rowView, NSInteger row) {
            for (NSInteger column = 0; column < rowView.numberOfColumns; column++) {
                  NSView *cellView = [rowView viewAtColumn:column];
                  if ([cellView isKindOfClass:[SiteDetailCellView class]]) {
                        SiteDetailCellView *tableCellView = (SiteDetailCellView *)cellView;
                        NSTextField *textField = tableCellView.titleTextField;
                        if (rowView.selected) {
                              //修改点击后的样式
                              [textField setTextColor:[NSColor colorFromHexString:@"#999999"]];
                              //存储位置
                              M_SiteDetail * data = [rightTableDatasArray objectAtIndex:row];
                              [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:data.url]];
                              NSString * lastSiteId = [MyEGOCache getCacheStringForKey:LASTSITEID];
                              NSString * theKey = [NSString stringWithFormat:@"%@-%@",lastSiteId,data.ID];
                              [MyEGOCache cacheString:theKey ForKey:theKey];
                        }
                  }
            }
      }];
}

#pragma mark 刷新应用

- (IBAction)refreshClick:(NSButton *)sender {
      //最后一次点击的站点
      NSString * lastSiteId = [MyEGOCache getCacheStringForKey:LASTSITEID];
      if (lastSiteId.length > 0) {
            //加载最后一次点击的站点10条数据
            [self getSiteDetailWithId:lastSiteId];
      }else{
            //默认加载1号站点的10条数据
            [self getSiteDetailWithId:@"1"];
      }
}

#pragma mark 固定应用

- (IBAction)fixClick:(NSButton *)sender {
      
    NSString* fixCache =  [MyEGOCache getCacheStringForKey:@"FIX_WINDOW"];
      if (fixCache.length > 0 && [fixCache isEqualToString:@"FIX"]) {
            [MyEGOCache removeCacheForKey:@"FIX_WINDOW"];
            [sender setImage:[NSImage imageNamed:@"fix_gray"]];
      }else {
            [MyEGOCache cacheString:@"FIX" ForKey:@"FIX_WINDOW"];
            [sender setImage:[NSImage imageNamed:@"fix"]];
      }
      
}

#pragma mark 退出应用

- (IBAction)exitClick:(NSMenuItem *)sender {
      [[NSApplication sharedApplication] terminate:self ];
}


@end
