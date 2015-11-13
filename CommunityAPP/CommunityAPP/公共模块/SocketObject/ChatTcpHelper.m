 //
//  ChatTcpHelper.m
//  ql
//
//  Created by yunlai on 14-5-3.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "ChatTcpHelper.h"
#import "headParseClass.h"
#import "TcpOperation.h"
#import "SBJson.h"
#import "TcpRequestHelper.h"
#import "Global.h"

ChatTcpHelper *ChatTcpHelperSINGLE;

@implementation ChatTcpHelper

@synthesize serverSocket = _serverSocket;

+ (ChatTcpHelper *)shareChatTcpHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (ChatTcpHelperSINGLE==nil) {
            ChatTcpHelperSINGLE = [[ChatTcpHelper alloc] init];
        }
    });
    
    return ChatTcpHelperSINGLE;
}

- (BOOL)connectToHost {
    if (allData != nil) {
        [allData release];
        allData = nil;
    }
    allData = [[NSMutableData alloc] init];

    if (_serverSocket == nil) {
        _serverSocket =[[AsyncSocket alloc] initWithDelegate:self];
    }
    
    // 连接服务器
    if (![_serverSocket isConnected]) {
        [_serverSocket disconnect];
        
        [_serverSocket connectToHost:SOCKETIP onPort:SOCKETPORT error:nil];
        
        return NO;
    }
    else{
        NSLog(@"已经和服务器连接");
        return YES;
    }
   
}

- (void)disConnectHost {
    [_serverSocket disconnect];
}

- (void)redirectConnectToHost:(NSString *)IPStr port:(int)portStr{
    
    [self disConnectHost];
    
    if (allData != nil) {
        RELEASE_SAFE(allData);
    }
    allData = [[NSMutableData alloc] init];
    
    if (_serverSocket == nil) {
        _serverSocket =[[AsyncSocket alloc] initWithDelegate:self];
    }
    
    // 连接服务器
    if (![_serverSocket isConnected]) {
        [_serverSocket disconnect];
        
        [_serverSocket connectToHost:IPStr onPort:portStr error:nil];
    }
    else{
        NSLog(@"重定向与服务器连接");
    }
}

- (void)sendMessage:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag{
    
    [_serverSocket writeData:data withTimeout:timeout tag:tag];
    const void *judgeByte = [data bytes];
    NSData *jData = [NSData dataWithBytes:judgeByte length:data.length];
    NSDictionary *headDic = [headParseClass getHeaderInfo:jData];
    NSDictionary * bodyDic = [headParseClass getBodyDic:jData];
    NSLog(@"%@,%@",headDic,bodyDic);

    tcpCommandId = tag;
}

#pragma mark - AsyncSocketDelegate
// 成功连接后自动回调
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    [sock readDataWithTimeout:-1 tag:tcpCommandId];
    NSLog(@"=====Soket 已经连接到服务器:%@ %hu",host,port);
    [[TcpRequestHelper shareTcpRequestHelperHelper]sendLogingPackageCommandId:COMMUNITY_TCP_LOGIN_COMMAND_ID];
}

// 接收到了一个新的socket连接 自动回调
// 接收到了新的连接  那么释放老的连接
-(void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{ 
    NSLog(@"=====Socket DidacceptNewSocket %@",newSocket);
}

- (void)onSocketDidSecure:(AsyncSocket *)sock{
    NSLog(@"=====Socket Secure ");
}

// 写数据成功 自动回调
-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"=====Socket 写数据成功 %ld",tag);
    // 继续监听
    [sock readDataWithTimeout:-1 tag:tcpCommandId];
}

//写入部分数据 回调
- (void)onSocket:(AsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag{
    NSLog(@"=====Soket write partial data length %d",partialLength);
}

//写数据的过程中遇见 timeout
- (NSTimeInterval)onSocket:(AsyncSocket *)sock
 shouldTimeoutWriteWithTag:(long)tag
                   elapsed:(NSTimeInterval)elapsed
                 bytesDone:(NSUInteger)length
{

    NSLog(@"=====Soket ShouldWrite tag%ld elapsed%f length%d",tag,elapsed,length);
    return -1;
}

// 客户端接收到了数据
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"=====Soket 收到消息");

    NSMutableArray *packgeArr = [[NSMutableArray alloc]init];
    // Incase the data is not complate so append data to insure it's complated
    [allData appendData:data];
    [self getComplateDataToArray:packgeArr];
    
    if (packgeArr.count > 0) {
        for (NSData * temp in packgeArr) {
            [[TcpOperation shareTcpOperation] addAPackage:nil commandType:tag packageData:temp];
        }
    }
    // 继续监听
    [sock readDataWithTimeout:-1 tag:tag];
}

//读数据过程中遇见 timeout
- (NSTimeInterval)onSocket:(AsyncSocket *)sock
  shouldTimeoutReadWithTag:(long)tag
                   elapsed:(NSTimeInterval)elapsed
                 bytesDone:(NSUInteger)length
{
    NSLog(@"=====Soket read should time out elapsed %f doneByteLength %d",elapsed,length);
    return -1;
}

// 客户端读取数据
- (void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    NSLog(@"=====Socket did read partial length %d",partialLength);
}


- (void)getComplateDataToArray:(NSMutableArray *)arr
{
    const void * byte = (const void *) [allData bytes];
    if (allData.length >= 8) {
        UInt32* dwlen = (UInt32*)&byte[4];
        int len = ntohl(*dwlen);
        if (allData.length < len) {
            return;
        }else{
            NSData* packageData = [NSData dataWithData:[allData subdataWithRange:NSMakeRange(0, len)]];
            [arr addObject:packageData];
            NSLog(@"%d",packageData.length);
            if (len == allData.length) {
                allData = [[NSData data] mutableCopy];
            }else{
                NSLog(@"%d",allData.length);
                allData = [[NSData dataWithData:[allData subdataWithRange:NSMakeRange(len, allData.length - len)]] mutableCopy];
                NSLog(@"%d",allData.length);
                [self getComplateDataToArray:arr];
            }
            NSLog(@"judgeData = %@",packageData);
            NSLog(@"allData = %@",allData);
        }
    }else{
        return;
    }
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err{
    NSLog(@"======Socket Will disconnect with:%@",err);
//    [Common checkProgressHUD:[NSString stringWithFormat:@"======Socket Will disconnect with %@",err ] andImage:nil showInView:APPD.keyWindow];
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock{
    NSLog(@"======Socket DidDisconnected");
}
@end
