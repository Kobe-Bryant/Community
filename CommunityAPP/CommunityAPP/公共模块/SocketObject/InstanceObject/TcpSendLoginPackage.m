//
//  TcpSendLoginPackage.m
//  ql
//
//  Created by yunlai on 14-5-4.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "TcpSendLoginPackage.h"
#import "headParseClass.h"
//#import "login_info_model.h"
#import "SBJson.h"
#import "ChatCommon.h"

@implementation TcpSendLoginPackage

// 封装登录请求包，包头+包体,转二进制
- (NSData *)data{
    
    NSMutableData *allData = [[NSMutableData alloc]init];
//    NSMutableArray *_loginArray = [self getLatestCircleMessageArr];
//    NSMutableArray* _loginArray = [self getLastestCircleHisMsgArr];
    //转换包体成二进制
    int orgId = [[ChatCommon sharedGlobal].userModel.userId intValue];
    
    NSDictionary * sendDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:2],@"clienttype",
                              0,@"oldmsglist",
                              [NSNumber numberWithInt:orgId],@"organizationid",nil];
    
    NSString * bodyJson = [sendDic JSONRepresentation];
    
    NSData *bodyData = [bodyJson dataUsingEncoding:NSUTF8StringEncoding];
    
    //获取包体长度
    NSUInteger lengh = bodyData.length;
    
    [allData appendData:[headParseClass sendIMPortPackaging:lengh wCmd:CMD_USER_LOGIN srcUid:[[ChatCommon sharedGlobal].userModel.userId intValue] destUid:10000]];
    [allData appendData:bodyData];
    
    return allData;
}

@end
