//
//  HomeViewController.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-4.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "HomeViewController.h"
#import "NSObject_extra.h"
#import "Global.h"
#import "HomeAdDetailViewController.h"
#import "NoticeViewController.h"
#import "PhoneBookViewController.h"
#import "ASIWebServer.h"
#import "PropertyCenterViewController.h"
//#import "MainTabbarViewController.h"
#import "NeighborhoodBetweenViewController.h"
#import "LiveEncyclopediaViewController.h"
#import "JHTickerView.h"
#import "LoginViewController.h"
#import "LuckDrawViewController.h"
#import "CommunityHttpRequest.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"
#import "DMScrollingTicker.h"
#import "UserModel.h"
#import "MarqueeItemModel.h"
#import "NSObject+Time.h"
#import "UIViewController+NavigationBar.h"
#import "FunctionItem.h"
#import "CMBPNotification.h"
#import "DataBaseManager.h"
#import "UIView+Badge.h"
#import "AppConfig.h"
#import "MobClick.h"

@interface HomeViewController ()<WebServiceHelperDelegate>
@property (nonatomic, retain) CommunityHttpRequest *request;
@property (nonatomic, retain) DMScrollingTicker *scrollingTicker;
@property (nonatomic, retain) NSMutableArray *marqueeItems;
@property (nonatomic, retain) NSMutableArray *marqueeModels;
@property (nonatomic, retain) NSMutableArray *functionItems;
@property (nonatomic, retain) DataBaseManager *dbManager;

@end

@implementation HomeViewController
@synthesize request = _request;
@synthesize imageArray = _imageArray;
@synthesize scrollingTicker = _scrollingTicker;
@synthesize marqueeItems = _marqueeItems;
@synthesize image = _image;
@synthesize homeArray = _homeArray;
@synthesize page = _page;
@synthesize Topic = _Topic;
@synthesize homeAdDic = _homeAdDic;

-(void)dealloc{
    [_request cancelDelegate:self];
    [_marqueeModels release]; _marqueeModels = nil;
    [_marqueeItems release]; _marqueeItems = nil;
    [_imageArray release]; _imageArray = nil;
    [_homeArray release]; _homeArray = nil;
    [_homeAdDic release];
    [super dealloc];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];

    if ([self.marqueeModels count] > 0) {
        [self loadMarqueeViewAnimation];
    }
    [_Topic setupTimer];
    
    [self refreshUnReadNoticeCount];
    
    [MobClick beginLogPageView:@"HomePage"]; // 友盟统计
}

- (void)refreshUnReadNoticeCount{
    _dbManager = [DataBaseManager shareDBManeger];
    NSInteger integer = [_dbManager selectUnreadNotice];
    
    NSLog(@"%d",integer);
    FunctionItem *item = [self.functionItems objectAtIndex:0];
    if (integer == 0) {
        item.btnItem.badge.badgeValue = 0;
    }else{
        item.btnItem.badge.badgeValue = integer;
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    //暂停跑马灯
    [_scrollingTicker endAnimation:NO];
    
    //停止自己滚动的timer
    [_Topic releaseTimer];
    [MobClick endLogPageView:@"HomePage"];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _imageArray = [[NSMutableArray alloc]initWithCapacity:0];
        _homeArray = [[NSMutableArray alloc]initWithCapacity:0];
        _homeAdDic = [[NSMutableDictionary alloc]init];
        self.marqueeItems = [[NSMutableArray alloc] init];
        self.marqueeModels = [[NSMutableArray alloc] init];
        self.functionItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"首页";
    if (IOS7_OR_LATER) {
        //    滑动返回
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUnReadNoticeCount) name:kCMBPNotice object:nil];
    
    [self adjustiOS7NaviagtionBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UserModel *userModel = [UserModel shareUser];
    [self setNavigationTitle:userModel.communityName];
    
    [self signIn];//签到
    [self loadAdsScrollView]; //广告视图
    [self initMarquee]; //跑马灯
    [self lordHomeView];  //各个模块
    [self requestMarquee]; //跑马灯网络数据请求
    
    //缓存广告数据 add by devin
    if ([self getCacheUrlString:GlobalCommubityHomeAd]) {
        NSMutableDictionary *dic = (NSMutableDictionary *)[self getCacheDataDictionaryString:GlobalCommubityHomeAd];
        [_homeAdDic setDictionary:dic];
        [self refreshAds];
    }
    [self requestAds]; //请求网络广告数据

    //广告的pageController
    if (isIPhone5) {
        _page = [[UIPageControl alloc]initWithFrame:CGRectMake((ScreenWidth - pageSize.width)/2,240-64, pageSize.width,18)];
        [self.view addSubview:_page];
        [_page release];
    }else{
        _page = [[UIPageControl alloc]initWithFrame:CGRectMake((ScreenWidth - pageSize.width)/2,170-64, pageSize.width,18)];
        [self.view addSubview:_page];
        [_page release];
    }

}
- (BOOL)prefersStatusBarHidden{
    return NO;
}

//加载当前的签到
-(void)signIn{
    //  右边按钮 如果当前已经签到的话 一天以内不可以再进行签到 add vincent
    UIImage *rightImage = [UIImage imageNamed:@"icon_reports.png"];
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:rightImage forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(285,0,44,44);
    [self setRightBarButtonItem:rightBtn];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *date = [NSDate date];
    NSString *nowDateString = [dateFormatter stringFromDate:date];
    
    if ([nowDateString isEqualToString:[userDefault objectForKey:GlobalCommunitySignIn]]) {
        rightBtn.enabled = NO;
    }else{
        rightBtn.enabled = YES;
    }
}


/**
 *  网络请求广告
 */
- (void)requestAds{
    // 网络请求ß®
    if (_request == nil) {
        _request = [CommunityHttpRequest shareInstance];
    }
    
    UserModel *userModel = [UserModel shareUser];
    NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&adPositionKey=%@",USER_ID,userModel.userId,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,@"0"];
    [_request requestHomeAd:self parameters:parameters];
}

/**
 *  初始化跑马灯的视图
 */
- (void)initMarquee{
    //    下面的跑马灯
    UIImage *marqueeImage = [UIImage imageNamed:@"icon_home_radio.png"];
    marqueeView = [[UIView alloc] initWithFrame:CGRectMake(0, _Topic.frame.size.height+_Topic.frame.origin.y,ScreenWidth,40)];
    [marqueeView setBackgroundColor:RGB(242, 242, 242)];
    [marqueeView.layer setMasksToBounds:YES];
    [marqueeView.layer setBorderWidth:0.5]; //边框宽度
    marqueeView.layer.borderColor = RGB(220, 219, 226).CGColor;
    [self.view addSubview:marqueeView];
    [marqueeView release];
    
    UIImageView *marqueeImageView = [self newImageViewWithImage:marqueeImage frame:CGRectMake(8, 9, marqueeImage.size.width, marqueeImage.size.height)];
    marqueeImageView.userInteractionEnabled = YES;
    [marqueeView addSubview:marqueeImageView];
    [marqueeImageView release];
    
//    UIImage *lineImage = [UIImage imageNamed:@"bg_home_line.png"];
//    UIImageView *lineImageView = [self newImageViewWithImage:lineImage frame:CGRectMake(marqueeImageView.frame.size.height+marqueeImageView.frame.origin.x+8, 0, lineImage.size.width,marqueeImage.size.height+16)];
//    lineImageView.image = lineImage;
//    [marqueeView addSubview:lineImageView];
//    [lineImageView release];


}


- (void)loadMarqueeViewAnimation{
    [_scrollingTicker removeFromSuperview]; _scrollingTicker = nil;
    _scrollingTicker = [[DMScrollingTicker alloc] initWithFrame:CGRectMake(35, 11, 268,24)];
    [marqueeView addSubview:_scrollingTicker];
    [_scrollingTicker release];
    
    UIView *view = [[UIView alloc] initWithFrame:_scrollingTicker.bounds];
    [_scrollingTicker addSubview:view];
    [view release];
    
    UITapGestureRecognizer *tapHandle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
    [view addGestureRecognizer:tapHandle];
    [tapHandle release];
    
    [self refreshMarquee];
    
}

// 各个模块
-(void)lordHomeView{
    //    下面物业的各种类型
    NSArray *typeArray = [[NSArray alloc] initWithObjects:@"icon_home_notice.png",@"icon_home_property.png",@"icon_home_phone.png",@"icon_home_neighbor.png",@"icon_home_life.png",@"icon_home_community.png",@"icon_home_lucky.png",@"icon_home_integral.png",nil];
    NSArray *titleArray = [[NSArray alloc] initWithObjects:@"通知",@"物业中心",@"电话本",@"邻里之间",@"生活百科",@"小区商业",@"抽奖",@"积分兑换", nil];
    UIScrollView *contentScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, marqueeView.frame.size.height+marqueeView.frame.origin.y, ScreenWidth, 220)] ;
    contentScrollView.pagingEnabled = YES;
    contentScrollView.backgroundColor = RGB(250, 250, 250);
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.scrollsToTop = NO;
    [self.view addSubview:contentScrollView];
    [contentScrollView release];
    
    for (int i = 0; i<[typeArray count]; i++) {
        
        FunctionItem *item = [[FunctionItem alloc] initWithFrame:CGRectMake(10.5*(i%4+1)+67*(i%4), 11*(i/4+1)+86.5*(i/4), 67, 87)];
        [item.btnItem  setImage:[UIImage imageNamed:[typeArray objectAtIndex:i]] forState:UIControlStateNormal];
        [item.btnItem addTarget:self action:@selector(btnDetailAction:) forControlEvents:UIControlEventTouchUpInside];
        item.btnItem.tag = i;
        item.titleLabel.text = [titleArray objectAtIndex:i];
        [contentScrollView addSubview:item];
        [self.functionItems addObject:item];
        [item release];

    }
    contentScrollView.contentSize = CGSizeMake(ScreenWidth,220);
    
}

/**
 *  广告视图
 */
-(void)loadAdsScrollView{
    if (isIPhone5) {
        _Topic = [[JCTopic alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 400/2)];
        
    }else{
         _Topic = [[JCTopic alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 400/2-140/2)];
    }
    _Topic.JCdelegate = self;
    
    [self.view addSubview:_Topic];
    [_Topic release];
}
/**
 *  刷新广告
 */
- (void)refreshAds{
    if (_homeAdDic) {
        NSArray *array = [_homeAdDic objectForKey:@"adList"];
        if ([array count] == 0) {
            UIImage * image = [UIImage imageNamed:@"bg_sample_2.png"];
            [self.imageArray addObject:[NSDictionary dictionaryWithObjects:@[image ,@YES] forKeys:@[@"pic",@"isLoc"]]];
    }else{
        for (NSDictionary *dic in array) {
            HomeAdModel *model = [[HomeAdModel alloc]init];
            model.adResUrl = [dic objectForKey:@"resUrl"];
            model.adId = [dic objectForKey:@"id"];
            model.adShowType = [dic objectForKey:@"showType"];
            model.adActionType = [dic objectForKey:@"actionType"];
            model.adActionValue = [dic objectForKey:@"actionValue"];
            [self.imageArray addObject:[NSDictionary dictionaryWithObjects:@[model.adResUrl,@NO] forKeys:@[@"pic",@"isLoc"]]];
            [self.homeArray addObject:model];
            [model release];
        }}
    }else{
        //如果没有广告，则给张默认图片
        if ([self imageArray] == 0) {
            UIImage * image = [UIImage imageNamed:@"bg_sample_2.png"];
            [self.imageArray addObject:[NSDictionary dictionaryWithObjects:@[image ,@YES] forKeys:@[@"pic",@"isLoc"]]];
        }
    }
    _Topic.pics = self.imageArray;
    //更新
    [_Topic upDate];
}

//下面类型的进入
-(void)btnDetailAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSInteger buttonTag = button.tag;
    NSString *model = nil;
    switch (buttonTag) {
            //通知
        case 0:
        {
            NoticeViewController *noticeVc = [[NoticeViewController alloc] init];
            noticeVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:noticeVc animated:YES];
            [noticeVc release];
            model = @"通知";
        }
            break;
            //物业中心
        case 1:
        {
            PropertyCenterViewController *proCenterVc = [[PropertyCenterViewController alloc]init];
            proCenterVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:proCenterVc animated:YES];
            [proCenterVc release];
            model = @"物业中心";
        }
            break;
            //电话本
        case 2:
        {
            PhoneBookViewController *phoneBookVc = [[PhoneBookViewController alloc] init];
            phoneBookVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:phoneBookVc animated:YES];
            [phoneBookVc release];
            model = @"电话本";
        }
            break;
            //邻里之间
        case 3:
        {
            NeighborhoodBetweenViewController *neighborhoodBetweenVc = [[NeighborhoodBetweenViewController alloc]init];
            neighborhoodBetweenVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:neighborhoodBetweenVc animated:YES];
            [neighborhoodBetweenVc release];
            model = @"邻里之间";
        }
            break;
            //生活百科
        case 4:
        {
            LiveEncyclopediaViewController *liveEncyclopediaVc = [[LiveEncyclopediaViewController alloc]init];
             liveEncyclopediaVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:liveEncyclopediaVc animated:YES];
            [liveEncyclopediaVc release];
            model = @"生活百科";
        }
            break;
            //小区物业
        case 5:
        {
            [Global showMBProgressHudHint:self SuperView:self.view Msg:@"敬请期待" ShowTime:1.0];
//            LuckDrawViewController *luckDrawVc = [[LuckDrawViewController alloc] init];
//            luckDrawVc.hidesBottomBarWhenPushed = YES;
////            MainTabbarViewController *tabBarController = (MainTabbarViewController *)self.tabBarController;
////            [tabBarController hideNewTabBar];
//            [self.navigationController pushViewController:luckDrawVc animated:YES];
//            [luckDrawVc release];
            model = @"小区物业";
        }
            break;
            //抽奖
        case 6:
        {
            
            LuckDrawViewController *luckDrawVc = [[LuckDrawViewController alloc] init];
            luckDrawVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:luckDrawVc animated:YES];
            [luckDrawVc release];
            model = @"抽奖";
            
        }
            break;
            //积分兑换
        case 7:
        {
            [Global showMBProgressHudHint:self SuperView:self.view Msg:@"敬请期待" ShowTime:1.0];
            model = @"积分兑换";
        }
            break;
        default:
            break;
    }
    [MobClick event:@"HomeView_Category" label:model];
}

//右边按钮
-(void)rightBtnAction{
    // 网络请求ß®
    if (_request == nil) {
        _request = [CommunityHttpRequest shareInstance];
    }
    
    UserModel *userModel = [UserModel shareUser];
    NSString *parameters = [NSString stringWithFormat:@"?userId=%@&communityId=%@&propertyId=%@",userModel.userId,userModel.communityId,userModel.propertyId];
    [_request requestSignIn:self parameters:parameters];

}
-(void)didClick:(int)index{
    if ([self.homeArray count]!=0) {
        HomeAdModel *model = [self.homeArray objectAtIndex:index-1];
        HomeAdDetailViewController *adDetailVc = [[HomeAdDetailViewController alloc] init];
        adDetailVc.adModel = model;
        adDetailVc.hidesBottomBarWhenPushed = YES;
        
        [MobClick event:@"HomeAd_Click"];
        
        [self.navigationController pushViewController:adDetailVc animated:YES];
        [adDetailVc release];
    }else{
        NSLog(@"没有广告数据数据");
    }
   
}
-(void)currentPage:(int)page total:(NSUInteger)total{
    _page.numberOfPages = total;
    _page.currentPage = page;
    pageSize = [_page sizeForNumberOfPages:total];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapHandle:(UITapGestureRecognizer *)sender{
    NoticeViewController *noticeVc = [[NoticeViewController alloc] init];
//    MainTabbarViewController *tabBarController = (MainTabbarViewController *)self.tabBarController;
//    [tabBarController hideNewTabBar];
    noticeVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:noticeVc animated:YES];
    [noticeVc release];
}

/**
 *  刷新跑马灯
 */
- (void)refreshMarquee{

    [self.marqueeItems removeAllObjects];
    for (NSUInteger k = 0; k < [self.marqueeModels count]; k++) {
        MarqueeItemModel *model = [self.marqueeModels objectAtIndex:k];
        
        LPScrollingTickerLabelItem *label = [[LPScrollingTickerLabelItem alloc] initWithTitle:model.title
                                                                                  description:nil];
        [label layoutSubviews];
        //[sizes addObject:[NSValue valueWithCGSize:label.frame.size]];
        
        [self.marqueeItems addObject:label];
    }
    
    [_scrollingTicker beginAnimationWithViews:self.marqueeItems
                                    direction:LPScrollingDirection_FromRight
                                        speed:40
                                        loops:0
                                 completition:^(NSUInteger loopsDone, BOOL isFinished) {
                                     //NSLog(@"loop %d, finished? %d",loopsDone,isFinished);
                                 }];
}

- (void)scrollTickerBeginAnimation{

}

#pragma mark ---marquee
/**
 *  请求跑马灯
 */
- (void)requestMarquee{
    if (_request == nil) {
        _request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&locationId=6",USER_ID,userModel.userId,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId];//参数
    NSLog(@"parameters %@",parameters);
    [_request requestMarquee:self parameters:parameters];
}

#pragma mark ---network

- (void)callBackWith:(WInterface)interface status:(NSString *)status data:(id)data{
    if (interface == COMMUNITY_MARQUEE_INFO) {  //如果是跑马灯
        [self.marqueeModels removeAllObjects];
        
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
                NSArray *array = [data objectForKey:@"marqueeList"];
                for (NSDictionary *dic in array) {
                    MarqueeItemModel *model = [[[MarqueeItemModel alloc] init] autorelease];
                    model.title = [dic objectForKey:@"title"];
                    model.moduleTypeId = [dic objectForKey:@"moduleTypeId"];
                    model.itemId = [dic objectForKey:@"id"];
                    [self.marqueeModels  addObject:model];
                }
                [self loadMarqueeViewAnimation];
            }else{
                
            }
        
    }else if (interface == COMMUNITY_HOME_AD) { //若果是广告数据
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            [self.imageArray removeAllObjects];
            _homeAdDic = [data retain];
           [self saveCacheUrlString:GlobalCommubityHomeAd andNSDictionary:_homeAdDic];//缓存广告数据
           [self refreshAds];//刷新广告数据
           
        }else{
            NSLog(@"首页网络广告数据加载失败");
        }
    }else if (interface == COMMENT_REGISTRATION_ADD){ //如果是签到数据
        NSLog(@"data %@",data);
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]){
            rightBtn.enabled = NO;
            if ([[data objectForKey:@"pointContent"] length]!=0) {
                //   保存当前的数据是否已经签到 add vincent
                NSDate *nowDate = [NSDate new];
                NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
                [dateFormatter setDateFormat:@"yyyy/MM/dd"];
                NSString *nowDateString = [dateFormatter stringFromDate:nowDate];
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setObject:nowDateString forKey:GlobalCommunitySignIn];
                [userDefault synchronize];
            }else{
                if([data objectForKey:@"errorMsg"]){
                    [Global showMBProgressHudHint:self SuperView:self.view Msg:[data objectForKey:@"errorMsg"] ShowTime:1.0];
                }
                
            }
        }else{
            if ([data objectForKey:@"errorMsg"]) {
                [Global showMBProgressHudHint:self SuperView:self.view Msg:[data objectForKey:@"errorMsg"] ShowTime:1.0];
            }
            
        }
    }
}

@end
