//
//  SetUpViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-13.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "SetUpViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "ModifyPasswordViewController.h"
#import "AppDelegate.h"
#import "UserModel.h"
#import "DataBaseManager.h"
#import "UIViewController+NavigationBar.h"
#import "AboutOurViewController.h"
#import "PushNoticeViewController.h"
#import "FeedBackViewController.h"
#import "ChangeNumberViewController.h"
#import "MobClick.h"

@interface SetUpViewController ()

@end

@implementation SetUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"SetUpPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"SetUpPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:RGB(244, 244, 244)];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"设置"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];

    //列表视图
    setUpTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, ScreenWidth, MainHeight) style:UITableViewStylePlain];
    setUpTableView.delegate = self;
    setUpTableView.dataSource = self;
    setUpTableView.backgroundView = nil;
    setUpTableView.backgroundColor = [UIColor clearColor];
    setUpTableView.backgroundView.backgroundColor = RGB(244, 244, 244);
    setUpTableView.tableHeaderView = [[[UIView alloc]initWithFrame:CGRectZero] autorelease];
    setUpTableView.tableFooterView = [self initFooteView];
    [self.view addSubview:setUpTableView];
    [setUpTableView release];

}

- (UIView *)initFooteView{
    //下一步按钮
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)] autorelease];
    view.backgroundColor = RGB(244, 244, 244);
    UIImage *loginImg = [UIImage imageNamed:@"red-button.png"];
    UIButton *nextBtn = [self newButtonWithImage:loginImg highlightedImage:nil frame:CGRectMake(10, 20, 300,40) title:@"退出登录" titleColor:[UIColor whiteColor] titleShadowColor:nil font:[UIFont systemFontOfSize:19.0] target:self action:@selector(nextBtn)];
    [view addSubview:nextBtn];
    
    return view;
}

#pragma mark --- uitableviewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //return 1;   //1期版本 add by Stone
    return 2; //add by devin
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return 3;   //1期版本 add by Stone
    if (section == 0) {
        return 3;
    }else{
        return 2;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idenfier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenfier]autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.textColor = RGB(100, 100, 100);
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"密码修改";
            }
     
            if (indexPath.row == 1) {
                cell.textLabel.text = @"我的账号";
            }
         
            if (indexPath.row == 2) {
                cell.textLabel.text = @"推送通知";
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"意见反馈";
            }
        
            if (indexPath.row == 1) {
                cell.textLabel.text = @"关于我们";
            }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark -- uiatbleviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.0f;
    }
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *__view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 10.0f)];
    [__view setBackgroundColor:RGB(236, 236, 236)];
    return __view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            //密码修改
            if (indexPath.row == 0) {
                ModifyPasswordViewController *modifyPassVc = [[ModifyPasswordViewController alloc]init];
                [self.navigationController pushViewController:modifyPassVc animated:YES];
                [modifyPassVc release];
                }
            
            //账号安全
            if (indexPath.row == 1) {
                ChangeNumberViewController *changeNumberVc = [[ChangeNumberViewController alloc]init];
                [self.navigationController pushViewController:changeNumberVc animated:YES];
                [changeNumberVc release];
            }
           
            //推送通知
            if (indexPath.row == 2) {
                PushNoticeViewController *pushNoticeVc = [[PushNoticeViewController alloc]init];
                [self.navigationController pushViewController:pushNoticeVc animated:YES];
                [pushNoticeVc release];
            }
            break;
        case 1:
            //意见反馈
            if (indexPath.row == 0) {
                FeedBackViewController *feedBackVc =[[FeedBackViewController alloc]init];
                [self.navigationController pushViewController:feedBackVc animated:YES];
                [feedBackVc release];
                
            }
           
            //关于我们
            if (indexPath.row == 1) {
                AboutOurViewController *aboutOurVc = [[AboutOurViewController alloc]init];
                [self.navigationController pushViewController:aboutOurVc animated:YES];
                [aboutOurVc release];
            }
            break;
        default:
            break;
    }
}



//返回导航按钮
-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
//退出登录
-(void)nextBtn
{
    [MobClick event:@"LogOut"]; //友盟统计退出登录
    //清楚用户缓存
    UserModel *user = [UserModel shareUser];
    [user clearUserInfo];
    //清理数据库所有的数据
    DataBaseManager *dbManager = [DataBaseManager shareDBManeger];
    [dbManager deleteDataBase];
    
//    add vincent 清楚签到数据信息 
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:GlobalCommunitySignIn];
//    add vincent 清楚地址缓存数据
    [userDefault removeObjectForKey:GlobalCommunityAddress];
//    清楚个人资料
    [userDefault removeObjectForKey:GlobalCommubityMyPersonalInformation];
    
    [userDefault synchronize];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;    
    [delegate seafQuitOutLogin];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
