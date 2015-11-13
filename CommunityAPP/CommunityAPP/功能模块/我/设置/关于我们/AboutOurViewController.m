//
//  AboutOurViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-5-21.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "AboutOurViewController.h"
#import "UIViewController+NavigationBar.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "UserModel.h"
#import "IssueViewController.h"
#import "TeamViewController.h"
#import "AgreementViewController.h"
#import "AppDelegate.h"
#import "MobClick.h"

#define yunlailogoLab  @"壹社区V1.0"
#define citylogoLab    @"小区宝V1.0"
#define yunlailogoLab  @"壹社区V1.0"
#define yunlailogoLab  @"壹社区V1.0"

@interface AboutOurViewController ()
@property (nonatomic,retain) NSString *logoLab;
@property (nonatomic,retain) NSString *nameLab;
@property (nonatomic,retain) NSString *asignLab;
@end

@implementation AboutOurViewController
@synthesize logoLab = _logoLab;
@synthesize nameLab = _nameLab;
@synthesize asignLab = _asignLab;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc{
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"AboutOurPage"]; // 友盟统计
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"AboutOurPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:RGB(244, 244, 244)];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"关于我们"];
    
    
    if ([APP_NAME isEqualToString:@"小区宝"]) {
        _logoLab = @"小区宝V1.0";
        _nameLab = @"城市纵横 版权所有";
        _asignLab = @"© 2010-2012 city-media.com.cn.All Rights Reserved";
    } else if ([APP_NAME isEqualToString:@"壹社区"]){
        _logoLab = @"壹社区V1.0";
        _nameLab = @"云来网络 版权所有";
        _asignLab = @"© 2013 yunlai.cn. All Rights Reserved";
    }else{
        _logoLab = @"小区宝V1.0";
        _nameLab = @"城市纵横 版权所有";
        _asignLab = @"© 2010-2012 city-media.com.cn.All Rights Reserved";
    }
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //title图片
    UIImage *logoImg = [UIImage imageNamed:@"aboutour_logo2.png"];
    UIImageView *titleImg = [self newImageViewWithImage:logoImg frame:CGRectMake((ScreenWidth-logoImg.size.width)/2, 50, logoImg.size.width, logoImg.size.height)];
    [self.view addSubview:titleImg];
    [titleImg release];
    
    // 我爱我家title
    CGSize logoSize = [_logoLab sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];//获取字符的宽度
    UILabel *logoLable = [self newLabelWithText:_logoLab frame:CGRectMake((ScreenWidth-logoSize.width)/2, titleImg.frame.size.height+titleImg.frame.origin.y+14,logoSize.width, 18) font:[UIFont systemFontOfSize:15.0] textColor:RGB(51, 51, 51)];
    logoLable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:logoLable];
    [logoLable release];
    
    // 云来title
    CGSize nameSize = [_nameLab sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];//获取字符的宽度
    UILabel *nameLable = [self newLabelWithText:_nameLab frame:CGRectMake((ScreenWidth-nameSize.width)/2, ScreenHeight-115,nameSize.width, 20) font:[UIFont systemFontOfSize:12.0] textColor:RGB(191, 191, 191)];
    nameLable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:nameLable];
    [nameLable release];

    // 时间title
    CGSize asignSize = [_asignLab sizeWithFont:[UIFont systemFontOfSize:11.0] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];//获取字符的宽度
    UILabel *asignLable = [self newLabelWithText:_asignLab frame:CGRectMake((ScreenWidth-asignSize.width)/2, ScreenHeight-95,asignSize.width, 20) font:[UIFont systemFontOfSize:11.0] textColor:RGB(191, 191, 191)];
    asignLable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:asignLable];
    [asignLable release];
    
    
    ourTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, titleImg.frame.size.height+titleImg.frame.origin.y+69, ScreenWidth, MainHeight-230) style:UITableViewStylePlain];
    ourTableView.delegate = self;
    ourTableView.dataSource = self;
    ourTableView.scrollEnabled = NO;
    ourTableView.backgroundView = nil;
    ourTableView.backgroundColor = [UIColor clearColor];
    ourTableView.backgroundView.backgroundColor = RGB(244, 244, 244);
    ourTableView.tableFooterView = [[[UIView alloc]initWithFrame:CGRectZero]autorelease];
    [self.view addSubview:ourTableView];
    [ourTableView release];
}

#pragma mark - uitableview dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
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
        cell.backgroundView = [[[UIView alloc]initWithFrame:cell.bounds] autorelease];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                 cell.textLabel.text = @"给我评分";
            }
            if (indexPath.row == 1) {
                cell.textLabel.text = @"常见问题";
            }
            if (indexPath.row == 2) {
                cell.textLabel.text = @"用户协议";
            }
            if (indexPath.row == 3) {
                cell.textLabel.text = @"团队介绍";
            }
            break;
            
        default:
            break;
    }
    return cell;
}
#pragma mark - uitableviewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                //给我评分
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                NSURL *url = [NSURL URLWithString:[appDelegate.updateDictionary objectForKey:@"scoreUrl"]];
                [[UIApplication sharedApplication] openURL:url];
            }
            if (indexPath.row == 1) {
                //常见问题
                IssueViewController *issueVc = [[IssueViewController alloc]init];
                [self.navigationController pushViewController:issueVc animated:YES];
                [issueVc release];
            }
            if (indexPath.row == 2) {
                //用户协议
                AgreementViewController *agreementVc = [[AgreementViewController alloc]init];
                [self.navigationController pushViewController:agreementVc animated:YES];
                [agreementVc release];
            }
            if (indexPath.row == 3) {
                //团队介绍
                TeamViewController *teamVc = [[TeamViewController alloc]init];
                [self.navigationController pushViewController:teamVc animated:YES];
                [teamVc release];
            }
            break;
            
        default:
            break;
    }
}


#pragma mark -- uiatbleviewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *__view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 1.0f)];
    [__view setBackgroundColor:RGB(236, 236, 236)];
    return __view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//返回导航按钮
-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
