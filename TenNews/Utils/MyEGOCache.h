//
//  MyEGOCache.h
//  TenNews
//
//  Created by 崔旺 on 2018/1/2.
//  Copyright © 2018年 崔旺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGOCache.h"

@interface MyEGOCache : NSObject
+(instancetype) shareInstance ;
+(NSString *)createCacheDirection;
+ (void)initCachePath:(NSString *)cacheDirectory;
+ (void)clearCache;
+ (void)cacheString:(NSString *)cacheStr ForKey:(NSString *)keyStr;
+ (NSString *)getCacheStringForKey:(NSString *)keyStr;
+ (Boolean)hasCacheForkey:(NSString *)keyStr;
+ (void)removeCacheForKey:(NSString *)keyStr;
@end
