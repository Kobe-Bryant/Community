//
//  TcpRequestHelper.h
//  ql
//
//  Created by yunlai on 14-5-4.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TcpSendPackage.h"
#import "ChatTcpHelper.h"
//#import "TextMessageData.h"

@protocol TcpRequestHelperDelegate <NSObject>

- (void)didFinishedMessageSendWithDic:(NSDictionary *)retDic;

@end

@interface TcpRequestHelper : NSObject <ChatTcpHelperDeletage>
{
     NSTimeInterval *_nextSendIntarvel;
}

@property (nonatomic, assign) id <TcpRequestHelperDelegate> delegate;

+ (TcpRequestHelper *)shareTcpRequestHelperHelper;

//发送心跳包
- (void)sendXingtiaoPackageCommandId:(int)type;

//心跳包响应
- (void)receiveXintiaoPackage:(id)data;

//发送登录包
- (void)sendLogingPackageCommandId:(int)type;

//回调登录响应
- (void)receiveLoginResponse:(id)data;

//发送退出登陆包
-(void) sendLogoutPackageCommandId:(int) type;

//发送消息
//- (void)sendMessagePackageCommandId:(int)type andMessageData:(MessageData *)msgData;

//退出登陆响应
-(void) receiveLogoutResponse:(id) data;

//单聊发送文本消息响应 成功与否回馈
- (void)receiveMessageSended:(id)data;

//收到单聊消息
- (void)receiveChatMessage:(id)data;

//圈子发送文本消息 成功与否回馈
- (void)receiveCircleMessageSended:(NSData *)data;

//收到圈子消息
- (void)receiveCircleChatMessage:(NSData *)data;

//邀请成员加入圈子
- (void)sendInviteJoinCircleCommandId:(int)type receive:(int)receiveId bodyJson:(NSDictionary *)bodyDic;

//邀请加入的回调
- (void)receiveInviteJoinResponse:(id)data;

//收到好友的邀请加入圈子信息
- (void)receiveInviteMessage:(id)data;

//确认加入圈子信息
- (void)sendInviteJoinCircleConfirmCommandId:(int)type inviteId:(long long)inviteId bodyJson:(NSDictionary *)bodyDic;

//确认加入圈子回调
- (void)receiveConfirmInviteCircleResponse:(id)data;

//发送圈子成员变更提醒
- (void)sendCircleMemberUpdateCommandId:(int)type receive:(int)userId bodyJson:(NSDictionary *)bodyDic;

//圈子成员变更的回调
- (void)receiveCircleMemberUpdateResponse:(id)data;

//临时圈子成员变更回调
- (void)receiveTempCircleMemberUpdateResponse:(id)data;

//创建临时圈子请求
- (void)sendCreateTemporaryCircleRequestWithUserList:(NSArray *)uList;

//添加临时圈子成员请求
- (void)sendAddTemporaryCircleRequestWithUserList:(NSArray *)uList AndTempCircleID:(long long)TempCircle;

//收到创建临时圈子回馈
- (void)receiveCreateTemporaryCircleFeedback:(NSData *)data;

//临时圈子发送消息回执
- (void)receiveTempCircleMessageFeedback:(NSData *)data;

//收到临时圈子消息
- (void)receiveTempCircleChatMessage:(NSData *)data;

//单聊离线消息接收
- (void)receiveOfflineMessage:(NSData *)data;

//发送单聊离线消息接收回馈 将收到的最新的message信息返回给服务端
- (void)sendOfflineMessageReceiveFeedBackWithDic:(NSDictionary *)latestMsgDic;

//固定圈子批量接收离线消息
- (void)receiveOfflineCircleMessage:(NSData *)data;

//临时圈子批量接收离线消息
- (void)receiveOfflineTempCircleMessage:(NSData *)data;

//固定圈子信息变更通知消息
-(void) recieveCircleInfoChangeNotify:(NSData*) data;

//临时圈子信息变更通知消息
- (void)recieveTempCircleInfoChangeNotify:(NSData*) data;

//退出固定圈子
- (void) sendQuitCircleMessage:(NSDictionary*) dic;

//退出固定响应
- (void) recieveQuitCircleMessage:(NSData*) data;

//退出临时圈子
- (void) sendQuitTempCircleMessage:(NSDictionary *)dic;

//退出临时圈子响应
- (void) recieveQuitTempCircleMessage:(NSData *)data;

//被迫下线通知接收
- (void)receiveCompelQuitMessage:(NSData *)data;

@end
