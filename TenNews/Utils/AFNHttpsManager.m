//
//  AFNHttpsManager.m
//  TenNews
//
//  Created by 崔旺 on 2017/12/25.
//  Copyright © 2017年 崔旺. All rights reserved.
//

#import "AFNHttpsManager.h"
#import "AFNetworking.h"

@implementation AFNHttpsManager

#pragma mark - 创建请求者
+(AFHTTPSessionManager *)manager
{
      AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
      // 超时时间
      manager.requestSerializer.timeoutInterval = kTimeOutInterval;
      
      // 声明上传的是json格式的参数，需要你和后台约定好，不然会出现后台无法获取到你上传的参数问题
      manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
//          manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
      
      // 声明获取到的数据格式
      manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
//          manager.responseSerializer = [AFJSONResponseSerializer serializer]; // AFN会JSON解析返回的数据
      // 个人建议还是自己解析的比较好，有时接口返回的数据不合格会报3840错误，大致是AFN无法解析返回来的数据
      return manager;
}



@end
