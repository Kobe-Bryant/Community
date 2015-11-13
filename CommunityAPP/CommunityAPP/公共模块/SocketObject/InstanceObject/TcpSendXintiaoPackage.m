//
//  TcpSendXintiaoPackage.m
//  ql
//
//  Created by yunlai on 14-5-4.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "TcpSendXintiaoPackage.h"
#import "headParseClass.h"
#import "ChatCommon.h"

@implementation TcpSendXintiaoPackage

- (NSData *)data{
    
    NSMutableData *allData = [[NSMutableData alloc]init];
    
    [allData appendData:[headParseClass sendIMPortPackaging:0 wCmd:CMD_USER_HEARTBEAT srcUid:[[ChatCommon sharedGlobal].userModel.userId  intValue] destUid:10000]];

    return allData;
}

@end
