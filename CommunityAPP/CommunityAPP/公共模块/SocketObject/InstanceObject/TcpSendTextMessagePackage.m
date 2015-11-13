//
//  TcpSendTextMessagePackage.m
//  ql
//
//  Created by LazySnail on 14-5-5.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "TcpSendTextMessagePackage.h"
#import "headParseClass.h"
//#import "TextMessageData.h"

@interface TcpSendTextMessagePackage (){
    //客户端本地消息ID，接收确认用（客户端本地维护，服务器原样带回）
    long _locmsgid;
}

@end

@implementation TcpSendTextMessagePackage

// 根据协议将消息信息转化为合理数据包

//- (NSData *)data {
//    NSMutableData *allData = [[NSMutableData alloc]init];
//    
//    NSString *messageJsonStr = [headParseClass TransformMessage:self.messageData];;
//    NSData *bodyData = [messageJsonStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSInteger length = bodyData.length;
//    [allData appendData:[headParseClass sendIMPortPackaging:length wCmd:self.messageData.sendCommandType srcUid:self.messageData.senderID destUid:self.messageData.receiverID]];
//    [allData appendData:bodyData];
//    
//    return allData;
//}

@end
