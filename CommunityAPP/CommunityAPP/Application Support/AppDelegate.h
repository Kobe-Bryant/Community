//
//  AppDelegate.h
//  CommunityAPP
//
//  Created by yunlai on 14-3-4.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "MBProgressHUD.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import "CommunityHttpRequest.h"
#import "LoginViewController.h"
#import "DPAPI.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"

@class DataBaseManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate,AMapSearchDelegate,MBProgressHUDDelegate,WXApiDelegate>
{
    LoginViewController *loginVc;
    MBProgressHUD           *_mbProgressView;
    enum WXScene _scene;
    DataBaseManager *dbManager;
    
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic,retain)  CommunityHttpRequest *request;
@property (nonatomic,retain)  NSMutableDictionary *introduceInfo;
@property (nonatomic,retain) NSDictionary *updateDictionary;
//区域 add vincent
@property (nonatomic,retain) NSString *areaString;
@property (nonatomic,retain) NSString *areaIdString;

@property (nonatomic, strong) UITabBarController *tabBarController;

//登录成功的回调函数
-(void)loadAnimationEndedCallback:(NSDictionary *)dictionary;

//退出登陆
-(void)seafQuitOutLogin;

//   当前消息列表中有多少数据未读
- (void)setNeighboorBadge;

//add vincent 大众点评
+ (AppDelegate *)instance;

@property (readonly, nonatomic) DPAPI *dpapi;
@property (strong, nonatomic) NSString *dpapiAppKey;
@property (strong, nonatomic) NSString *dpapiAppSecret;
- (void)setAppKey:(NSString *)appKey;
- (void)setAppSecret:(NSString *)appSecret;

//请求分组列表
-(void)requestGruopList;
//请求邻居列表
-(void)requestFriendList;

//状态栏
-(void)hideProgressViewForType:(ProgressViewHiddenType)type message:(NSString *)message afterDelay:(NSTimeInterval)delay;
-(void)showLoadingProgressViewWithText:(NSString *)string;

@end
