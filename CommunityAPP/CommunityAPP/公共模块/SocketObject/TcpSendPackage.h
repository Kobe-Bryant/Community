//
//  TcpSendPackage.h
//  ql
//
//  Created by yunlai on 14-5-3.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <Foundation/Foundation.h>

//发送的包的基类
@interface TcpSendPackage : NSObject

@property (nonatomic, retain) id head;

//发送的二进制数据
- (NSData *)data;

//发送的心跳包
+ (id)createXintiaoPackage;

//登录包
+ (id)createLoginPackage;

//注销包
+ (id)createLogoutPackage;

//消息包
//+ (id)createMessagePackageWith:(MessageData *)msgData;

@end
