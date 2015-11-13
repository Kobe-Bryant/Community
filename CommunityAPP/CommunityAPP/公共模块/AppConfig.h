//
//  AppConfig.h
//  CommunityAPP
//
//  Created by liuzhituo on 14-3-8.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#ifndef CommunityAPP_AppConfig_h
#define CommunityAPP_AppConfig_h



#define kCommunityLoginSucceedNotification     @"kCommunityLoginSucceedNotification"

#define ERROR_CODE                      @"errorCode"
#define ERROR_MSG                       @"errormsg"

#define UPDATE_TIME                     @"updateTime"
#define USER_ID                         @"userId"
#define COMMUNITY_ID                    @"communityId"
#define PROPERTY_ID                     @"propertyId"
#define ICON                            @"icon"
#define CONTACT                         @"contact"
#define PHONE_NUMBER                    @"phoneNumber"
#define DESCRIPTION                     @"description"


#define DEF_UPDATE_TIME                 @"1"
#define MY_PRIVATE_CONTACTS_TYPE_ID     @"-10010"
#define MY_RECENTLY_TYPE_ID             @"-1"


//网络返回code定义
#define NETWORK_RETURN_CODE_S_OK                @"000"      //表示操作成功
#define NETWORK_RETURN_CODE_S_FAIL              @"001"      //未捕获的系统级错误
#define NETWORK_RETURN_PARA_ERROR               @"002"      //参数错误
#define NETWORK_RETURN_CHECK_FAILED             @"003"      //验证失败
#define NETWORK_RETURN_DB_EXCEPTION             @"004"      //数据库异常
#define NETWORK_RETURN_AUTHCODE_ERROR           @"005"      //验证码有误
#define NETWORK_RETURN_UPLOAD_EXCEPTION         @"006"         //文件上传异常
#define NETWORK_RETURN_INVCODE_ERROR            @"007"          //邀请码错误
#define NETWORK_RETURN_MESSAGE_CODE_ERROR       @"008"          //短信验证码发送失败

#define NETWORK_RETURN_POWER_AUTH_ERROR         @"010"          //权限认证失败
#define NETWORK_RETURN_USER_INFO_ERROR          @"011"          //登录信息有误




#endif


