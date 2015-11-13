//
//  AvoidTroubleViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-5-21.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "AvoidTroubleViewController.h"
#import "UIViewController+NavigationBar.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "UserModel.h"
#import "CommunityHttpRequest.h"
#import "ASIWebServer.h"
#import "AvoidTroubleCell.h"
#import "MobClick.h"

@interface AvoidTroubleViewController () <WebServiceHelperDelegate>

@property (nonatomic, retain) CommunityHttpRequest *request;

@end

@implementation AvoidTroubleViewController

- (void)dealloc{
    [_request cancelDelegate:self];
    [super dealloc];
}

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
    [MobClick beginLogPageView:@"AvoidTroublePage"]; // 友盟统计
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"AvoidTroublePage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:RGB(244, 244, 244)];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"免打扰"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    avoidTroubleTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, MainHeight) style:UITableViewStylePlain];
    avoidTroubleTableView.delegate = self;
    avoidTroubleTableView.dataSource = self;
    avoidTroubleTableView.backgroundView = nil;
    avoidTroubleTableView.backgroundColor = RGB(244, 244, 244);
    avoidTroubleTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    [self.view addSubview:avoidTroubleTableView];
    [avoidTroubleTableView release];
    
    NSInteger selectedIndex = self.discrubSettingModel.val;
    [avoidTroubleTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}
#pragma mark - uitableviewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     static NSString *identifer = @"Cell";
    AvoidTroubleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[[AvoidTroubleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer]autorelease];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    
    }
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"关闭";
                if (self.discrubSettingModel.val == 0) {
                    [cell setSelected:YES animated:YES];
                }
            }else if (indexPath.row == 1) {
                cell.textLabel.text = @"仅夜间开启";
                if (self.discrubSettingModel.val == 1) {
                    cell.selected = YES;
                }
            }else if (indexPath.row == 2) {
                cell.textLabel.text = @"全天开启";
                if (self.discrubSettingModel.val == 2) {
                    cell.selected = YES;
                }
            }
            break;
            
        default:
            break;
    }

    return cell;
}
#pragma mark - uitableivewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *__view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)] autorelease];
    __view.backgroundColor = RGB(244, 244, 244);
    
    return __view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 50.f)];
        footerView.backgroundColor = RGB(244, 244, 244);
        UILabel *lable = [self newLabelWithText:@" “全天开启”时，有新的聊天消息、评论、通知或账单信息时，手机不会发出提示音或振动。" frame:CGRectMake(20,0 ,285, 50) font:[UIFont systemFontOfSize:14.0] textColor:RGB(90, 90, 90)];
        lable.numberOfLines = 0;
        lable.backgroundColor = [UIColor clearColor];
    
    UILabel *lable1 = [self newLabelWithText:@" “仅夜间开启”时，则只在22：00到8：00生效，出提示音或振动。" frame:CGRectMake(20,50 ,285, 50) font:[UIFont systemFontOfSize:14.0] textColor:RGB(90, 90, 90)];
    lable1.numberOfLines = 0;
    lable1.backgroundColor = [UIColor clearColor];
    
        [footerView addSubview:lable];
        [footerView addSubview:lable1];
        [lable release];
        return [footerView autorelease];
  
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 55.f;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    CMPushStatus status = CMPushStatusOff;
    switch (indexPath.row) {
        case 0:
            status = CMPushStatusOff;
            self.discrubSettingModel.val = CMPushStatusOff;
            break;
        case 1:
            status = CMPushStatusOn;
            self.discrubSettingModel.val = CMPushStatusOn;
            break;
        case 2:
            status = CMPushStatusNoBother;
            self.discrubSettingModel.val = CMPushStatusNoBother;
            break;
        default:
            break;
    }
    [self requestPushSetting:kCMPushContentNoDisturb withStatus:status];
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

#pragma mark ---network

- (void)requestPushSetting:(NSString *)pushContentType  withStatus:(CMPushStatus)status{
    UserModel *userModel = [UserModel shareUser];
    NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&%@=%d",USER_ID,userModel.userId,COMMUNITY_ID,userModel.communityId,@"field",pushContentType,@"val",status];
    _request = [CommunityHttpRequest shareInstance];
    [_request requestSettingPush:self parameters:parameters];
}

- (void)callBackWith:(WInterface)interface status:(NSString *)status data:(id)data{
    if (interface == COMMUNITY_SETTINGS_PUSH) {
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            
        }else{
            NSLog(@"设置免打扰失败:%@",data);
        }
    }
}

@end
