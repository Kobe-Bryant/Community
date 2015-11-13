//
//  PropertyCenterViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-5.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "PropertyCenterViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "CommunityIntroduceViewController.h"
#import "RulesRegulationViewController.h"
#import "SubwayBusViewController.h"
#import "UIViewController+NavigationBar.h"
#import "CMBPNotification.h"
#import "UIView+Badge.h"
#import "DataBaseManager.h"
#import "MobClick.h"

@interface PropertyCenterViewController ()

@property (nonatomic, retain) NSMutableArray *propertyItems;

@end

@implementation PropertyCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.propertyItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.propertyItems release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [self refreshRuleStatus];
    [MobClick beginLogPageView:@"PropertyCenterPage"]; // 友盟统计
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PropertyCenterPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"物业中心"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];

    //添加视图内容方法
    [self lordProCenterView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNewRule:) name:kCMBPRules object:nil];
    
    
}

- (void)recieveNewRule:(NSNotification *)notice{
    [self refreshRuleStatus];
}

- (void)refreshRuleStatus{
    DataBaseManager *dbManager = [DataBaseManager shareDBManeger];
    NSInteger unreadRulesCount = [dbManager selectUnreadRules];
    UIButton *btn = ([self.propertyItems count] > 3) ? [self.propertyItems objectAtIndex:2] : nil;
    btn.badge.outlineWidth = 0.0;
    btn.badge.outlineColor = [UIColor clearColor];
    if (unreadRulesCount == 0) {
        btn.badge.badgeValue = 0;
    }else{
        btn.badge.badgeValue = unreadRulesCount;
    }
    
}

-(void)lordProCenterView
{
    //各种物业类型
    //NSArray *typesArr = [[NSArray alloc]initWithObjects:@"home_intro.png",@"bus_subway.png",@"rule_system.png",/*@"mail_reach.png",@"repair.png",@"stop_lot.png",*/nil];
    NSArray *typesArr = [[NSArray alloc]initWithObjects:@"home_intro.png",@"bus_subway.png",@"rule_system.png",@"mail_reach.png",@"repair.png",@"stop_lot.png",nil];
    
    //滚动视图
    UIScrollView *contentScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, MainHeight)] ;
    contentScrollView.pagingEnabled = YES;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.scrollsToTop = NO;
    [contentScrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:contentScrollView];
    [contentScrollView release];
    [self.propertyItems removeAllObjects];
    for (int i = 0; i<[typesArr count]; i++) {
        UIButton *partnersBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        partnersBtn.frame = CGRectMake(21*(i%2+1)+128*(i%2),16*(i/2+1)+95*(i/2), 128, 95);
        [partnersBtn setImage:[UIImage imageNamed:[typesArr objectAtIndex:i]] forState:UIControlStateNormal];
        [partnersBtn addTarget:self action:@selector(btnDetailAction:) forControlEvents:UIControlEventTouchUpInside];
        partnersBtn.tag = i;
        [contentScrollView addSubview:partnersBtn];
        [self.propertyItems addObject:partnersBtn];
      }
    contentScrollView.contentSize = CGSizeMake(ScreenWidth,ScreenHeight);

}

//下面类型的进入
-(void)btnDetailAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    int buttonTag = button.tag;
    switch (buttonTag) {
        case 0:
        {
        CommunityIntroduceViewController *comIntroVc = [[CommunityIntroduceViewController alloc]init];
        [self.navigationController pushViewController:comIntroVc animated:YES];
        [comIntroVc release];
        }
            break;
        case 1:
        {
            SubwayBusViewController *subwayBusVc = [[SubwayBusViewController alloc] init];
            [self.navigationController pushViewController:subwayBusVc animated:YES];
            [subwayBusVc release];
        }
            break;
        case 2:
        {
            RulesRegulationViewController *rulesRegulationVc = [[RulesRegulationViewController alloc] init];
            [self.navigationController pushViewController:rulesRegulationVc animated:YES];
            [rulesRegulationVc release];
        }
            break;
        case 3:
        {
            [Global showMBProgressHudHint:self SuperView:self.view Msg:@"敬请期待" ShowTime:1.0];
        }
            break;
        case 4:
        {
            [Global showMBProgressHudHint:self SuperView:self.view Msg:@"敬请期待" ShowTime:1.0];
        }
            break;
        case 5:
        {
            [Global showMBProgressHudHint:self SuperView:self.view Msg:@"敬请期待" ShowTime:1.0];
        }
            break;
        case 6:
        {
            
        }
            break;
        case 7:
        {
            
        }
            break;
        default:
            break;
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
