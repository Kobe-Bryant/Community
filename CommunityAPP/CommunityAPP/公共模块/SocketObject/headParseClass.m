//
//  headParseClass.m
//  ql
//
//  Created by yunlai on 14-4-29.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "headParseClass.h"
#import "SBJson.h"
#import "JSONKit.h"
#import "NSData+SocketAddiction.h"
#import "ChatCommon.h"

#define lhtonll(x) __DARWIN_OSSwapInt64(x)
#define lntohll(x) __DARWIN_OSSwapInt64(x)

@implementation headParseClass

// 包头数据封装
+ (NSData *)sendIMPortPackaging:(int)packLength{
    
    UInt8 buffer[32];
    UInt32 *dwVer = (UInt32 *)&buffer[0];
    UInt32 ver = 0x1001;
    *dwVer = htonl(ver);
    
    UInt32 *dwLen =(UInt32 *) &buffer[4];
    *dwLen = htonl(32 + packLength);
    
    UInt16 *wSeq = (UInt16 *)&buffer[8];
    *wSeq = htons(0);
    
    UInt16 *wCmd = (UInt16 *)&buffer[10];
    UInt16 cmd = 0x0000;
    *wCmd = htons(cmd);
    
    UInt64 *llSrcUid = (UInt64 *)&buffer[12];
    *llSrcUid = lhtonll(1);
    
    UInt64 *llDestUid =(UInt64 *) &buffer[20];
    *llDestUid = lhtonll(10000);
    NSLog(@"sizeof==%lu",sizeof(UInt64));
    
    UInt32 *Reserve = (UInt32 *)&buffer[28];
    *Reserve = htonl(0);
    
    NSData *aData = [NSData dataWithBytes:buffer length:32];
    
    return aData;
}

// 包头数据封装
+ (NSData *)sendIMPortPackaging:(int)packBodyLength wCmd:(int)wcmds srcUid:(long long)SrcUid destUid:(long long)DestUid{
    
    UInt8 buffer[32];
    UInt32 *dwVer = (UInt32 *)&buffer[0];
    UInt32 ver = 0x1001;
    *dwVer = htonl(ver);
    
    UInt32 *dwLen =(UInt32 *) &buffer[4];
    *dwLen = htonl(32 + packBodyLength);
    
    // 统一规范 包序号用于检测包的发送和丢失 很重要 Snail
    UInt16 *wSeq = (UInt16 *)&buffer[8];
    *wSeq = htons(0);
    
    UInt16 *wCmd = (UInt16 *)&buffer[10];
    UInt16 cmd = wcmds;
    *wCmd = htons(cmd);
    
    UInt64 *llSrcUid = (UInt64 *)&buffer[12];
    *llSrcUid = lhtonll(SrcUid);
    
    UInt64 *llDestUid =(UInt64 *) &buffer[20];
    *llDestUid = lhtonll(DestUid);
    
    UInt32 *Reserve = (UInt32 *)&buffer[28];
    *Reserve = htonl(0);
    
    NSData *aData = [NSData dataWithBytes:buffer length:32];
    
    return aData;
}

//获取完整的发送包
+ (NSMutableData *)generateSendDataWithCommand:(int)command version:(int)ver serialNumber:(int)serialNum senderID:(long long)senderID receiverID:(long long)receiverID andValue:(id)bodyValue
{
    NSString * bodyJsonStr = [bodyValue JSONRepresentation];
    NSData * bodyData = [bodyJsonStr dataUsingEncoding:NSUTF8StringEncoding];
    int wholeLenght = bodyData.length + 32;
    NSMutableData * wholeData = [NSMutableData new];
    //将data的每个字节进行相应的赋值
    //版本号拼接
    [wholeData rw_appendInt32:ver];
    //整体包长度拼接
    [wholeData rw_appendInt32:wholeLenght];
    //包序列号拼接
    [wholeData rw_appendInt16:serialNum];
    //操作码拼接
    [wholeData rw_appendInt16:command];
    //发送方ID 拼接
    [wholeData rw_appendInt64:senderID];
    //接收方ID 拼接
    [wholeData rw_appendInt64:receiverID];
    //扩展字节 拼接
    [wholeData rw_appendInt32:EXTEND_NUM];
    //拼接包体
    [wholeData appendData:bodyData];
    
    return wholeData;
}

// 解析返回数据
+ (NSString *)parseIMPortPackaging:(NSData *)packData{
    
    void *testByte = malloc(sizeof(Byte)* packData.length);
    NSLog(@"%d",packData.length);
    memcpy(testByte, [packData bytes], packData.length);
    NSLog(@"%d",packData.length);
    
    UInt32 *dwVer = (UInt32 *)&testByte[0];
    *dwVer = ntohl(*dwVer);
    int v = *dwVer;
    
    UInt32 *dwLen = (UInt32 *)&testByte[4];
    *dwLen = ntohl(*dwLen);
    int len = *dwLen;
    
    UInt16 *wSeq = (UInt16 *)&testByte[8];
    *wSeq = ntohs(*wSeq);
    short seq = *wSeq;
    
    UInt16 *wCmd = (UInt16 *)&testByte[10];
    *wCmd = ntohs(*wCmd);
    short cmd = *wCmd;
    
    UInt64 *llSrcUid = (UInt64 *)&testByte[12];
    *llSrcUid = lntohll(*llSrcUid);
    long long srcUid = *llSrcUid;
    
    UInt64 *llDestUid = (UInt64 *)&testByte[20];
    *llDestUid = lntohll(*llDestUid);
    long long destUid = *llDestUid;
    
    UInt32 *Reserve = (UInt32 *)&testByte[28];
    *Reserve = ntohl(*Reserve);
    int reserve = *Reserve;

    NSLog(@"ver==%d=len=%d=seq=%d=cmd=%d=srcUid=%lld=destUid=%lld=reserve=%d",v,len,seq,cmd,srcUid,destUid,reserve);
    
    //取包体解析
    char *byte = (char *)&testByte[32];
    
    NSData *strData = [[NSData alloc] initWithBytes:byte length:len - 32];
    
    NSString *strjson = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
    free(testByte);
    return strjson;
}

+ (NSDictionary *)getBodyDic:(NSData *)packData
{
    void *testByte = malloc(sizeof(Byte)* packData.length);
    NSLog(@"%d",packData.length);
    memcpy(testByte, [packData bytes], packData.length);
    NSLog(@"%d",packData.length);
    
    UInt32 *dwVer = (UInt32 *)&testByte[0];
    *dwVer = ntohl(*dwVer);
    int v = *dwVer;
    
    UInt32 *dwLen = (UInt32 *)&testByte[4];
    *dwLen = ntohl(*dwLen);
    int len = *dwLen;
    
    UInt16 *wSeq = (UInt16 *)&testByte[8];
    *wSeq = ntohs(*wSeq);
    short seq = *wSeq;
    
    UInt16 *wCmd = (UInt16 *)&testByte[10];
    *wCmd = ntohs(*wCmd);
    short cmd = *wCmd;
    
    UInt64 *llSrcUid = (UInt64 *)&testByte[12];
    *llSrcUid = lntohll(*llSrcUid);
    long long srcUid = *llSrcUid;
    
    UInt64 *llDestUid = (UInt64 *)&testByte[20];
    *llDestUid = lntohll(*llDestUid);
    long long destUid = *llDestUid;
    
    UInt32 *Reserve = (UInt32 *)&testByte[28];
    *Reserve = ntohl(*Reserve);
    int reserve = *Reserve;
    
    NSLog(@"Get Pakage Head = /n ver==%d=len=%d=seq=%d=cmd=%d=srcUid=%lld=destUid=%lld=reserve=%d /n",v,len,seq,cmd,srcUid,destUid,reserve);
    
    //取包体解析
    char *byte = (char *)&testByte[32];
    
    NSData *strData = [[NSData alloc] initWithBytes:byte length:len - 32];
    
    NSString *strjson = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
    NSDictionary *bodyDic = [strjson JSONValue];
    free(testByte);
    
    return bodyDic;
}

+ (NSDictionary *)getPackageHeaderInfo:(NSData *)packData
{
    // 为了防止转译字节序时改变Data数据
    void *testByte = malloc(sizeof(Byte)* packData.length);
    memcpy(testByte, [packData bytes], packData.length);
    
    UInt32 *dwVer = (UInt32 *)&testByte[0];
    *dwVer = ntohl(*dwVer);
    int v = *dwVer;
    NSNumber *numV = [NSNumber numberWithInt:v];
    
    UInt32 *dwLen = (UInt32 *)&testByte[4];
    *dwLen = ntohl(*dwLen);
    int len = *dwLen;
    NSNumber *numLen = [NSNumber numberWithInt:len];
    
    UInt16 *wSeq = (UInt16 *)&testByte[8];
    *wSeq = ntohs(*wSeq);
    short seq = *wSeq;
    NSNumber *numSeq = [NSNumber numberWithShort:seq];
    
    UInt16 *wCmd = (UInt16 *)&testByte[10];
    *wCmd = ntohs(*wCmd);
    short cmd = *wCmd;
    NSNumber *numCmd = [NSNumber numberWithShort:cmd];
    
    UInt64 *llSrcUid = (UInt64 *)&testByte[12];
    *llSrcUid = lntohll(*llSrcUid);
    long long srcUid = *llSrcUid;
    NSNumber *numSrcUid = [NSNumber numberWithLongLong:srcUid];
    
    UInt64 *llDestUid = (UInt64 *)&testByte[20];
    *llDestUid = lntohll(*llDestUid);
    long long destUid = *llDestUid;
    NSNumber *numDestUid = [NSNumber numberWithLongLong:destUid];
    
    UInt32 *Reserve = (UInt32 *)&testByte[28];
    *Reserve = ntohl(*Reserve);
    int reserve = *Reserve;
    NSNumber *numReserve = [NSNumber numberWithInt:reserve];
    
    NSDictionary *responseDic = [NSDictionary dictionaryWithObjectsAndKeys:numV,@"dwVer",numLen,@"dwLen",numSeq,@"wSeq",numCmd,@"wCmd",numSrcUid,@"llSrcUid",numDestUid,@"llDestUid",numReserve,@"Reserve" ,nil];

    free(testByte);
    return responseDic;
}

+ (NSDictionary *)getHeaderInfo:(NSData *)packData
{
    // 为了防止转译字节序时改变Data数据
    void *testByte = malloc(sizeof(Byte)* packData.length);
    memcpy(testByte, [packData bytes], packData.length);
    
    UInt32 *dwVer = (UInt32 *)&testByte[0];
    *dwVer = ntohl(*dwVer);
    int v = *dwVer;
    NSNumber *numV = [NSNumber numberWithInt:v];
    
    UInt32 *dwLen = (UInt32 *)&testByte[4];
    *dwLen = ntohl(*dwLen);
    int len = *dwLen;
    NSNumber *numLen = [NSNumber numberWithInt:len];
    
    UInt16 *wSeq = (UInt16 *)&testByte[8];
    *wSeq = ntohs(*wSeq);
    short seq = *wSeq;
    NSNumber *numSeq = [NSNumber numberWithShort:seq];
    
    UInt16 *wCmd = (UInt16 *)&testByte[10];
    *wCmd = ntohs(*wCmd);
    short cmd = *wCmd;
    NSNumber *numCmd = [NSNumber numberWithShort:cmd];
    
    UInt64 *llSrcUid = (UInt64 *)&testByte[12];
    *llSrcUid = lntohll(*llSrcUid);
    long long srcUid = *llSrcUid;
    NSNumber *numSrcUid = [NSNumber numberWithLongLong:srcUid];
    
    UInt64 *llDestUid = (UInt64 *)&testByte[20];
    *llDestUid = lntohll(*llDestUid);
    long long destUid = *llDestUid;
    NSNumber *numDestUid = [NSNumber numberWithLongLong:destUid];
    
    UInt32 *Reserve = (UInt32 *)&testByte[28];
    *Reserve = ntohl(*Reserve);
    int reserve = *Reserve;
    NSNumber *numReserve = [NSNumber numberWithInt:reserve];
    
    NSDictionary *responseDic = [NSDictionary dictionaryWithObjectsAndKeys:numV,@"version",numLen,@"length",numSeq,@"sequence",numCmd,@"command",numSrcUid,@"sender_id",numDestUid,@"receiver_id",numReserve,@"reserve" ,nil];
    
    free(testByte);
    return responseDic;
}

// 登录IM接口
+ (NSString *) TransformJson:(NSArray*)msgArry withLinkclient:(NSNumber*)client clienttype:(NSString *)typeKey msgList:(NSString *)msgKey orgId:(NSNumber *)orgId orgKey:(NSString *)orgKey{
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:client,typeKey,msgArry,msgKey,orgId,orgKey, nil];
	NSString *jsonConvertedObj = [writer stringWithObject:dic];
    
	NSLog(@"jsonConvertedObj:%@",jsonConvertedObj);
    
    [writer release];
	NSString *reqStr = [NSString stringWithFormat:@"%@\n",jsonConvertedObj];

	return reqStr;
    
}

// 心跳包
+ (NSString *)TransformJsonStr:(NSNumber *)rcodeValue withLinkStep:(NSNumber*)stepValue rcode:(NSString *)keyr andStep:(NSString *)keys{
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:rcodeValue,keyr,stepValue,keys, nil];
	NSString *jsonConvertedObj = [writer stringWithObject:dic];
	NSLog(@"jsonConvertedObj:%@",jsonConvertedObj);
    
    [writer release];
	NSString *reqStr = [NSString stringWithFormat:@"%@\n",jsonConvertedObj];
	
	return reqStr;
}

// 消息纯文本转换
//+ (NSString *)TransformMessage:(MessageData *)msgData
//{    
//    NSDictionary *dic = [msgData getSendDic];
//    
//    NSString *messageJsonString = [dic JSONString];
//    NSLog(@"MessageJsonString = %@",messageJsonString);
//    
//    NSString *reqStr = [NSString stringWithFormat:@"%@\n",messageJsonString];
//    return reqStr;
//}

// 包体数据封装
+ (NSString *)TransFormNSDictionary:(NSDictionary *)dic{
    
    NSString *jsonString = [dic JSONString];
    NSLog(@"MessageJsonString = %@",jsonString);

    NSString *reqStr = [NSString stringWithFormat:@"%@\n",jsonString];
    return reqStr;
}

@end
