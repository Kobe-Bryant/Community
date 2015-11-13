//
//  InviteViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-4-3.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "InviteViewController.h"
#import "Global.h"
#import "DetailInviteViewController.h"
#import "NSObject_extra.h"
#import "HistoryViewController.h"
#import "CommunityHttpRequest.h"
#import "UserModel.h"
#import "NSString+MD5.h"
#import "UIViewController+NavigationBar.h"
#import "AppConfig.h"
#import "MobClick.h"

@interface InviteViewController ()
@property (nonatomic, retain) CommunityHttpRequest *request;

@end

@implementation InviteViewController
@synthesize request = _request;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        clientTypeStr = @"01";//默认是业主类型
    }
    return self;
}
- (void)dealloc
{
    [_request cancelDelegate:self];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"InvitePage"]; // 友盟统计
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"InvitePage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGB(255, 255, 255);
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"邀请码"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //    右边按钮
    //右按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"历史记录" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [rightBtn addTarget:self action:@selector(rightButton) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(280,0,90,44);
    [self setRightBarButtonItem:rightBtn];
    
    UIImage *selectdImage = [UIImage imageNamed:@"txl_options_down.png"];
    UIImage *normalImage = [UIImage imageNamed:@"txl_options.png"];
    //性别按钮
    //UIImage *ownerImg = [UIImage imageNamed:@"owner_selected.png"];
    ownerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ownerBtn.frame = CGRectMake(20, 26, 128, 44);
    //[ownerBtn setImage:ownerImg forState:UIControlStateNormal];
    [ownerBtn setImage:normalImage forState:UIControlStateNormal];
    [ownerBtn setImage:selectdImage forState:UIControlStateSelected];
    [ownerBtn setTitle:@"邀请家人" forState:UIControlStateNormal];
    [ownerBtn setTitleColor:RGB(197, 197, 197) forState:UIControlStateNormal];
    [ownerBtn setTitleColor:RGB(250, 89, 55) forState:UIControlStateSelected];
    [ownerBtn addTarget:self action:@selector(ownerBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ownerBtn];
    ownerBtn.selected = YES;
    
    //UIImage *renterImg = [UIImage imageNamed:@"renter.png"];
    renterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    renterBtn.frame = CGRectMake(160, 26, 128, 44);
    [renterBtn setImage:normalImage forState:UIControlStateNormal];
    [renterBtn setImage:selectdImage forState:UIControlStateSelected];
    [renterBtn setTitle:@"邀请租客" forState:UIControlStateNormal];
    [renterBtn setTitleColor:RGB(197, 197, 197) forState:UIControlStateNormal];
    [renterBtn setTitleColor:RGB(250, 89, 55) forState:UIControlStateSelected];
    [renterBtn addTarget:self action:@selector(renterBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:renterBtn];
    
    
    //生成邀请码按钮
    UIImage *loginImg = [UIImage imageNamed:@"login1.png"];
    UIButton *nextBtn = [self newButtonWithImage:loginImg highlightedImage:nil frame:CGRectMake(10, 80, loginImg.size.width, loginImg.size.height) title:@"生成邀请码" titleColor:[UIColor whiteColor] titleShadowColor:nil font:[UIFont systemFontOfSize:19.0] target:self action:@selector(nextBtn)];
    [self.view addSubview:nextBtn];
    [nextBtn release];
}
//更换性别按钮
-(void)ownerBtn
{
    clientTypeStr = @"01";
    ownerBtn.selected = YES;
    renterBtn.selected = NO;
}
-(void)renterBtn
{
    clientTypeStr = @"02";
    ownerBtn.selected = NO;
    renterBtn.selected = YES;
}


//导航栏左右按钮
-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightButton
{
    HistoryViewController *historyVc = [[HistoryViewController alloc]init];
    [self.navigationController pushViewController:historyVc animated:YES];
    [historyVc release];
}
//生成邀请码按钮
-(void)nextBtn
{
    hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];//等待指示器出现
    // 网络请求
    if (_request == nil) {
        _request = [CommunityHttpRequest shareInstance];
    }
    //Auth 2.0加密
    UserModel *userModel = [UserModel shareUser];
    NSString *newToken = [NSString stringWithFormat:@"%@%@%@%@%@",userModel.userId,userModel.communityId,userModel.propertyId,clientTypeStr,userModel.token];
        NSString *md5NewToken = [newToken md5];
    NSString *parameters = [NSString stringWithFormat:@"?userId=%@&communityId=%@&propertyId=%@&clientType=%@&token=%@",userModel.userId,userModel.communityId,userModel.propertyId,clientTypeStr,md5NewToken];//参数
    NSLog(@"parameters = %@",parameters);
    [_request requestGetInvite:self parameters:parameters];


}

-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    [self hideHudView];//隐藏等待指示器
    if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
        inviteCodeStr = [[data objectForKey:@"inviteCode"] retain] ;
        if ([data objectForKey:@"errorMsg"]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[data objectForKey:@"errorMsg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            alertView.tag = 1;
//            [alertView show];
//            [alertView release];
            DetailInviteViewController *detailVc = [[DetailInviteViewController alloc] init];
            detailVc.passStr =inviteCodeStr;
            [self.navigationController pushViewController:detailVc animated:YES];
            [detailVc release];
        }

    }else{
        [self alertWithFistButton:nil SencodButton:@"确定" Message:[data objectForKey:@"errorMsg"]];
        return;
    }
}
- (void) hideHudView
{
    if (hudView) {
        [hudView hide:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (alertView.tag == 1) {
//        if (buttonIndex == 0) {
//            DetailInviteViewController *detailVc = [[DetailInviteViewController alloc] init];
//            detailVc.passStr =inviteCodeStr;
//            [self.navigationController pushViewController:detailVc animated:YES];
//            [detailVc release];
//        }
//    }
//   
//}
@end


