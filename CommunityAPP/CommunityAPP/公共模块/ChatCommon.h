//
//  ChatComment.h
//  CommunityAPP
//
//  Created by yunlai on 14-7-21.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"



/* ===== IM接口命令字定义===== */
#define IM_PACKAGE_NO_ENCRYPTION            0x1001 //不加密版本号

#define IM_PACKAGE_ENCRYPTION_AES           0x1002 //采用AES加密协议加密版本号

#define EXTEND_NUM                          0x0000 //包头扩展号

#define CMD_USER_LOGIN                      0x0000 //用户登陆

#define CMD_USER_LOGIN_ACK                  0x0001 //用户登录响应

#define CMD_USER_LOGOUT                     0x0002 //用户注销

#define CMD_USER_LOGOUT_ACK                 0x0003 //用户注销响应

#define CMD_USER_HEARTBEAT                  0x0004 //客户端心跳

#define CMD_USER_HEARTBEAT_ACK              0x0005 //客户端心跳ACK

#define CMD_PERSONAL_MSGSEND                0x0015 //单聊消息发送

#define CMD_PERSONAL_MSGSEND_ACK            0x0016 //单聊消息发送的响应

#define CMD_PERSONAL_MSGRECV                0x0017 //单聊消息接收

#define CMD_PERSONAL_PUSHREC                0x0018 //单聊消息离线消息接收

#define CMD_COMMUNITY_CHG_NTF               0x0400 //社区成员变更通知

@interface ChatCommon : NSObject

+ (ChatCommon *)sharedGlobal;

@property(nonatomic,retain)UserModel *userModel; //当前登陆成功的用户的数据信息
@end
