//
//  AppDelegate.m
//  TenNews
//
//  Created by 崔旺 on 2017/12/25.
//  Copyright © 2017年 崔旺. All rights reserved.
//

#import "AppDelegate.h"
#import "MyEGOCache.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
      [MyEGOCache initCachePath:[MyEGOCache  createCacheDirection]];
}



- (void)applicationWillTerminate:(NSNotification *)aNotification {
      // Insert code here to tear down your application
}


@end
