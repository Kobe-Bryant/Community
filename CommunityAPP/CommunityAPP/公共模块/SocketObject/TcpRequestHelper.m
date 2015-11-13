//
//  TcpRequestHelper.m
//  ql
//
//  Created by yunlai on 14-5-4.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//


#import "TcpRequestHelper.h"
#import "headParseClass.h"
#import "JSONKit.h"
#import "NSObject+SBJson.h"
#import "ChatTcpHelper.h"
#import "ChatCommon.h"
#import "Global.h"

static int  heartBeatInterval = 30;

TcpRequestHelper *TcpRequestHelperSINGLE;

@interface TcpRequestHelper ()
{
    
}

@end

@implementation TcpRequestHelper

+ (TcpRequestHelper *)shareTcpRequestHelperHelper {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (TcpRequestHelperSINGLE==nil) {
            TcpRequestHelperSINGLE = [[TcpRequestHelper alloc] init];
        }
    });
    
    return TcpRequestHelperSINGLE;
}

- (void)receiveXintiaoPackage:(id)data {
    
    ////解析包体数据
    NSString *bodyStr = [headParseClass parseIMPortPackaging:data];
    
    NSDictionary *bodyJson = [bodyStr JSONValue];
    
    NSLog(@"心跳包:%@",bodyJson);
    
    heartBeatInterval = [[bodyJson objectForKey:@"step"]intValue];
    if (heartBeatInterval <=0 ) {
        NSAssert(false, @"Receive interval error");
    }
    
    // NSNumber is a object so you can not use it as the type Snail 4.8
    [self performSelector:@selector(sendXingtiaoPackageCommandId:) withObject:nil afterDelay:heartBeatInterval];
}

- (void)sendXingtiaoPackageCommandId:(int)type{
    
    TcpSendPackage *xintiaoPackage = [TcpSendPackage createXintiaoPackage];
    NSData *data = [xintiaoPackage data];
    // Snail 4.8
    [[ChatTcpHelper shareChatTcpHelper] sendMessage:data withTimeout:-1 tag:COMMUNITY_TCP_XINTIAO_COMMAND_ID];
    
}

- (void)sendLogingPackageCommandId:(int)type{
    
    TcpSendPackage *loginPackage = [TcpSendPackage createLoginPackage];
    NSData *data = [loginPackage data];
    
    NSData *test = [data copy];
    NSDictionary *dic = [headParseClass getPackageHeaderInfo:test];
    NSLog(@"%@",dic);
    [[ChatTcpHelper shareChatTcpHelper] sendMessage:data withTimeout:-1 tag:COMMUNITY_TCP_LOGIN_COMMAND_ID];
    
}

- (void)receiveLoginResponse:(id)data {
    //解析包体数据
    NSString *bodyStr = [headParseClass parseIMPortPackaging:data];
    
    NSDictionary *bodyJson = [bodyStr JSONValue];
    
    NSLog(@"IM请求结果=%@",bodyJson);
    
    
    if ([[bodyJson objectForKey:@"rcode"]intValue] == 0) {
        //登录成功后，发送心跳包
        [self sendXingtiaoPackageCommandId:COMMUNITY_TCP_XINTIAO_COMMAND_ID];
        
//        [[NSNotificationCenter defaultCenter]postNotificationName:kNotiLoginSuccess object:nil];
        
    }else if([[bodyJson objectForKey:@"rcode"]intValue] == 2){
        
        NSString *ip = [NSString stringWithFormat:@"%@",[bodyJson objectForKey:@"ip"]];
        
        //登录重定向连接
        [[ChatTcpHelper shareChatTcpHelper]redirectConnectToHost:ip port:[[bodyJson objectForKey:@"port"] intValue]];
    }
    
    
}

-(void) sendLogoutPackageCommandId:(int)type{
    TcpSendPackage *logoutPackage = [TcpSendPackage createLogoutPackage];
    NSData *data = [logoutPackage data];
    [[ChatTcpHelper shareChatTcpHelper] sendMessage:data withTimeout:-1 tag:type];
}

//- (void)sendMessagePackageCommandId:(int)type andMessageData:(MessageData *)msgData
//{
//    TcpSendPackage *textMessagePackage = [TcpSendPackage createMessagePackageWith:msgData];
//    NSData *data = [textMessagePackage data];
//    
//    [[ChatTcpHelper shareChatTcpHelper] sendMessage:data withTimeout:-1 tag:type];
//}

-(void) receiveLogoutResponse:(id)data{
    //解析包体数据
    NSString *bodyStr = [headParseClass parseIMPortPackaging:data];
    
    NSDictionary *bodyJson = [bodyStr JSONValue];
    
    
    if ([[bodyJson objectForKey:@"rcode"]intValue] == 0) {
        //登录成功后，发送心跳包
        NSLog(@"=====logoutSuccess=====");
        [[ChatTcpHelper shareChatTcpHelper] disConnectHost];
    }
    NSLog(@"IM请求结果=%@",bodyJson);
}



- (void)receiveChatMessage:(NSData *)data
{
    //获取包头
    NSDictionary *headDic = [headParseClass getHeaderInfo:data];
    //获取包体
    NSDictionary *bodyDic = [self retrieveBodyDicFrom:data];
    
    //解析并存储消息数据
//    [self parseMessageWithHeadDic:headDic andBodyDic:bodyDic];
}

- (NSDictionary *)retrieveBodyDicFrom:(NSData *)data
{
    
    NSString *reterieveBody = [headParseClass parseIMPortPackaging:data];
    
    NSDictionary *bodyDic = [reterieveBody JSONValue];
    
    NSLog(@"get dic %@",bodyDic);
    return bodyDic;
}


- (void)receiveOfflineMessage:(NSData *)data
{
    NSDictionary * olMessageHead = [headParseClass getHeaderInfo:data];
    NSDictionary * bodyDic = [headParseClass getBodyDic:data];
    NSLog(@"Get offline Dic head %@ \n and body %@",olMessageHead,bodyDic);
    
    NSArray * msgList = [bodyDic objectForKey:@"msglist"];
    if (msgList != nil && [msgList respondsToSelector:@selector(count)] && msgList.count ) {
//        for (NSDictionary * olmsgDic in msgList) {
//            [self parseMessageWithHeadDic:olMessageHead andBodyDic:olmsgDic];
//        }
        
        NSDictionary * latestMsgDic = [msgList lastObject];
        NSDictionary * resultDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:0],@"rcode",
                                    [latestMsgDic objectForKey:@"msgid"],@"recvmsgid",
                                    nil];
        [self sendOfflineMessageReceiveFeedBackWithDic:resultDic];
    } else {
//        [Common checkProgressHUD:@"消息数据Json 格式有误" andImage:nil showInView:APPKEYWINDOW];
    }
  
}

#pragma mark - Dealloc
- (void)dealloc
{
    [super dealloc];
}

@end
