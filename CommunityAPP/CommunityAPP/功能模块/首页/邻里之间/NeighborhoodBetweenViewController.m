//
//  NeighborhoodBetweenViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-7.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "NeighborhoodBetweenViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "CarPoolingViewController.h"
#import "NeighborhoodHelpViewController.h"
#import "ConvenientSellViewController.h"
#import "CommunityHttpRequest.h"
#import "UserModel.h"
#import "HomeAdModel.h"
#import "UIImageView+WebCache.h"
#import "NeighborhoodDetailViewController.h"
#import "UIViewController+NavigationBar.h"
#import "MobClick.h"

@interface NeighborhoodBetweenViewController ()
@property (nonatomic, retain) CommunityHttpRequest *request;

@end

@implementation NeighborhoodBetweenViewController
@synthesize request = _request;
@synthesize imageArray = _imageArray;
@synthesize image = _image;
@synthesize homeArray = _homeArray;
@synthesize page = _page;
@synthesize Topic = _Topic;
@synthesize neighborhoodAdDic = _neighborhoodAdDic;

-(void)dealloc{
    _Topic.delegate = nil;
    [_request cancelDelegate:self];
    [_imageArray release]; _imageArray = nil;
    [_homeArray release]; _homeArray = nil;
    [_neighborhoodAdDic release];
    [super dealloc];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    _Topic.JCdelegate = self;
    [_Topic setupTimer];
    
    [MobClick beginLogPageView:@"NeighborhoodBetweenPage"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    //停止自己滚动的timer
    _Topic.JCdelegate = nil;
    [_Topic releaseTimer];
    
    [MobClick endLogPageView:@"NeighborhoodBetweenPage"];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _imageArray = [[NSMutableArray alloc]initWithCapacity:0];
        _homeArray = [[NSMutableArray alloc]initWithCapacity:0];
        _neighborhoodAdDic = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    //self.view.backgroundColor = [UIColor whiteColor];
    backScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, MainHeight)];
    backScrollview.scrollEnabled = YES;
    backScrollview.showsHorizontalScrollIndicator = NO;
    backScrollview.showsVerticalScrollIndicator = NO;
    if (isIPhone5) {
        backScrollview.contentSize = CGSizeMake(ScreenWidth, MainHeight);
    }else{
        backScrollview.contentSize = CGSizeMake(ScreenWidth, MainHeight+30);
    }
    backScrollview.backgroundColor = RGB(244, 244, 244);
    [self.view addSubview:backScrollview];
    [backScrollview release];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"邻里之间"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    [self loadAdsScrollView];    // 加载滚动广告视图
    [self loadNeighborhoodView]; // 4个主模块
    [self requestAds];           //网络广告请求
    
//    //缓存广告数据
    if ([self getCacheUrlString:GlobalCommubityNeighborhoodAd]) {
        NSMutableDictionary *dic = (NSMutableDictionary *)[self getCacheDataDictionaryString:GlobalCommubityNeighborhoodAd];
        [_neighborhoodAdDic setDictionary:dic];
        [self refreshAds];
    }
    
    //广告的pageController
    _page = [[UIPageControl alloc]initWithFrame:CGRectMake((ScreenWidth - pageSize.width)/2,100, pageSize.width,18)];
    [backScrollview addSubview:_page];
    [_page release];
    
}
//下面各个模块
-(void)loadNeighborhoodView{
    //    下面物业的各种类型
    //NSArray *typeArray = [[NSArray alloc] initWithObjects:@"neighbor_car_pic.png",@"neighbor_photo_pic.png",/*@"neighbor_dog_pic.png",@"neighbor_help_pic.png",*/ nil];
    NSArray *typeArray = [[NSArray alloc] initWithObjects:@"neighbor_car_pic1.png",@"neighbor_photo_pic1.png",@"neighbor_dog_pic1.png",@"neighbor_help_pic1.png",nil];
    
    UIScrollView *contentScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, _Topic.frame.size.height+_Topic.frame.origin.y+6, ScreenWidth, 350)] ;
    contentScrollView.pagingEnabled = YES;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.scrollsToTop = NO;
    [contentScrollView setBackgroundColor:[UIColor clearColor]];
    [backScrollview addSubview:contentScrollView];
    [contentScrollView release];
    //13*(i%2+1)+140*(i%2)
    for (int i = 0; i<[typeArray count]; i++) {
        UIButton *partnersBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        partnersBtn.frame = CGRectMake(15*(i/4+1)+10*(i%2)+140*(i%2),10*(i/2+1)+140*(i/2), 140, 140);
        [partnersBtn setImage:[UIImage imageNamed:[typeArray objectAtIndex:i]] forState:UIControlStateNormal];
        [partnersBtn addTarget:self action:@selector(btnDetailAction:) forControlEvents:UIControlEventTouchUpInside];
        partnersBtn.tag = i;
        [contentScrollView addSubview:partnersBtn];
        
    }
    contentScrollView.contentSize = CGSizeMake(ScreenWidth,280);


}
//滚动广告视图
-(void)loadAdsScrollView{
    _Topic = [[JCTopic alloc]initWithFrame:CGRectMake(0, navImageView.frame.size.height+navImageView.frame.origin.y, ScreenWidth, 120)];
    _Topic.JCdelegate = self;
    [backScrollview addSubview:_Topic];
    [_Topic release];
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
    NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&adPositionKey=%@",USER_ID,userModel.userId,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,@"1"];
    [_request requestHomeAd:self parameters:parameters];
}

/**
 *  刷新广告
 */
- (void)refreshAds{
    if (_neighborhoodAdDic) {
        NSArray *array = [_neighborhoodAdDic objectForKey:@"adList"];
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

-(void)didClick:(int)index{
    NSLog(@"[NSString stringWithFormatindex] = %d",index);
    if ([self.homeArray count]!=0){
    HomeAdModel *model = [self.homeArray objectAtIndex:index-1];
    NeighborhoodDetailViewController *adDetailVc = [[NeighborhoodDetailViewController alloc] init];
    adDetailVc.adModel = model;
        
    [MobClick event:@"NeighborhoodBetweenAd_Click"];
        
    [self.navigationController pushViewController:adDetailVc animated:YES];
        [adDetailVc release];
    }else{
        NSLog(@"没有广告数据");
    }
}
-(void)currentPage:(int)page total:(NSUInteger)total{
    _page.numberOfPages = total;
    _page.currentPage = page;
    pageSize = [_page sizeForNumberOfPages:total];
}
//下面类型的进入
-(void)btnDetailAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    int buttonTag = button.tag;
    
    NSString *model = nil;
    switch (buttonTag) {
            //拼车上下班
        case 0:
        {
            CarPoolingViewController *carPoolVc = [[CarPoolingViewController alloc]init];
            [self.navigationController pushViewController:carPoolVc animated:YES];
            [carPoolVc release];
            model = @"拼车上下班";
        }
            break;
            //随手拍了卖
        case 1:
        {
            ConvenientSellViewController *convenientSellVc = [[ConvenientSellViewController alloc]init];
            [self.navigationController pushViewController:convenientSellVc animated:YES];
            [convenientSellVc release];
            model = @"随手拍了卖";
        }
            break;
            //宠物秀
        case 2:
        {
            //
            [Global showMBProgressHudHint:self SuperView:self.view Msg:@"敬请期待" ShowTime:1.0];
            model = @"宠物秀";
        }
            break;
            //邻居来帮忙
        case 3:
        {
            [Global showMBProgressHudHint:self SuperView:self.view Msg:@"敬请期待" ShowTime:1.0];
            model = @"邻居来帮忙";
            return;
            NeighborhoodHelpViewController *neiHelpVc = [[NeighborhoodHelpViewController alloc]init];
            [self.navigationController pushViewController:neiHelpVc animated:YES];
            [neiHelpVc release];
        }
            break;
        default:
            break;
    }
    [MobClick event:@"NeighborhoodBetweenView_Category" label:model];
}
- (void)callBackWith:(WInterface)interface status:(NSString *)status data:(id)data{
    if (interface == COMMUNITY_HOME_AD) {
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            [self.imageArray removeAllObjects];
            _neighborhoodAdDic = [data retain];
            [self saveCacheUrlString:GlobalCommubityNeighborhoodAd andNSDictionary:_neighborhoodAdDic];//缓存广告数据
            [self refreshAds];//刷新广告数据
        }else{
            NSLog(@"邻里之间网络广告数据加载失败");
        }
    }
}

//导航栏左边按钮
-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
