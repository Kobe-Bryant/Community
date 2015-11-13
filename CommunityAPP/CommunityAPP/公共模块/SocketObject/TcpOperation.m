//
//  TcpOperation.m
//  ql
//
//  Created by yunlai on 14-5-3.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "TcpOperation.h"
#import "TcpRequestHelper.h"
#import "headParseClass.h"
#import "ChatCommon.h"

TcpOperation *TcpOperationSINGLE;

@implementation TcpOperation

+ (TcpOperation *)shareTcpOperation {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (TcpOperationSINGLE == nil) {
            TcpOperationSINGLE = [[TcpOperation alloc] init];
        }
    });
    
    return TcpOperationSINGLE;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _serialQueue = dispatch_queue_create("ss", NULL);
    }
    return self;
}

- (void)addAPackage:(TcpReadPackage *)package commandType:(int)type packageData:(NSData *)data{
    
    [self beginNewParser:type packageData:data];
}

- (void)beginNewParser:(int)type packageData:(NSData *)data{

    //------booky 5.8------//
    NSData* judgeData = [[NSData alloc]initWithBytes:data.bytes length:data.length];
    
    NSDictionary * dataHeadInfo = [headParseClass getPackageHeaderInfo:judgeData];
    int commandID = [[dataHeadInfo objectForKey:@"wCmd"]intValue];
        
    NSLog(@"请求命令字commandID=%@",[dataHeadInfo objectForKey:@"wCmd"]);
    
        switch (commandID) {
            case CMD_USER_LOGIN_ACK:
            {   //是登陆成功的包
                NSLog(@"++login++");
                 [[TcpRequestHelper shareTcpRequestHelperHelper] receiveLoginResponse:data];
            }
                break;
            case CMD_USER_HEARTBEAT_ACK:
            {   //心跳包
                [[TcpRequestHelper shareTcpRequestHelperHelper] receiveXintiaoPackage:data];
            }
                break;
            case CMD_USER_LOGOUT_ACK:
            {
                //退出登陆成功
                [[TcpRequestHelper shareTcpRequestHelperHelper] receiveLogoutResponse:data];
            }
                break;
            case CMD_PERSONAL_MSGSEND_ACK:
            {   // 发送个人消息 成功与否回馈
                [[TcpRequestHelper shareTcpRequestHelperHelper] receiveMessageSended:data];
            }
                break;
            case CMD_PERSONAL_MSGRECV:
            {
                //接收个人消息
                [[TcpRequestHelper shareTcpRequestHelperHelper] receiveChatMessage:data];
            }
                break;
                default:
                break;
        }
    
}

@end
