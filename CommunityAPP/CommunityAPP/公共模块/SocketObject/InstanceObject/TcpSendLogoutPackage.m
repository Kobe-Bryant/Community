//
//  TcpSendLogoutPackage.m
//  ql
//
//  Created by yunlai on 14-5-5.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "TcpSendLogoutPackage.h"
#import "headParseClass.h"
#import "ChatCommon.h"

@implementation TcpSendLogoutPackage

-(NSData*) data{
    NSMutableData *allData = [[NSMutableData alloc]init];
    
    //转换包体成二进制

    NSData *bodyData = [[headParseClass TransformJson:nil
                                       withLinkclient:[NSNumber numberWithInt:[[ChatCommon sharedGlobal].userModel.userId intValue]] clienttype:@"srcuid"
                                              msgList:nil
                                                orgId:nil
                                               orgKey:nil]
                        dataUsingEncoding:NSUTF8StringEncoding];
    //获取包体长度
    
    NSUInteger lengh = bodyData.length;
    
    [allData appendData:[headParseClass sendIMPortPackaging:lengh wCmd:0x0002 srcUid:[[ChatCommon sharedGlobal].userModel.userId intValue] destUid:10000]];
    [allData appendData:bodyData];
    
    return allData;
}

@end
