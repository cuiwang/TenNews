//
//  MyEGOCache.m
//  TenNews
//
//  Created by 崔旺 on 2018/1/2.
//  Copyright © 2018年 崔旺. All rights reserved.
//

#import "MyEGOCache.h"
#import "EGOCache.h"

@implementation MyEGOCache

static MyEGOCache* _instance = nil;

+(instancetype) shareInstance
{
      static dispatch_once_t onceToken ;
      dispatch_once(&onceToken, ^{
            _instance = [[super allocWithZone:NULL] init] ;
      }) ;
      return _instance ;
}

+(id) allocWithZone:(struct _NSZone *)zone
{
      return [MyEGOCache shareInstance] ;
}

-(id) copyWithZone:(NSZone *)zone
{
      return [MyEGOCache shareInstance] ;//return _instance;
}

-(id) mutablecopyWithZone:(NSZone *)zone
{
      return [MyEGOCache shareInstance] ;
}


/**
 *  创建缓存目录
 *
 *  @return 缓存目录
 */
+(NSString *)createCacheDirection
{
      //沙盒目录
      //NSLog(@"-----%@",NSHomeDirectory());
      //Document 文件夹目录
      NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
      NSString *pathDocuments = [paths objectAtIndex:0];
      //创建缓存目录
      NSString *createPath = [NSString stringWithFormat:@"%@/TenNewsCache", pathDocuments];
      NSLog(@"createPath-----%@",createPath);
      // 判断文件夹是否存在，如果不存在，则创建
      if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
            NSFileManager *fileManager = [[NSFileManager alloc] init];
            BOOL result = [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
            if (result) {
                  return createPath;
            }else
            {
                  return nil;
            }
      } else {
           // NSLog(@"FileDir is exists.");
            return createPath;
      }
}


+ (void)initCachePath:(NSString *)cacheDirectory {
      //initWithCacheDirectory 指定缓存目录
    [[EGOCache globalCache] initWithCacheDirectory:cacheDirectory];
}

+ (void)clearCache {
      [[EGOCache globalCache] clearCache];
}

+ (void)cacheString:(NSString *)cacheStr ForKey:(NSString *)keyStr {
      [[EGOCache globalCache] setString:cacheStr forKey:keyStr];
}

+ (NSString *)getCacheStringForKey:(NSString *)keyStr {
      BOOL ishaveCacheFile = [[EGOCache globalCache] hasCacheForKey:keyStr];
      if (ishaveCacheFile) {
            return  [[EGOCache globalCache] stringForKey:keyStr];
      }else{
            return  @"";
      }
}

+ (Boolean)hasCacheForkey:(NSString *)keyStr {
      return [[EGOCache globalCache] hasCacheForKey:keyStr];
}

+ (void)removeCacheForKey:(NSString *)keyStr {
      [[EGOCache globalCache] removeCacheForKey:keyStr];
}


@end
