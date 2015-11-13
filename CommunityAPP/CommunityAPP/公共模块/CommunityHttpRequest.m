//
//  CommunityHttpRequest.m
//  CommunityAPP
//
//  Created by Stone on 14-3-10.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "CommunityHttpRequest.h"
#import "URLHelper.h"
#import "Global.h"
#import "ASIWebServer.h"
#import "Reachability.h"

static Reachability *_reachability = nil;
BOOL _reachabilityOn;

static inline Reachability* defaultReachability () {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _reachability = [Reachability reachabilityForInternetConnection];
    });
    
    return _reachability;
}

@implementation CommunityHttpRequest

+ (id)shareInstance{
    static CommunityHttpRequest *instance = nil;
    if (instance == nil) {
        instance = [[CommunityHttpRequest alloc] init];
    }
    return instance;
}

- (void)dealloc{
    [self stopInternerReachability];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (id) init{
    self = [super init];
    if (self) {
        [self startInternetReachability];
    }
    
    return self;
}

#pragma mark ---Reachibility
- (void)startInternetReachability {
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus) name:kReachabilityChangedNotification object:nil];
    
    if (!_reachabilityOn) {
        _reachabilityOn = TRUE;
        [defaultReachability() startNotifier];
    }
    
    [self checkNetworkStatus];
}


- (void)checkNetworkStatus {
    
    NetworkStatus internetStatus = [defaultReachability() currentReachabilityStatus];
    switch (internetStatus) {
            
        case NotReachable: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"网络异常,请检查网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
            break;
        }
            
            break;
        case ReachableViaWiFi:
        case ReachableViaWWAN: {

            break;
        }
            
        default:
            break;
    }
}


- (void)stopInternerReachability {
    
    _reachabilityOn = FALSE;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (void)cancelDelegate:(id)delegate{
    if (delegate == nil) {
        return;
    }
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer cancel:delegate];
}

+ (void)showProcessView:(NSString *)msg       //加载菊花
{
    [Global showLoadingProgressViewWithText:msg];
}
+ (void)hideProcessView                       //取消菊花
{
    [Global hideProgressViewForType:none message:nil afterDelay:0.f];
}

- (NSString *)getUrl{
    return HTTPURLPREFIX;
}

- (void)requestPersonalInfodelegate:(id)delegate parameters:(NSString *)parameters {

    NSString *url = [self getUrl];
    NSString *urlPara = parameters;

    NSLog(@"url Para :%@",urlPara);
    NSString *methodName = PROFILE_DETAIL_URL;
    WInterface interface = COMMUNITY_PERSONAL_INFO;
    
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
    
}
//小区介绍 add by devin
- (void)requestCommunityInfo:(id)delegate parmeters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = COMMUNITY_INFO_URL;
    WInterface interface = COMMUNITY_INTRODUCE_INFO;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}
//通知 add by devin
-(void)requestNotice:(id)delegate parameters:(NSString *)parameters
{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = NOTIFICATION_LIST_URL;
    WInterface interface = COMMUNITY_NOTICE_INFO;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}
//生活百科列表  add by devin
-(void)requestLiveEncyclopedia:(id)delegate parameters:(NSString *)parameters
{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = LIVEENCYCLOPEDIA_LIST_URL;
    WInterface interface = COMMUNITY_LIVEENCYCLOPEDIA_LIST;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}
//生活百科详情  add by devin
-(void)requestDetailLiveEncyclopedia:(id)delegate parameters:(NSString *)parameters
{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = LIVEENCYCLOPEDIA_INFO_URL;
    WInterface interface =  COMMUNITY_LIVEENCYCLOPEDIA_INFO;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}
//修改密码  add by devin
- (void)requestModifyPassword:(id)delegate parameters:(NSString *)parameters
{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = MODIFYPASSWORD_INFO_URL;
    WInterface interface =  COMMUNITY_MODIFYPASSWORD_INFO;
    ASIWebServer *webServer = [ASIWebServer shareController];
   //https加密通道 ssl
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate SSL:YES showLoad:NO];
}

//add by vincent 2014.3.11 地址
- (void)requestAddress:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = COMMUNITY_LIST_URL;
    WInterface interface = COMMINITY_ADDRESS_INFO;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

- (void)requestContactTypes:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    
    NSLog(@"url Para :%@",urlPara);
    NSString *methodName = CONTACTS_TYPE_URL;
    WInterface interface = COMMUNITY_CONTACTS_TYPE;
    
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

- (void)requestContacts:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    
    NSLog(@"url Para :%@",urlPara);
    NSString *methodName = CONTACTS_LIST_URL;
    WInterface interface = COMMUNITY_CONTACTS_LIST;
    
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

//add vincent  by vincent -2013.03.12
- (void)requestBillList:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    
    NSLog(@"url Para :%@",urlPara);
    NSString *methodName = BILL_LIST_URL;
    WInterface interface = COMMUNITY_BILL_LIST_URL;
    
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

- (void)addContact:(id)delegate parameters:(NSString *)parameters      //添加电话记录   add by Stone -2014.03.13
{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    
    NSLog(@"url Para :%@",urlPara);
    NSString *methodName = PRIVATE_CONTACTS_ADD_URL;
    WInterface interface = COMMUNITY_PRIVATE_CONTACTS_ADD;
    
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:YES];
}

- (void)editContact:(id)delegate parameters:(NSString *)parameters     //修改联系人     add by Stone -2014.03.13
{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    
    NSLog(@"url Para :%@",urlPara);
    NSString *methodName = PRIVATE_CONTACTS_UPDATE_URL;
    WInterface interface = COMMUNITY_PRIVATE_CONTACTS_UPDATE;
    
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

- (void)deleteContact:(id)delegate parameters:(NSString *)parameters   //删除联系人     add by Stone -2014.03.13
{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    
    NSLog(@"url Para :%@",urlPara);
    NSString *methodName = PRIVATE_CONTACTS_DELETE_URL;
    WInterface interface = COMMUNITY_PRIVATE_CONTACTS_DELETE;
    
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

#pragma mark ---随手拍了卖

- (void)requestAuctionInfo:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    
    NSLog(@"url Para :%@",urlPara);
    NSString *methodName = AUCTION_INFO_URL;
    WInterface interface = COMMUNITY_AUCTION_INFO;
    
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
    
}

- (void)requestAuctionList:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    
    NSLog(@"url Para :%@",urlPara);
    NSString *methodName = AUCTION_LIST_URL;
    WInterface interface = COMMUNITY_AUCTION_LIST;
    
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

- (void)requestAuctionAdd:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    
    NSLog(@"url Para :%@",urlPara);
    NSString *methodName = AUCTION_ADD_URL;
    WInterface interface = COMMUNITY_AUCTION_ADD;
    
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

// add vincent 2014.3.21 请求当前的拼车上下班的数据
- (void)requestCarPoolAdd:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    
    NSLog(@"拼车上下班的数据 url Para :%@",urlPara);
    NSString *methodName = CARSHARING_LIST_URL;
    WInterface interface = COMMUNITY_CARSHARING_LIST;
    
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}
// add vincent 2014.3.21 请求当前的拼车上下班的数据详情
- (void)requestCarPoolDetailAdd:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    
    NSLog(@"拼车上下班详情的数据 url Para :%@",urlPara);
    NSString *methodName = CARSHARING_INFO_URL;
    WInterface interface = COMMUNITY_CARSHARING_INFO;
    
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];

}

- (void)requestComments:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    
    NSLog(@"请求评论 url Para :%@",urlPara);
    NSString *methodName = COMMENT_LIST_URL;        //COMMUNITY_COMMENT_LIST;
    WInterface interface = COMMUNITY_COMMENT_LIST;
    
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

//add vincent 验证码 2014.03.24
- (void)requestRegisterMsgcode:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    
    NSString *methodName = COMMENT_REGISTER_MSGCODE;
    WInterface interface = COMMUNITY_REGISTER_MSGCODE;
    
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

- (void)requestLogin:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    
    NSString *methodName = LOGIN_REGISTER_LOGIN_URL;//COMMUNITY_REGISTER_LOGIN;
    WInterface interface = COMMUNITY_REGISTER_LOGIN;
    
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate SSL:YES showLoad:NO];
}

//add vincent 验证验证码 2014.03.24
- (void)requestVerificationAction:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    
    NSString *methodName = REGISTER_SECURITY;
    WInterface interface = COMMUNITY_REGISTER_SECURITY;
    
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

- (void)requestRegisterOneStep:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    
    NSString *methodName = REGISTER_STEPONE;
    WInterface interface = COMMUNITY_REGISTER_STEPONE;
    
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}
//add by devin 找回密码验证码
-(void)requestSeekPasswordTestStep:(id)delegate parameters:(NSString *)parameters
{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = SEEK_PASSWORD_TESTSTEP;
    WInterface interface = COMMUNITY_SEEKPASSWORD_TEST;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

//add by devin 找回密码第一bu
-(void)requestSeekPasswordOneStep:(id)delegate parameters:(NSString *)parameters
{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = SEEK_PASSWORD_ONESTEP;
    WInterface interface = COMMUNITY_SEEKPASSWORD_ONE;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
    
}
//add by devin 找回密码第二步
-(void)requestSeekPasswordTwoStep:(id)delegate parameters:(NSString *)parameters
{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = SEEK_PASSWORD_TWOSTEP;
    WInterface interface = COMMUNITY_SEEKPASSWORD_TWO;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}
//add by devin 找回密码第三步
-(void)requestSeekPasswordThreeStep:(id)delegate parameters:(NSString *)parameters
{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = SEEK_PASSWORD_THREESTEP;
    WInterface interface = COMMUNITY_SEEKPASSWORD_THREE;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

//add by devin 获取邀请码
-(void)requestGetInvite:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = GET_INVITE;
    WInterface interface = COMMUNITY_GETINVITE_TEST;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

//add by devin 邀请码历史记录
-(void)requestInviteHistory:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = INVITE_HISTORY;
    WInterface interface = COMMUNITY_INVITEHISTORY_TEST;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}
//add by devin 添加生活百科评论 4.8
-(void)requestAddComment:(id)delegate parameters:(NSString *)parameters
{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = ADD_COMMENT;
    WInterface interface = COMMUNITY_ADD_COMMENT;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}
//add by devin 添加生活百科点赞 4.8
-(void)requestAddLove:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = ADD_LOVE;
    WInterface interface = COMMUNITY_ADD_LOVE;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}
//add by devin 取消生活百科点赞
-(void)requestDeleLove:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = DELE_LOVE;
    WInterface interface = COMMUNITY_DELE_LOVE;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];

}

//add by devin 删除生活百科评论
-(void)requestDelegateComment:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = DELEGATE_COMMENT;
    WInterface interface = COMMUNITY_DELEGATE_COMMENT;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];

}
//add by devin 添加生活百科收藏
-(void)requestAddCollect:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = ADD_COLLECTION;
    WInterface interface = COMMUNITY_ADD_COLLECTION;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];

}
//add by devin 取消生活百科收藏
-(void)requestCancelCollect:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = CANCEL_COLLECTION;
    WInterface interface = COMMUNITY_CANCEL_COLLECTION;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];

}
//add by devin 查询我的评论
-(void)requestMyComment:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = SEEK_MYCOMMENT;
    WInterface interface = COMMUNITY_SEEK_MYCOMMENT;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];

}
//add by devin 查询我的收藏
-(void)requestMyCollection:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = SEEK_MYCOLLECTION;
    WInterface interface = COMMUNITY_SEEK_MYCOLLECTION;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

- (void)requestModifyMyInfo:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = PROFILE_UPDATE_URL;
    WInterface interface = COMMUNITY_PROFILE_UPDATE;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

//add by vincent 版本升级
-(void)requestVersionUpdate:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = VERSION_UPDATE_URL;
    WInterface interface = COMMUNITY_VERSION_UPDATE_URL;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

//add by devin 查询我的发布
-(void)requestMyPublish:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = SEEK_MYPUBLISH;
    WInterface interface = COMMUNITY_SEEK_MYPUBLISH;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}
//add by devin 删除我的发布
-(void)requestDelegateMyPublish:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = DELEGATE_MYPUBLISH;
    WInterface interface = COMMUNITY_DELEGATE_MYPUBLISH;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}
// add by devin 首页广告
-(void)requestHomeAd:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = HOME_AD;
    WInterface interface = COMMUNITY_HOME_AD;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];

}

-(void)requestMarquee:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = MARQUEE_INFO_URL;
    WInterface interface = COMMUNITY_MARQUEE_INFO;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

//签到
-(void)requestSignIn:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = REGISTRATION_ADD;
    WInterface interface = COMMENT_REGISTRATION_ADD;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

//获奖记录
-(void)requestLotteryRrecode:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = LOTTERY_RECODE;
    WInterface interface = COMMENT_LOTTERY_RECODE;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

//奖品列表
-(void)requestLotteryProduct:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = LOTTERY_PRODUCT;
    WInterface interface = COMMENT_LOTTERY_PRODUCT;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}
//地址列表
-(void)requestAddressInfo:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = PROFILE_ADRESS_INFO;
    WInterface interface = COMMENT_PROFILE_ADRESS_INFO;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

//编辑地址
-(void)requestAddressEdit:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = PROFILE_ADRESS_EDIT;
    WInterface interface = COMMENT_PROFILE_ADRESS_EDIT;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

//删除收货地址
-(void)requestDeleteAddress:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = PROFILE_ADDRESS_DEL;
    WInterface interface = COMMENT_PROFILE_ADRESS_DELE;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

//请求区域地址
-(void)requestDataLocation:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = DATA_LOCATION;
    WInterface interface = COMMUNITY_DATA_LOCATION;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

//百度云服务数据上报
- (void)requestSubscribe:(id)delegate parmaeters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = SUBSCRIBER_MSG_URL;
    WInterface interface = COMMUNITY_SUBSCRIBER_MSG;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

- (void)requestPointChange:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = POINT_CHANGE_URL;
    WInterface interface = COMMUNITY_POINT_CHANGE;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

//请求邻居分组列表
- (void)requestGroupList:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = NEIGHBORHOOD_GROUP_LIST;
    WInterface interface = COMMUNITY_GROUP_LIST;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}
//请求邻居列表
- (void)requestFriendNeighborhoodList:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = NEIGHBORHOOD_ROSTER_LIST;
    WInterface interface = COMMUNITY_FRIENDS_LIST;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

- (void)requestNoticeSetting:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = SETTINGS_FEEDBACK_LIST;
    WInterface interface = COMMUNITY_SETTINGS_FEEDBACK_LIST;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

- (void)requestSettingPush:(id)delegate parameters:(NSString *)parameters{
    NSString *url = [self getUrl];
    NSString *urlPara = parameters;
    NSString *methodName = SETTINGS_PUSH;
    WInterface interface = COMMUNITY_SETTINGS_PUSH;
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:interface byCallBackDelegate:delegate showLoad:NO];
}

@end
