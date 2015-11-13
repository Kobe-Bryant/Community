//
//  TcpSendPackage.m
//  ql
//
//  Created by yunlai on 14-5-3.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "TcpSendPackage.h"
#import "headParseClass.h"
#import "TcpSendLoginPackage.h"
#import "TcpSendXintiaoPackage.h"
#import "TcpSendTextMessagePackage.h"
#import "TcpSendLogoutPackage.h"
#import "SBJson.h"

@implementation TcpSendPackage

// 创建心跳包对象
+ (id)createXintiaoPackage {
    
    TcpSendXintiaoPackage *xintiaoBao = [[TcpSendXintiaoPackage alloc]init];
    
    return xintiaoBao;
}

// 创建登录对象
+ (id)createLoginPackage{
    
    TcpSendLoginPackage *loginBao = [[TcpSendLoginPackage alloc]init];
    
    return loginBao;
}

// 创建注销包对象
+(id) createLogoutPackage{
    TcpSendLogoutPackage* logouyBao = [[TcpSendLogoutPackage alloc] init];
    return logouyBao;
}
// 创建消息对象
//+ (id)createMessagePackageWith:(MessageData *)msgData
//{
//    TcpSendTextMessagePackage *textMessage = [[TcpSendTextMessagePackage alloc]init];
//    textMessage.messageData = msgData;
//    return textMessage;
//}

//发送包的二进制数据
- (NSData *)data{
    return nil;
}

@end
