//
//  AppDelegate.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-4.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "AppDelegate.h"
#import "VincentNavigationController.h"
#import "HomeViewController.h"
#import "MySelfViewController.h"
#import "NeighborhoodViewController.h"
#import "ConvenienceViewController.h"
#import "APIKey.h"
#import <MAMapKit/MAMapKit.h>
#import "ASIWebServer.h"
#import "GeocodeAnnotation.h"
#import "NSObject_extra.h"
#import "DataBaseManager.h"
#import "LoginViewController.h"
#import "UserModel.h"
#import "NSFileManager+Community.h"
#import "WXApi.h"
#import "WelcomeViewController.h"
#import "FriendAndGroupListModel.h"
#import "BPush.h"
#import "FriendUserInformationModel.h"
#import "UIDeviceHardware.h"
#import "NSString+Base64.h"
#import "NSData+Base64.h"
#import "XmppMessageListModel.h"
#import "CMBPNotification.h"
#import "FriendListDetailInfromation.h"
#import "UIImage+extra.h"
#import "GroupUserListModel.h"
#import "NeighboorHoodFriendList.h"
#import "UpdateTimeModel.h"
#import "MobClick.h"
//im
#import "ChatTcpHelper.h"
#import "TcpRequestHelper.h"

@interface AppDelegate ()

@property (nonatomic, retain) NSString *channelId;
@property (nonatomic, retain) NSString *subscriberId;

@end


@implementation AppDelegate
@synthesize search  = _search;
@synthesize request;
@synthesize introduceInfo;
@synthesize updateDictionary;

@synthesize areaString;
@synthesize areaIdString;
@synthesize tabBarController = _tabBarController;


- (void)initSharePlatform{
    
    [ShareSDK registerApp:SHARESDK_KEY];
    
    //添加微信和朋友圈的应用
    [ShareSDK connectWeChatSessionWithAppId:WEIXIN_API_KEY wechatCls:[WXApi class]];
    [ShareSDK connectWeChatTimelineWithAppId:WEIXIN_API_KEY wechatCls:[WXApi class]];
    
    //添加新浪微博的应用
    [ShareSDK connectSinaWeiboWithAppKey:SINA_WEIBO_API_KEY
                               appSecret:SINA_WEIBO_API_SECRET
                             redirectUri:SINA_WEIBO_REDIRECT_URL];
    
    //添加腾讯微博的应用
    [ShareSDK connectTencentWeiboWithAppKey:TENCENT_WEIBO_API_KEY
                                  appSecret:TENCENT_WEIBO_API_SECRET
                                redirectUri:TENCENT_WEIBO_REDIRECT_URI];
    
    [ShareSDK ssoEnabled:NO];
    
    [ShareSDK connectSMS];
    
    [ShareSDK connectMail];
    
    [ShareSDK connectCopy];
}

//add vincent 内存释放
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [loginVc release];
    [super dealloc];
}
//异常处理 //add vincent
void UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *urlStr = [NSString stringWithFormat:@"mailto:vincent@yunlai.cn?subject=bug报告&body=感谢您的配合!<br><br><br>"
                        "错误详情:<br>%@<br>--------------------------<br>%@<br>---------------------<br>%@",
                        name,reason,[arr componentsJoinedByString:@"<br>"]];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
    
    //或者直接用代码，输入这个崩溃信息，以便在console中进一步分析错误原因
    
    NSLog(@"vincent, CRASH: %@", exception);
    
    NSLog(@"vincent, Stack Trace: %@", [exception callStackSymbols]);
}

//配置apiKey
- (void)configureAPIKey
{
    if ([APIKey length] == 0)
    {
        NSString *name   = [NSString stringWithFormat:@"\nSDKVersion:%@\nFILE:%s\nLINE:%d\nMETHOD:%s", [MAMapServices sharedServices].SDKVersion, __FILE__, __LINE__, __func__];
        NSString *reason = [NSString stringWithFormat:@"请首先配置APIKey.h中的APIKey, 申请APIKey参考见 http://api.amap.com"];
        
        @throw [NSException exceptionWithName:name
                                       reason:reason
                                     userInfo:nil];
    }
    
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
}

- (void)umengTrack {
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:COUNT_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
//    Class cls = NSClassFromString(@"UMANUtil");
//    SEL deviceIDSelector = @selector(openUDIDString);
//    NSString *deviceID = nil;
//    if(cls && [cls respondsToSelector:deviceIDSelector]){
//        deviceID = [cls performSelector:deviceIDSelector];
//    }
//    NSLog(@"{\"oid\": \"%@\"}", deviceID);
    
    
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIApplication *myApp = [UIApplication sharedApplication];
    [myApp setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    if (IOS7_OR_LATER) {
        [application setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    }
    
    [self apperaranceControl];
    
    [self initSharePlatform];
//    配置当前的地图
     [self configureAPIKey];
    
    //异常捕获
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    dbManager = [DataBaseManager shareDBManeger];
    [dbManager openDatabase];
    
    [self cleanTmpFiles];
    
    UserModel *userModel = [UserModel shareUser];
    //[userModel getUserInfo];
    if (userModel.userName.length && userModel.userId.length && userModel.token.length) {
        [self initWelcomePage];
    }else{
        loginVc = [[LoginViewController alloc]init];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVc];
        self.window.rootViewController = loginNav;
        [loginNav release];
    }
    
    //注册百度云通知服务
    [BPush setupChannel:launchOptions];
    [BPush setDelegate:self];
    [application setApplicationIconBadgeNumber:0];
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeAlert
     | UIRemoteNotificationTypeBadge
     | UIRemoteNotificationTypeSound];
    
    //    检查更新
    [self performSelector:@selector(retquestUpdateCheck) withObject:nil afterDelay:3.0];
    
    //友盟统计的方法本身是异步执行，所以不需要再异步调用
    [self umengTrack];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)apperaranceControl{
    
    if (IOS7_OR_LATER) {
        
    }else{
        UIColor *navigationBarColor = [UIColor colorWithRed:87.0f/255.0 green:182.0/255.0f blue:16.0/255 alpha:1.0];
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:navigationBarColor size:CGSizeMake(320, 44)]
                                           forBarMetrics:UIBarMetricsDefault];
        
        if(!IOS7_OR_LATER){
            //iOS6
            
            UIColor *normalColor = [UIColor colorWithRed:87.0f/255.0 green:182.0/255.0f blue:16.0/255 alpha:1.0];
            UIColor *selectedColor = [UIColor whiteColor];
            [[UISegmentedControl appearance] setBackgroundImage:[UIImage imageWithColor:selectedColor size:CGSizeMake(1, 29)]
                                                       forState:UIControlStateSelected
                                                     barMetrics:UIBarMetricsDefault];
            
            [[UISegmentedControl appearance] setBackgroundImage:[UIImage imageWithColor:normalColor size:CGSizeMake(1, 29)]
                                                       forState:UIControlStateNormal
                                                     barMetrics:UIBarMetricsDefault];
            
            [[UISegmentedControl appearance] setDividerImage:[UIImage imageWithColor:selectedColor size:CGSizeMake(1, 1)]
                                         forLeftSegmentState:UIControlStateNormal
                                           rightSegmentState:UIControlStateSelected
                                                  barMetrics:UIBarMetricsDefault];
            
            [[UISegmentedControl appearance] setTitleTextAttributes:@{
                                                                      UITextAttributeTextColor: selectedColor,
                                                                      UITextAttributeFont: [UIFont systemFontOfSize:14],
                                                                      UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)] }
                                                           forState:UIControlStateNormal];
            
            [[UISegmentedControl appearance] setTitleTextAttributes:@{
                                                                      UITextAttributeTextColor: normalColor,
                                                                      UITextAttributeFont: [UIFont systemFontOfSize:14],
                                                                      UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)]}
                                                           forState:UIControlStateSelected];
        }
        
    }
}

//请求分组列表
-(void)requestGruopList{
    if (request == nil) {
        request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    NSString *string = [NSString stringWithFormat:@"%@",userModel.communityId];//];//参数
    [request requestGroupList:self parameters:string];
}

//请求邻居列表
-(void)requestFriendList{
    if (request == nil) {
        request = [CommunityHttpRequest shareInstance];
    }
/*  实例：192.168.1.9/i/v1/roster/list/3?ts=0&pageNumber=1
    当ts时间戳为0的时候表示全部，第一次登陆的时候需要取全部的数据，
    pageNumber是当前的页码（如果返回的总页数pages大约1的话，需要分页去读取）
 */
    dbManager = [DataBaseManager shareDBManeger];
    UpdateTimeModel *model = [dbManager selectUpdateTimeByInterface:COMMUNITY_FRIENDS_LIST];
    UserModel *userModel = [UserModel shareUser];
    NSString *string = [NSString stringWithFormat:@"%@?ts=%@&pageNumber=%@",userModel.communityId,model.date,@"1"];//参数
    [request requestFriendNeighborhoodList:self parameters:string];
}

//登录成功的回调函数
-(void)loadAnimationEndedCallback:(NSDictionary *)dictionary{
    
    [self loginImServer]; //登陆im服务器

    [self initSearch]; //    当前小区地址的请求
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([self getCacheUrlString:GlobalCommunityAddress]) {
        if (![userDefault objectForKey:GlobalCommunityLatitude]||![userDefault objectForKey:GlobalCommunityLongitude]){
            
            //    反解析当前的地址
            [self searchGeocodeWithKey:[[self getCacheDataDictionaryString:GlobalCommunityAddress] objectForKey:@"address"]];
        }
    }else{
        [self requestAddress];//请求当前的地址
    }
    
    //    首页
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    UITabBarItem *homeBatItem = [[UITabBarItem alloc] init];
    homeBatItem.title =  @"首页";
    homeViewController.tabBarItem = homeBatItem;
    [homeBatItem release];
    [homeViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"icon_home_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"icon_home.png"]];
    UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    [homeViewController release];
    
    //便民
    ConvenienceViewController *convenienceViewController = [[ConvenienceViewController alloc] init];
    UITabBarItem *convenienceItem = [[UITabBarItem alloc] init];
    convenienceItem.title = @"便民";
    convenienceViewController.tabBarItem = convenienceItem;
    [convenienceItem release];
    [convenienceViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"icon_convenient_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"icon_convenient.png"]];
    UINavigationController *convenienceNavigationController = [[UINavigationController alloc] initWithRootViewController:convenienceViewController];
    [convenienceViewController release];
    
    //邻居
    NeighborhoodViewController *neighborhoodViewController = [[NeighborhoodViewController alloc] init];
    UITabBarItem *neighborhoodItem = [[UITabBarItem alloc] init];
    neighborhoodItem.title = @"邻居";
    neighborhoodViewController.tabBarItem = neighborhoodItem;
    [neighborhoodItem release];
    [neighborhoodViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"icon_collective_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"icon_collective.png"]];
    UINavigationController *negihborhoodNavigationController = [[UINavigationController alloc] initWithRootViewController:neighborhoodViewController];
    [neighborhoodViewController release];
    
    MySelfViewController *myselfViewController = [[MySelfViewController alloc] init];//我的
    UITabBarItem *mySelfItem = [[UITabBarItem alloc] init];
    mySelfItem.title = @"我";
    myselfViewController.tabBarItem = mySelfItem;
    [mySelfItem release];
    [myselfViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"icon_my_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"icon_my.png"]];
    UINavigationController *myselfNavigationController = [[UINavigationController alloc] initWithRootViewController:myselfViewController];
    [myselfViewController release];
    
    //    tabbar
    _tabBarController = [[UITabBarController alloc] init];
    [_tabBarController setViewControllers:[NSArray arrayWithObjects:homeNavigationController,
                                            convenienceNavigationController,negihborhoodNavigationController,
                                          myselfNavigationController, nil]];
    [homeNavigationController release];
    [convenienceNavigationController release];
    [negihborhoodNavigationController release];
    [myselfNavigationController release];
    
    if (!IOS7_OR_LATER) {
        [[UITabBar appearance] setSelectionIndicatorImage:[[UIImage alloc] init]];
        [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"bg49"]];

    }else{
        [[UITabBar appearance] setBarTintColor:RGB(255, 255, 255)];
    }
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(144, 149, 170), UITextAttributeTextColor,[UIFont systemFontOfSize:10],UITextAttributeFont,nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(87, 182, 16), UITextAttributeTextColor,[UIFont systemFontOfSize:10],UITextAttributeFont,nil] forState:UIControlStateSelected];
    
    [self setNeighboorBadge];

    self.window.rootViewController = _tabBarController;
    [_tabBarController release];//add vincent 内存释放
    
}

//登陆im的服务器
-(void)loginImServer{
    //tcp连接服务器
    BOOL isConnected = [[ChatTcpHelper shareChatTcpHelper] connectToHost];
    //tcp登录
    if (isConnected) {
        [[TcpRequestHelper shareTcpRequestHelperHelper] sendLogingPackageCommandId:COMMUNITY_TCP_LOGIN_COMMAND_ID];
    }
}

- (void)initWelcomePage{
    WelcomeViewController *welcome = [[[WelcomeViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    self.window.rootViewController = welcome;

}

//退出登陆
-(void)seafQuitOutLogin{
    if (loginVc) {
		[loginVc.view removeFromSuperview];
		[loginVc release];
		loginVc = nil;
	}
	
    loginVc = [[LoginViewController alloc]init];
    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVc];
    self.window.rootViewController = loginNav;
    [loginNav release];
}

//请求当前的地址
-(void)requestAddress{
    if (request == nil) {
        request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    NSString *string = [NSString stringWithFormat:@"?userId=%@&communityId=%@&propertyId=%@",userModel.userId,userModel.communityId,userModel.propertyId];//参数
    [request requestAddress:self parameters:string];
}

/* 初始化search. */
- (void)initSearch
{
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:nil];
    self.search.delegate = self;
}
#pragma mark - AMapSearchDelegate
- (void)search:(id)searchRequest error:(NSString *)errInfo
{
    NSLog(@"%s: searchRequest = %@, errInfo= %@", __func__, [searchRequest class], errInfo);
}

/* 地理编码 搜索. */
- (void)searchGeocodeWithKey:(NSString *)key
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = key;
    
    [self.search AMapGeocodeSearch:geo];
    [geo release];//add vincent 内存释放
}

#pragma mark - AMapSearchDelegate

/* 地理编码回调.*/
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count == 0)
    {
        return;
    }
    NSMutableArray  *geocodeAnnotationArray = [NSMutableArray array];
    [response.geocodes enumerateObjectsUsingBlock:^(AMapGeocode *obj, NSUInteger idx, BOOL *stop) {
        GeocodeAnnotation *geocodeAnnotation = [[GeocodeAnnotation alloc] initWithGeocode:obj];
        [geocodeAnnotationArray addObject:geocodeAnnotation];
        [geocodeAnnotation release];
    }];
    
    GeocodeAnnotation *annotation = [geocodeAnnotationArray objectAtIndex:0];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *latitudeString = [NSString stringWithFormat:@"%f",annotation.coordinate.latitude];
    NSString *longitudeString = [NSString stringWithFormat:@"%f",annotation.coordinate.longitude];
    [userDefault setObject:latitudeString forKey:GlobalCommunityLatitude];
    [userDefault setObject:longitudeString forKey:GlobalCommunityLongitude];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // NSLog(@"test:%@",deviceToken);
    [BPush registerDeviceToken: deviceToken];
    [BPush bindChannel]; // 必须。可以在其它时机调用，只有在该方法返回（通过onMethod:response:回调）绑定成功时，app才能接收到Push消息。一个app绑定成功至少一次即可（如果access token变更请重新绑定）。
}

// 必须，如果正确调用了setDelegate，在bindChannel之后，结果在这个回调中返回。
// 若绑定失败，请进行重新绑定，确保至少绑定成功一次
- (void) onMethod:(NSString*)method response:(NSDictionary*)data
{
    if ([BPushRequestMethod_Bind isEqualToString:method])
    {
        NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
        
        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
        
        self.subscriberId = userid;
        self.channelId = channelid;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveLoginSucceedNotification:) name:kCommunityLoginSucceedNotification object:nil];
        NSLog(@"%@",res);

    }
}

- (void)didRecieveLoginSucceedNotification:(NSNotification *)notice{
    if ([UserModel isLogin] && self.subscriberId && self.channelId) {
        [self subscriberMsgId:self.subscriberId channelId:self.channelId];
    }
}

//数据上报
- (void)subscriberMsgId:(NSString *)subscriberId channelId:(NSString *)channelId{
    
    if (request == nil) {
        request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    //手机型号
    NSString* phoneModel = [[UIDevice currentDevice] model];
    NSLog(@"手机型号: %@",phoneModel );
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本: %@", phoneVersion);
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    // 当前应用版本号码   int类型
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
    NSString *cellularProviderName = [NSObject getCellularProviderName];
    //设备类型   1：浏览器设备；2：PC设备；3：Andriod设备；4：iOS设备；5：Windows Phone
    NSString *string = [NSString stringWithFormat:@"?propertyId=%@&communityId=%@&userId=%@&subscriberId=%@&channelId=%@&deviceName=4&phoneModel=%@&osVersion= %@&appVersion=%@&operators=%@",userModel.propertyId,userModel.communityId,userModel.userId,subscriberId,channelId,phoneModel,phoneVersion,appCurVersionNum,cellularProviderName];//参数
    [request requestSubscribe:self parmaeters:string];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Receive Notify: %@", [userInfo JSONString]);
    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    if (application.applicationState == UIApplicationStateActive) {
        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
        /*
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Did receive a Remote Notification"
                                                            message:[NSString stringWithFormat:@"The application received this remote notification while it was running:\n%@", alert]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
         */
    }
    [application setApplicationIconBadgeNumber:0];
    
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [BPush handleNotification:userInfo];
    
    NSString *action = [userInfo objectForKey:@"action"];
    
    [self requestPushNotification:action];
}


- (void)requestPushNotification:(NSString *)strAction{
    
    if ([strAction isEqualToString:@"NOTICE"]) {
        [[CMBPNotification shareInstance] requestCommunityNotification];
    }else if ([strAction isEqualToString:@"COMMNET"]){
        [[CMBPNotification shareInstance] requestMyComments];
    }else if ([strAction isEqualToString:@"BILL"]){
        [[CMBPNotification shareInstance] requestMyBills];
    }else if ([strAction isEqualToString:@"RULE"]){
        [[CMBPNotification shareInstance] requestRuleRegulations];
    }
}

//   当前消息列表中有多少数据未读
- (void)setNeighboorBadge{
//    DataBaseManager *dbManager = [DataBaseManager shareDBManeger];
    UIViewController *badgeValueController = [self.tabBarController.viewControllers objectAtIndex:2];
    NSInteger unReadMessageCount = [dbManager selectUnReadMessageList];
    if (unReadMessageCount == 0) {
        badgeValueController.tabBarItem.badgeValue = nil;
    }else if(unReadMessageCount<=99){
        badgeValueController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[dbManager selectUnReadMessageList]];
    }else{
        badgeValueController.tabBarItem.badgeValue = @"99+";
    }
}

- (void)setMySelfBadge:(NSString *)badge{
    UINavigationController *nav = [self.tabBarController.viewControllers count] > 3 ? [self.tabBarController.viewControllers objectAtIndex:3] : nil;
    
    nav.topViewController.tabBarItem.badgeValue = @"";
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    if ([UserModel isLogin]) {
        [[CMBPNotification shareInstance] applicationLaunchNotification];
    }
    
    //tcp连接服务器
    BOOL isConnected = [[ChatTcpHelper shareChatTcpHelper] connectToHost];
    //tcp登录
    if (isConnected) {
        [[TcpRequestHelper shareTcpRequestHelperHelper] sendLogingPackageCommandId:COMMUNITY_TCP_LOGIN_COMMAND_ID];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark ------ 请求回调
-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    if (interface == COMMINITY_ADDRESS_INFO) {//当前的地址
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            introduceInfo = [data retain];
            
            [self saveCacheUrlString:GlobalCommunityAddress andNSDictionary:introduceInfo];
            //    反解析当前的地址
            [self searchGeocodeWithKey:[introduceInfo objectForKey:@"address"]];
        }
    }else if(interface == COMMUNITY_VERSION_UPDATE_URL) {//版本升级
            introduceInfo = [data retain];
            self.updateDictionary = introduceInfo;
            [self updateCheck];
    }else if (interface == COMMUNITY_SUBSCRIBER_MSG){//数据上报
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            NSLog(@"数据上报成功");
        }
    }else  if (interface == COMMUNITY_GROUP_LIST) {//群主列表
        NSString *code = [data objectForKey:ERROR_CODE];
        if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {            
            NSArray *array = [data objectForKey:@"groups"];
            for (NSDictionary *dic in array) {
                GroupUserListModel  *model = [[[GroupUserListModel alloc]init] autorelease];
                model.groupIdString = [dic objectForKey:@"groupId"];
                model.groupNameString = [dic objectForKey:@"groupName"];
                model.orderIndexString = [dic objectForKey:@"orderIndex"];
                
                //插入数据
                BOOL flag = [dbManager insertGroupList:model];
                if (flag) {
                    NSLog(@"插入群主成功");
                }
            }
        }
    }else if (interface == COMMUNITY_FRIENDS_LIST){
        NSString *code = [data objectForKey:ERROR_CODE];
        if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]){
            NSArray *array = [[data objectForKey:@"rosters"] objectForKey:@"result"];
            
            UpdateTimeModel *updateModel = [[UpdateTimeModel alloc] init];
            updateModel.type = [NSString stringWithFormat:@"%d",COMMUNITY_FRIENDS_LIST];
            updateModel.date = [data objectForKey:@"ts"];
            dbManager = [DataBaseManager shareDBManeger];
            BOOL flag = [dbManager insertRequestUpdateTime:updateModel];
            if (flag) {
                NSLog(@"COMMUNITY_NOTICE_INFO 插入更新时间成功");
            }
            [updateModel release];
            for (NSDictionary *dic in array) {
                NeighboorHoodFriendList *infromationModel = [[NeighboorHoodFriendList alloc] init];
                infromationModel.userIdString = [dic objectForKey:@"userId"];
                infromationModel.usernameString = [dic objectForKey:@"username"];
                infromationModel.nicknameString = [dic objectForKey:@"nickname"];
                infromationModel.avatarString = [dic objectForKey:@"avatar"];
                infromationModel.genderString = [dic objectForKey:@"gender"];
                infromationModel.tsString = [dic objectForKey:@"ts"];
                infromationModel.groupIdString = [dic objectForKey:@"groupId"];
                infromationModel.userTypeString  = [dic objectForKey:@"userType"];
                infromationModel.updateTimeString = [dic objectForKey:@"updateTime"];
                infromationModel.enabledString = [dic objectForKey:@"enabled"];
                infromationModel.statusString = [dic objectForKey:@"status"];
                infromationModel.isDelString = [dic objectForKey:@"isDel"];
                infromationModel.signatureString = [dic objectForKey:@"signature"];
                
                //插入数据
                BOOL flag = [dbManager insertNeighboorHoodFriendList:infromationModel];
                if (flag) {
                    NSLog(@"插入邻居列表成功");
                }
            }
        }
    }
}


+ (AppDelegate *)instance {
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (id)init {
	self = [super init];
    if (self) {
        _dpapi = [[DPAPI alloc] init];
		_dpapiAppKey = [[NSUserDefaults standardUserDefaults] valueForKey:@"appkey"];
		if (_dpapiAppKey.length<1) {
			_dpapiAppKey = kDPAppKey;
		}
		_dpapiAppSecret = [[NSUserDefaults standardUserDefaults] valueForKey:@"appsecret"];
		if (_dpapiAppSecret.length<1) {
			_dpapiAppSecret = kDPAppSecret;
		}
    }
    return self;
}

- (void)setAppKey:(NSString *)appKey {
	_dpapiAppKey = appKey;
	[[NSUserDefaults standardUserDefaults] setValue:appKey forKey:@"appkey"];
}

- (void)setAppSecret:(NSString *)appSecret {
	_dpapiAppSecret = appSecret;
	[[NSUserDefaults standardUserDefaults] setValue:appSecret forKey:@"appsecret"];
}

//检查更新
- (void)retquestUpdateCheck{
    if (request == nil) {
        request = [CommunityHttpRequest shareInstance];
    }
    NSString *string = [NSString stringWithFormat:@"?type=iOS"];//参数
    [request requestVersionUpdate:self parameters:string];

}

//升级的判断
- (void)updateCheck{
    //应用的版本
    NSString* currentString = [self subVersionString:[self getVersionString]];
    // 最低的版本
    NSString *oldString = [self subVersionString:[self.updateDictionary objectForKey:@"minVersion"]];
    //  最新的版本
    NSString *newString = [self subVersionString:[self.updateDictionary objectForKey:@"maxVersion"]];
    
    //  转换为int的类型 方便比较
    int oldCurrentInt = [oldString intValue];
    int newCurrentInt = [newString intValue];
    int currentInt = [currentString intValue];
    
    //   当前的小于最低的版本
    if (currentInt<oldCurrentInt) {
        
        UIAlertView *paAlertView = [[UIAlertView alloc] initWithTitle:[self.updateDictionary objectForKey:@"name"] message:@"你的版本过低，请升级！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"退出", nil];
        [paAlertView show];
        paAlertView.tag = 233333;
        [paAlertView release];
        
    }else if(oldCurrentInt <=currentInt && currentInt<newCurrentInt)//当前的版本在最低和最高之间
    {
        UIAlertView *paAlertView = [[UIAlertView alloc] initWithTitle:[self.updateDictionary objectForKey:@"name"] message:[self.updateDictionary objectForKey:@"description"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [paAlertView show];
        paAlertView.tag = 233334;
        [paAlertView release];
        
    }
}
#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 233333) {
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.updateDictionary objectForKey:@"address"]]];
        }else {
            exit(0);
        }
    } else if(alertView.tag == 233334){
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.updateDictionary objectForKey:@"address"]]];
        }
    }
}

- (void)cleanTmpFiles{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [fileManager applicationTemporaryDirectory];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:filePath error:NULL];
    NSEnumerator *enumerator = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [enumerator nextObject])) {
        
        [fileManager removeItemAtPath:[filePath stringByAppendingPathComponent:filename]
                                error:NULL];
    }
}

#pragma mark ---WeChate Delegate

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

#pragma mark --------- MBProgressMethod ---------
-(void)createProgressView{
    _mbProgressView = [[MBProgressHUD alloc] initWithView:_window];
    _mbProgressView.delegate =self;
    [_window addSubview:_mbProgressView];
    [_mbProgressView release];
    [_mbProgressView show:YES];
}

-(void)hideProgressViewForType:(ProgressViewHiddenType)type message:(NSString *)message afterDelay:(NSTimeInterval)delay{
    if (type == none) {
        if (_mbProgressView) {
            [_mbProgressView hide:YES];
        }
        return;
    }
    if (!_mbProgressView) {
        [self createProgressView];
    }
    
    switch (type) {
        case  success:
            _mbProgressView.customView = [[[UIImageView alloc] initWithImage:
                                           [UIImage imageNamed:@""]]autorelease];
            break;
        case failed:
            _mbProgressView.customView = [[[UIImageView alloc] initWithImage:
                                           [UIImage imageNamed:@""]]autorelease];
            break;
        case notification:{
            NSString :
            _mbProgressView.customView = [[[UIImageView alloc] initWithImage:
                                           [UIImage imageNamed:@""]]autorelease];
        }
            break;
        case collect:{
            NSString *imageName;
            if ([message isEqualToString:@"收藏成功"]) {
                imageName = @"Notification_collect_done.png";
            }else{
                imageName = @"Notification_collect_cancel.png";
            }
            _mbProgressView.customView = [[[UIImageView alloc] initWithImage:
                                           [UIImage imageNamed:imageName]]autorelease];
        }
            break;
        default:
            break;
    }
    
    _mbProgressView.mode = MBProgressHUDModeCustomView;
    _mbProgressView.labelText = message;
    [_mbProgressView hide:YES afterDelay:delay];
}

-(void)showLoadingProgressViewWithText:(NSString *)string{
    if (!_mbProgressView) {
        [self createProgressView];
    }else{
        [_mbProgressView hide:NO];
        [self createProgressView];
    }
    
    _mbProgressView.labelText = string;
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [_mbProgressView removeFromSuperview];
	_mbProgressView = nil;
}

@end
