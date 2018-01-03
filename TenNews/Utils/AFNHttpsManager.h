//
//  AFNHttpsManager.h
//  TenNews
//
//  Created by 崔旺 on 2017/12/25.
//  Copyright © 2017年 崔旺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface AFNHttpsManager : NSObject
#define kTimeOutInterval 30 // 请求超时的时间
typedef void (^SuccessBlock)(NSDictionary *dict, BOOL success); // 访问成功block
typedef void (^AFNErrorBlock)(NSError *error); // 访问失败block


+ (AFHTTPSessionManager *)manager;
@end
