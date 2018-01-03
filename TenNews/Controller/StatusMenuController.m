//
//  StatusMenuController.m
//  TenNews
//
//  Created by 崔旺 on 2017/12/25.
//  Copyright © 2017年 崔旺. All rights reserved.
//

#import "StatusMenuController.h"
#import <AppKit/AppKit.h>
#import "NewsPopViewController.h"
#import "MyEGOCache.h"

@interface StatusMenuController ()<NSPopoverDelegate> {
      NSInteger appStatus;
}
//系统状态栏
@property(nonatomic , strong)NSStatusItem *statusItem ;
@property(nonatomic , strong)NSMenuItem *siteIMenuItem ;
//弹窗类型
@property(nonatomic , strong)NSPopover *mPopover;
//
@end

@implementation StatusMenuController

- (void)awakeFromNib {
      //获取系统状态栏
      _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
      NSImage *iconImage = [NSImage imageNamed:@"icon"];
      [_statusItem.button setImage:iconImage];
      //添加菜单点击事件
      _statusItem.target = self;
      _statusItem.button.action = @selector(showMyPopover:);
      
//     _siteIMenuItem = [_statusMenu itemWithTitle:@"Quit"];
//      _siteIMenuItem.view = _siteNewsTableView;
//      [_siteNewsTableView initData];
      
      //创建popover
      _mPopover = [[NSPopover alloc]init];
      _mPopover.delegate = self;
      _mPopover.behavior = NSPopoverBehaviorTransient;
      _mPopover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
      
      _mPopover.contentViewController = [[NewsPopViewController alloc]initWithNibName:@"NewsPopViewController" bundle:nil];
      
//      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appStatusChange:) name:@"NSApplicationDidResignActiveNotification" object:nil];
      
      
      [NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskLeftMouseUp handler:^(NSEvent * event) {
            if (_mPopover.isShown) {
                  NSString *fixCache = [MyEGOCache getCacheStringForKey:@"FIX_WINDOW"];
                  if (fixCache.length > 0 && [fixCache isEqualToString:@"FIX"]) {
                        NSLog(@"fixed windows");
                  }else {
                        [_mPopover close];
                  }
            }
      }];
      
}

- (BOOL)popoverShouldClose:(NSPopover *)popover {
      NSString *fixCache = [MyEGOCache getCacheStringForKey:@"FIX_WINDOW"];
      if (fixCache.length > 0 && [fixCache isEqualToString:@"FIX"]) {
            return NO;
      }else {
            return YES;
      }
}

- (void)showMyPopover:(NSStatusBarButton *)button {
      [_mPopover showRelativeToRect:button.bounds ofView:button preferredEdge:NSRectEdgeMaxY];
}



@end
