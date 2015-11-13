//
//  Global.h
//  CommunityAPP
//
//  Created by yunlai on 14-3-4.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#ifndef Sesame_ENVIRONMENT

#define Sesame_ENVIRONMENT 2//0:开发环境 1:测试环境 2:生产环境 3:预生产环境 999:挡板环境
#if Sesame_ENVIRONMENT==0
#define HTTPURLPREFIX @"http://192.168.1.9"
#define kHost @"192.168.1.9"

#define K_API_KEY   "0"

#elif Sesame_ENVIRONMENT==1
#define HTTPURLPREFIX @"http://192.168.1.5"
#define kHost @"192.168.1.5"
#define K_API_KEY   "1"

#elif Sesame_ENVIRONMENT==2
#define HTTPURLPREFIX @"http://xqb.city-media.net"
#define kHost @"113.106.91.178"
#define K_API_KEY   "2"


#elif Sesame_ENVIRONMENT==3
#define HTTPURLPREFIX @"http://yunlaicn.oicp.net:81"
#define K_API_KEY   "3"
#endif
#endif
/*********************挡板环境*********************/
//#elif Sesame_ENVIRONMENT==999
//#define HTTPURLPREFIX @"http://192.168.0.2"
//#endif

#define SOCKETIP    @"http://192.168.1.41"
#define SOCKETPORT  8101

//所有输入框的边框拉伸
#define APP_imageStrench   [[UIImage imageNamed:@"login_biankuang1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]

#define APP_NAME        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define APP_VERSION     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]


#pragma mark ---Share API_KEY

//新浪微博
#define SINA_WEIBO_API_KEY                  @"3898023576"
#define SINA_WEIBO_API_SECRET               @"b7bdedbd22e2763be0e651603fdbde04"
#define SINA_WEIBO_REDIRECT_URL             @"http://www.city-media.com.cn/"

//腾讯微博
#define TENCENT_WEIBO_API_KEY               @"801508207"
#define TENCENT_WEIBO_API_SECRET            @"b63a47329b4b49744ce00ced3b12c0ac"
#define TENCENT_WEIBO_REDIRECT_URI          @"http://www.city-media.com.cn/"

//微信  (还未申请通过)
#define WEIXIN_API_KEY                      @"wxc30ff8fba18bedd9"
#define WEIXIN_API_SECRET                   @"bdcd04b2a24513498cab7498b5aa1084"

//ShareSDK
#define SHARESDK_KEY                        @"1d67d7780b4d"

//友盟统计    （53b2592c56240b849a0333e2，个人）
#define COUNT_APPKEY                        @"538fd5a156240b675c088aff"

//大众点评 ///////////////////////////////////////////////////////////////////////////
#define kDPAppKey             @"5284075423"                                      /////
#define kDPAppSecret          @"4a1275d5e63f48148aeba4e3d7cf38c5"               /////
                                                                                /////
#ifndef kDPAppKey                                                               /////
#error                                                                          /////
#endif                                                                          /////
                                                                                /////
#ifndef kDPAppSecret                                                            /////
#error                                                                          /////
#endif                                                                          /////
/////////////////////////////////////////////////////////////////////////////////////


//通信的URL
#define My_INTEGRAL                     @"/web/points/my/"
#define LUCKDRAW_My_LOTTERY             @"/web/lottery/"
#define VERSION_UPDATE_URL              @"/i/v1/version/update.do"
#define DATE_COMMIT_URL                 @""
#define NOTIFICATION_LIST_URL           @"/i/v1/notification/list.do"
#define BILL_LIST_URL                   @"/i/v1/bill/list.do"
#define BILL_DETAIL_URL                 @"/i/v1/bill/detail.do"
#define PROFILE_DETAIL_URL              @"/i/v1/profile/detail.do"
#define COMMUNITY_LIST_URL              @"/i/v1/community/address.do"
#define RULES_LIST_URL                  @"/i/v1/rules/list.do"
#define COMMUNITY_INFO_URL              @"/i/v1/community/info.do"
#define CONTACTS_TYPE_URL               @"/i/v1/contacts/type.do"
#define CONTACTS_LIST_URL               @"/i/v1/contacts/list.do"
#define LIVEENCYCLOPEDIA_LIST_URL       @"/i/v1/life/list.do"
#define LIVEENCYCLOPEDIA_INFO_URL       @"/i/v1/life/info.do"
#define MODIFYPASSWORD_INFO_URL         @"/i/v1/profile/setting/changePassword.do"

#define PRIVATE_CONTACTS_ADD_URL        @"/i/v1/privateContacts/add.do"
#define PRIVATE_CONTACTS_UPDATE_URL     @"/i/v1/privateContacts/update.do"
#define PRIVATE_CONTACTS_DELETE_URL     @"/i/v1/privateContacts/delete.do"
#define AUCTION_INFO_URL                @"/i/v1/auction/info.do"
#define AUCTION_LIST_URL                @"/i/v1/auction/list.do"
#define AUCTION_ADD_URL                 @"/i/v1/auction/add.do"
#define LOGIN_REGISTER_LOGIN_URL        @"/i/v1/login/login.do"

//拼车上下班
#define CARSHARING_LIST_URL             @"/i/v1/carsharing/list.do"
#define CARSHARING_INFO_URL             @"/i/v1/carsharing/info.do"
#define CARSHARING_ADD_URL              @"/i/v1/carsharing/add.do"

#define COMMENT_LIST_URL                @"/i/v1/comment/list.do"
//短信验证码
#define COMMENT_REGISTER_MSGCODE        @"/i/v1/register/msgcode.do"
#define REGISTER_SECURITY               @"/i/v1/register/validatecode.do"
#define REGISTER_STEPONE                @"/i/v1/register/stepone.do"
#define REGISTER_STEPTWO                @"/i/v1/register/steptwo.do"

//找回密码
#define SEEK_PASSWORD_TESTSTEP          @"/i/v1/login/findbackmsgcode.do"
#define SEEK_PASSWORD_ONESTEP           @"/i/v1/login/findbackStep1.do"
#define SEEK_PASSWORD_TWOSTEP           @"/i/v1/login/findbackStep2.do"
#define SEEK_PASSWORD_THREESTEP         @"/i/v1/login/findbackStep3.do"
//获取邀请码
#define GET_INVITE                      @"/i/v1/invitecode/getInviteCode.do"
//邀请码历史记录
#define INVITE_HISTORY                  @"/i/v1/invitecode/inviteCodeHistory.do"
//添加评论
#define ADD_COMMENT                     @"/i/v1/comment/add.do"
//添加点赞
#define ADD_LOVE                        @"/i/v1/favour/add.do"
//取消点赞
#define DELE_LOVE                       @"/i/v1/favour/cancel.do"
//删除评论
#define DELEGATE_COMMENT                @"/i/v1/comment/delete.do"
//添加收藏
#define ADD_COLLECTION                  @"/i/v1/collect/add.do"
//取消收藏
#define CANCEL_COLLECTION               @"/i/v1/collect/cancel.do"
//我的评论
#define SEEK_MYCOMMENT                  @"/i/v1/activity/myComment.do"
//我的收藏
#define SEEK_MYCOLLECTION               @"/i/v1/activity/myCollect.do"
//我的发布
#define SEEK_MYPUBLISH                  @"/i/v1/activity/myPublish.do"
//删除我的发布
#define DELEGATE_MYPUBLISH              @"/i/v1/activity/delete.do"
//首页广告
#define HOME_AD                         @"/i/v1/ad/info.do"
//个人资料头像上传
#define MY_MEANS_POST                   @"/i/v1/profile/uploadResidentImg.do"
//修改个人资料
#define PROFILE_UPDATE_URL              @"/i/v1/profile/update.do"

#define MARQUEE_INFO_URL                @"/i/v1/marquee/info.do"
//签到 add vincent
#define REGISTRATION_ADD                @"/i/v1/registration/add.do"
//获奖记录
#define LOTTERY_RECODE                  @"/i/v1/lottery/recode.do"
//奖品列表和详情
#define LOTTERY_PRODUCT                 @"/i/v1/lottery/product.do"
//收货地址列表和详情
#define PROFILE_ADRESS_INFO             @"/i/v1/profile/address/info.do"
//新增和修改地址
#define PROFILE_ADRESS_EDIT             @"/i/v1/profile/address/edit.do"
//删除收货地址
#define PROFILE_ADDRESS_DEL             @"/i/v1/profile/address/del"
//区域地址
#define DATA_LOCATION                   @"/i/v1/data/location.do"
//消息推送数据上报
#define SUBSCRIBER_MSG_URL              @"/i/v1/data/subscriber/msg.do"
//意见反馈
#define MY_ADDVICE_POST                 @"/i/v1/settings/feedback"

//分组列表
#define NEIGHBORHOOD_GROUP_LIST         @"/i/v1/roster/group/list/"
//邻居列表
#define NEIGHBORHOOD_ROSTER_LIST        @"/i/v1/roster/list/"

//积分变更
#define POINT_CHANGE_URL                @"/i/v1/point/change.do"
//获取推送设置
#define SETTINGS_FEEDBACK_LIST          @"/i/v1/settings/feedback/list/"
//推送设置
#define SETTINGS_PUSH                   @"/i/v1/settings/push"

//大众点评
//获取支持商户搜索的最新分类列表 获取支持商户搜索的最新分类列表
#define DZDP_GET_CATEGORIES_WITH_BUSINESSES  @"/metadata/get_categories_with_businesses"
// 搜索商户 按照地理位置、商区、分类、关键词等多种条件获取商户信息列表
#define DZDP_FIND_BUSINESSES  @"/business/find_businesses"


//im 聊天
#ifndef __IPHONE_5_0
#warning "This project uses features only available in iOS SDK 5.0 and later."
#endif

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#endif

#define KEYBOARD_HEIGHT 216.0f
#define KEYBOARD_DURATION 0.25f
#define KEYBOARD_CURVE 0.0f


#define STR_CODE_SUCCESS    @"返回成功"
#define STR_CODE_FAILED     @"返回失败"
#define STR_PARA_ERROR      @"参数错误"
#define STR_VERIFI_FAILED   @"用户身份验证失败"
#define STR_DATA_EXCEPTION  @"数据库异常"

//百度地图
#define KBaiduAppKey @""

//rgb的颜色
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

//iphone4s和iphone5的适配
#define isIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define StateBarHeight 20
#define NavigationBarHeight 44
#define MainHeight (ScreenHeight - StateBarHeight - NavigationBarHeight)
#define MainWidth ScreenWidth

#define IOS7_OR_LATER   ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)
#define IOS6_OR_LATER   ([[[UIDevice currentDevice] systemVersion] doubleValue]>=6.0 && [[[UIDevice currentDevice] systemVersion] doubleValue] < 7.0)

//UINavigationController自定义
#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]
#define TOP_VIEW    [[UIApplication sharedApplication]keyWindow].rootViewController.view

#define kButtomBarHeight 49
#define kBottomButtonWidth 80
#define kBottomLineHeight 2

//add vincent
#define CommunitySendBackHeight 45
#define CommunityRowcellCount 2
#define RMarginX 0
#define RMarginY 0
//MBProgressHud
#define HUD_VIEW_WIDTH 200
#define HUD_VIEW_HEIGHT 100

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//所有的提示语
#define GolbalSesameRequestOutTime   @"当前网络不稳，请确认网络是否正常！"
#define GobalSesameNoPhoneDevice     @"你所使用的设备没有电话功能"
#define GlobalSesameLimitTiMENitice  @"您的版本是测试版本，当前版本的测试时间已经结束，请卸载后重新在appStrore下载"
#define GlobalSesameFeedBackInfo     @"谢谢你的意见"
#define GlobalCommunityNoDataWarning @"当前没有数据..."

//登陆的帐号和密码的key
#define GlobalSesameStartApp        @"GlobalSesameStartApp" //信息汇报
#define GlobalSesameLoginYesOrNo    @"SesameLoginYesOrNo"//是否登陆和已经注册
#define GlobalSesameLoginUser       @"SesameLoginUser"//帐号
#define GlobalSesameLoginPwd        @"SesameLoginPwd"//密码
#define GlobalSesameLoginDictionary @"GlobalSesameLoginDictionary"
#define GlobalsesameMemberId        @"GlobalsesameMemberId"


//add 刘文龙 2014.3.9
#define GlobalCommunityLatitude     @"GlobalCommunityLatitude" //经度
#define GlobalCommunityLongitude    @"GlobalCommunityLongitude" //纬度
#define GlobalCommunityAddress      @"GlobalCommunityAddress" //当前地址
#define GlobalCommunitySignIn       @"GlobalCommunitySignIn" //是否已经签到
//add vincent 2014.3.12
#define GlobalCommubityMyPersonalInformation  @"GlobalCommubityMyPersonalInformation"//我的个人资料
#define GlobalCommubityDistrictIntroduced     @"GlobalCommubityDistrictIntroduced"//小区介绍
#define GlobalCommubityHomeAd                 @"GlobalCommubityHomeAd"//首页广告
#define GlobalCommubityNeighborhoodAd         @"GlobalCommubityNeighborhoodAd"//邻里之间广告

#define SAFE_RELEASE(_POINTER)                {[_POINTER release]; _POINTER = nil;}

#define DealWithJSONValue(_JSONVALUE)         (_JSONVALUE != [NSNull null]) ? _JSONVALUE:@""


// 内存release置空
#define RELEASE_SAFE(x) if (x != nil) {[x release] ;x = nil;}


#define kREQSuccess         1  //请求成功
#define kREQFail            0  //请求失败
typedef enum _STATUS
{
    kSuccess     = 0,
    kDataFail    = 1,
    kRequestFail = 2,
}RESPONSE_CODE;

typedef enum
{
    Commmunity_Login            = 0,                //登录
    COMMUNITY_RULES_LIST,                           //规章制度列表
    COMMUNITY_ADDRESS_LIST,                         //地址
    COMMUNITY_PERSONAL_INFO,                        //个人资料 add by Stone -2014-3-10
    COMMUNITY_INTRODUCE_INFO,                       //小区介绍 add by Devin -2014-3-10
    COMMUNITY_NOTICE_INFO,                          //通知 add by Devin -2014-3-10
    COMMINITY_ADDRESS_INFO,                         //物业地址 add by Vincent -2014-3-11
    COMMUNITY_CONTACTS_TYPE,                        //电话本类型 add by Stone 2014-3-11
    COMMUNITY_CONTACTS_LIST,                        //电话列表   add by Stone 2014-3-11
    COMMUNITY_BILL_LIST_URL,                        //我的账单  add by vincent 2014-3-12
    COMMUNITY_PRIVATE_CONTACTS_ADD,                 //添加私人电话    add by Stone 2014-3-12
    COMMUNITY_PRIVATE_CONTACTS_UPDATE,              //修改私人电话    add by Stone 2014-3-12
    COMMUNITY_PRIVATE_CONTACTS_DELETE,              //删除私人电话    add by Stone 2014-3-12
    COMMUNITY_AUCTION_INFO,                         //随手拍了卖详情  add by Stone  2014-3-20
    COMMUNITY_AUCTION_LIST,                         //随手拍了卖列表   add by Stone   2014-3-20
    COMMUNITY_AUCTION_ADD,                          //随手拍了卖添加   add by Stone   2014-3-20
    COMMUNITY_LIVEENCYCLOPEDIA_LIST,                //生活百科列表 add bt Devin -2014-3-20
    COMMUNITY_LIVEENCYCLOPEDIA_INFO,                //生活百科详情 add bt Devin -2014-3-20
    COMMUNITY_CARSHARING_LIST,                      //拼车上下班列表 add vincent 2014-3-21
    COMMUNITY_CARSHARING_INFO,                      //拼车上下班详情 add vincent 2014-3-21
    COMMUNITY_COMMENT_LIST,                         //评论 add Stone 2014-3-24
    COMMUNITY_REGISTER_MSGCODE,                     //验证码 add vincent  2014-3-24
    COMMUNITY_REGISTER_SECURITY,                    //验证验证码 add vincent  2014-3-24
    COMMUNITY_MODIFYPASSWORD_INFO,                  //修改密码 add by Devin -2014-3-10
    COMMUNITY_REGISTER_LOGIN,                       //登录 add by Stone 2013-3-24
    COMMUNITY_REGISTER_STEPONE,                     //注册第一步 add by vincent 2013-3-24
    COMMUNITY_SEEKPASSWORD_ONE,                     //找回密码第一步 add by devin 2013-3-25
    COMMUNITY_SEEKPASSWORD_TWO,                     //找回密码第二步 add by devin 2013-3-25
    COMMUNITY_SEEKPASSWORD_THREE,                   //找回密码第三步 add by devin
    COMMUNITY_SEEKPASSWORD_TEST,                    //找回密码获取验证码 add by devin
    COMMUNITY_GETINVITE_TEST,                       //生成邀请码  add by devin 2013-4-4
    COMMUNITY_INVITEHISTORY_TEST,                   //邀请码历史  add by devin
    COMMUNITY_ADD_COMMENT,                          //添加评论  add by devin 2013-4-9
    COMMUNITY_ADD_LOVE,                             //添加点赞  add by devin 2013-4-8
    COMMUNITY_DELE_LOVE,                            //取消点赞  add by devin 2013-4-8
    COMMUNITY_DELEGATE_COMMENT,                     //删除评论  add by devin 2013-4-9
    COMMUNITY_ADD_COLLECTION,                       //添加收藏  add by devin 2013-4-10
    COMMUNITY_CANCEL_COLLECTION,                    //取消收藏  add by devin 2013-4-10
    COMMUNITY_SEEK_MYCOLLECTION,                    //我的收藏  add by devin 2013-4-12
    COMMUNITY_PROFILE_UPDATE ,                      //修改个人资料
    COMMUNITY_SEEK_MYCOMMENT ,                      //我的评论  add by devin 2013-4-12
    COMMUNITY_VERSION_UPDATE_URL,                   //版本升级 add by vincent 2014-4-12
    COMMUNITY_SEEK_MYPUBLISH,                       //我的评论  add by devin 2013-4-16
    COMMUNITY_DELEGATE_MYPUBLISH,                   //删除我的评论  add by devin 2013-4-16
    COMMUNITY_HOME_AD,                              //首页广告 add by devin
    COMMUNITY_MARQUEE_INFO,                         //跑马灯  add by Stone
    COMMENT_REGISTRATION_ADD,                       //签到  add by vincent
    COMMENT_LOTTERY_RECODE,                         //获奖记录 add by vincent
    COMMENT_LOTTERY_PRODUCT,                        //奖品列表 add by vincent
    COMMENT_PROFILE_ADRESS_INFO,                    //收货地址列表和详情 add by vincent
    COMMENT_PROFILE_ADRESS_EDIT,                    //新增和修改地址 add by vincent
    COMMENT_PROFILE_ADRESS_DELE,                    //删除收货地址
    COMMUNITY_DATA_LOCATION,                        //请求区域地址 add by vincent
    COMMUNITY_SUBSCRIBER_MSG,                       //消息推送数据上报   add by Stone
    COMMUNITY_POINT_CHANGE,                         //积分变更          add by Stone
    COMMUNITY_GROUP_LIST,                           //邻居分组列表       add by vincent
    COMMUNITY_SETTINGS_FEEDBACK_LIST,                //获取推送消息       add by Stone
    COMMUNITY_SETTINGS_PUSH,                        //推送消息设置        add by Stone
    COMMUNITY_FRIENDS_LIST,                         //邻居列表       add by vincent
    COMMUNITY_TCP_LOGIN_COMMAND_ID,                  //IM登录
    COMMUNITY_TCP_XINTIAO_COMMAND_ID,               //心跳包
    COMMUNITY_TCP_LOGOUT_COMMAND_ID,                //退出登录
} WInterface;

//------- ProgressView隐藏类型 -------
typedef enum{
    success = 0,
    failed,
    notification,
    collect,
    none
}ProgressViewHiddenType;

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@interface Global : NSObject
+ (CGFloat)judgementIOS7:(CGFloat)height;

+ (void)hideProgressViewForType:(ProgressViewHiddenType)type message:(NSString *)message afterDelay:(NSTimeInterval)delay;

+ (void)showLoadingProgressViewWithText:(NSString *)string;

//show HudView
+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg ShowTime:(CGFloat)showtime;
+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg ShowTime:(CGFloat)showtime LeftOffset:(NSInteger)leftOffset;
+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg;
+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg VisibleRect:(CGRect)vRect;
+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg LeftOffset:(NSInteger)leftOffset;
+ (MBProgressHUD *) showMBProgressHudHint:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg ShowTime:(CGFloat)showtime;

@end
