//
//  headParseClass.h
//  ql
//
//  Created by yunlai on 14-4-29.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MessageData.h"

@interface headParseClass : NSObject

// 发送IM服务器接口
+ (NSData *)sendIMPortPackaging:(int)packLength;

+ (NSData *)sendIMPortPackaging:(int)packBodyLength wCmd:(int)wcmds srcUid:(long long)SrcUid destUid:(long long)DestUid;

//通过得到的包体数据和操作码生成对应的发送包
+ (NSMutableData *)generateSendDataWithCommand:(int)command version:(int)ver serialNumber:(int)serialNum senderID:(long long)senderID receiverID:(long long)receiverID andValue:(id)bodyValue;

// IM服务器返回数据解析
+ (NSString *)parseIMPortPackaging:(NSData *)packData;

// 登录IM接口
+ (NSString *) TransformJson:(NSArray*)msgArry withLinkclient:(NSNumber*)client clienttype:(NSString *)typeKey msgList:(NSString *)msgKey orgId:(NSNumber *)orgId orgKey:(NSString *)orgKey;

// 心跳包
+ (NSString*)TransformJsonStr:(NSNumber *)rcodeValue withLinkStep:(NSNumber*)stepValue rcode:(NSString *)keyr andStep:(NSString *)keys;

// 文本消息包
//+ (NSString *)TransformMessage:(MessageData *)msgData;

// 获取包头信息
+ (NSDictionary *)getPackageHeaderInfo:(NSData *)packData;

// 获取包头人性化版本 尽量用该方法 之前的方法将会在重构的时候废弃
+ (NSDictionary *)getHeaderInfo:(NSData *)packData;

// 包体数据封装
+ (NSString *)TransFormNSDictionary:(NSDictionary *)dic;

// 获取包体字段人性化版本
+ (NSDictionary *)getBodyDic:(NSData *)packData;
@end
