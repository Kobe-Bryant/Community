//
//  ChatTcpHelper.h
//  ql
//
//  Created by yunlai on 14-5-3.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "TcpReadPackage.h"

@protocol ChatTcpHelperDeletage <NSObject>

//- (void)didFinishedMessageSendWithType:(int)type;

@end

//tcp发送请求类
@interface ChatTcpHelper : NSObject <AsyncSocketDelegate> {
    AsyncSocket *_serverSocket;
    TcpReadPackage *_currentReadPackage;//读包
    int tcpCommandId;
    NSMutableData* allData;
}

@property (nonatomic, retain)AsyncSocket * serverSocket;

+ (ChatTcpHelper *)shareChatTcpHelper;
//连接服务器
- (BOOL )connectToHost;
//断开服务器
- (void)disConnectHost;
//重定向连接
- (void)redirectConnectToHost:(NSString *)IPStr port:(int)portStr;
//发送消息
- (void)sendMessage:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag;
@end
