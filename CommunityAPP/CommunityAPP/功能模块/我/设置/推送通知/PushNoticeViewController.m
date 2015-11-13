//
//  PushNoticeViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-5-21.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "PushNoticeViewController.h"
#import "UIViewController+NavigationBar.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "AvoidTroubleViewController.h"
#import "PushNotificationCell.h"
#import "CommunityHttpRequest.h"
#import "UserModel.h"
#import "ASIWebServer.h"
#import "PushSettingModel.h"
#import "MobClick.h"

@interface PushNoticeViewController ()<WebServiceHelperDelegate>

@property (nonatomic, retain) CommunityHttpRequest *request;

@property (nonatomic, retain) PushSettingModel *chatPushSetting;
@property (nonatomic, retain) PushSettingModel *commentPushSetting;
@property (nonatomic, retain) PushSettingModel *billPushSetting;
@property (nonatomic, retain) PushSettingModel *discrubPushSetting;


@end

@implementation PushNoticeViewController

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
    [MobClick beginLogPageView:@"PushNoticePage"]; // 友盟统计
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PushNoticePage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:RGB(244, 244, 244)];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"推送通知"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    
    pushNoticeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, MainHeight) style:UITableViewStylePlain];
    pushNoticeTableView.delegate = self;
    pushNoticeTableView.dataSource = self;
    pushNoticeTableView.backgroundView = nil;
    pushNoticeTableView.backgroundColor = RGB(244, 244, 244);
    pushNoticeTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    [self.view addSubview:pushNoticeTableView];
    [pushNoticeTableView release];
    
    [self requestNotificationSetting];
}

#pragma mark ---getter
- (PushSettingModel *)chatPushSetting{
    if (_chatPushSetting == nil) {
        _chatPushSetting = [[PushSettingModel alloc] init];
    }
    
    return _chatPushSetting;
}

- (PushSettingModel *)commentPushSetting{
    if (_commentPushSetting == nil) {
        _commentPushSetting = [[PushSettingModel alloc] init];
    }
    return _commentPushSetting;
}


- (PushSettingModel *)discrubPushSetting{
    if (_discrubPushSetting == nil) {
        _discrubPushSetting = [[PushSettingModel alloc] init];
    }
    return _discrubPushSetting;
}

- (PushSettingModel *)billPushSetting{
    if (_billPushSetting == nil) {
        _billPushSetting = [[PushSettingModel alloc] init];
    }
    
    return _billPushSetting;
}

#pragma mark - uitableview dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idenfier = @"Cell";
    PushNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfier];
    if (cell == nil) {
        cell = [[[PushNotificationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenfier]autorelease];
        cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    switch (indexPath.section) {
        case 0:
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"聊天消息通知";
            cell.noticeSwitch.on = self.chatPushSetting.val;
            [cell.noticeSwitch addTarget:self action:@selector(chatPushSetting:) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 1:
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"评论消息通知";
            cell.noticeSwitch.on = self.commentPushSetting.val;
            [cell.noticeSwitch addTarget:self action:@selector(commentPushSetting:) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 2:
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"推送消息通知";
            cell.noticeSwitch.on = self.billPushSetting.val;
            [cell.noticeSwitch addTarget:self action:@selector(billPushSetting:) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 3:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"免打扰";
            cell.noticeSwitch.hidden = YES;
            break;
            
        default:
            break;
    }
    
    
    return cell;
}

#pragma mark -- uiatbleviewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *__view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)] autorelease];
    __view.backgroundColor = RGB(244, 244, 244);
    return __view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 55.f)];
        footerView.backgroundColor = RGB(244, 244, 244);
        UILabel *lable = [self newLabelWithText:@"开启时，当有新的聊天消息时，手机将会发出提示音或振动" frame:CGRectMake(20,0 ,280, 50) font:[UIFont systemFontOfSize:14.0] textColor:RGB(90, 90, 90)];
        lable.numberOfLines = 0;
        lable.backgroundColor = [UIColor clearColor];
        [footerView addSubview:lable];
        [lable release];
        return [footerView autorelease];
    }else if(section ==1){
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 55.f)];
        footerView.backgroundColor = RGB(244, 244, 244);
        UILabel *lable = [self newLabelWithText:@"开启时，当有新评论或回复时，手机将会发出提示音或振动" frame:CGRectMake(20,0 ,280, 50) font:[UIFont systemFontOfSize:14.0] textColor:RGB(90, 90, 90)];
        lable.numberOfLines = 0;
        lable.backgroundColor = [UIColor clearColor];
        [footerView addSubview:lable];
        [lable release];
        return [footerView autorelease];
    }else if(section ==2){
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 55.f)];
        footerView.backgroundColor = RGB(244, 244, 244);
        UILabel *lable = [self newLabelWithText:@"开启时，当有新的通知或者账单等信息时，手机将会发出提示音或振动" frame:CGRectMake(20,0 ,280, 50) font:[UIFont systemFontOfSize:14.0] textColor:RGB(90, 90, 90)];
        lable.numberOfLines = 0;
        lable.backgroundColor = [UIColor clearColor];
        [footerView addSubview:lable];
        [lable release];
        return [footerView autorelease];
    
    }
    return nil;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 || section == 1 || section == 2 ) {
        return 55.f;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==3) {
        AvoidTroubleViewController *avoidTroubleVc = [[AvoidTroubleViewController alloc]init];
        avoidTroubleVc.discrubSettingModel = self.discrubPushSetting;
        [self.navigationController pushViewController:avoidTroubleVc animated:YES];
        [avoidTroubleVc release];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---setting

- (void)chatPushSetting:(UISwitch *)sender{

    [self requestPushSetting:kCMPushContentTypeChat withStatus:sender.on];
}

- (void)commentPushSetting:(UISwitch *)sender{
    [self requestPushSetting:kCMPushContentTypeComment withStatus:sender.on];
}

- (void)billPushSetting:(UISwitch *)sender{
    [self requestPushSetting:kCMPushContentTypeBill withStatus:sender.on];
}

#pragma mark ---network

//获取推送设置
- (void)requestNotificationSetting{
    
    UserModel *userModel = [UserModel shareUser];
    NSString *parameters = [NSString stringWithFormat:@"%@",userModel.userId];
    _request = [CommunityHttpRequest shareInstance];
    [_request requestNoticeSetting:self parameters:parameters];
}

- (void)requestPushSetting:(NSString *)pushContentType  withStatus:(CMPushStatus)status{
    UserModel *userModel = [UserModel shareUser];
    NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&%@=%d",USER_ID,userModel.userId,COMMUNITY_ID,userModel.communityId,@"field",pushContentType,@"val",status];
    _request = [CommunityHttpRequest shareInstance];
    [_request requestSettingPush:self parameters:parameters];
}

- (void)callBackWith:(WInterface)interface status:(NSString *)status data:(id)data{
    if (interface == COMMUNITY_SETTINGS_FEEDBACK_LIST) {        //获取推送设置
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            NSArray *settings = [data objectForKey:@"settings"];
            for (NSDictionary *dic in settings) {
                if ([[dic objectForKey:@"field"] isEqualToString:kCMPushContentTypeChat]) {
                    self.chatPushSetting.seetingId = [[dic objectForKey:@"settingId"] integerValue];
                    self.chatPushSetting.pushUserId = [[dic objectForKey:@"userId"] integerValue];
                    self.chatPushSetting.field = [dic objectForKey:@"field"];
                    self.chatPushSetting.createTime = [dic objectForKey:@"createTime"];
                    self.chatPushSetting.updateTime = [dic objectForKey:@"updateTime"];
                    self.chatPushSetting.val = [[dic objectForKey:@"val"] integerValue];
                }else if ([[dic objectForKey:@"field"] isEqualToString:kCMPushContentTypeComment]){
                    self.commentPushSetting.seetingId = [[dic objectForKey:@"settingId"] integerValue];
                    self.commentPushSetting.pushUserId = [[dic objectForKey:@"userId"] integerValue];
                    self.commentPushSetting.field = [dic objectForKey:@"field"];
                    self.commentPushSetting.createTime = [dic objectForKey:@"createTime"];
                    self.commentPushSetting.updateTime = [dic objectForKey:@"updateTime"];
                    self.commentPushSetting.val = [[dic objectForKey:@"val"] integerValue];
                }else if ([[dic objectForKey:@"field"] isEqualToString:kCMPushContentTypeBill]){
                    self.billPushSetting.seetingId = [[dic objectForKey:@"settingId"] integerValue];
                    self.billPushSetting.pushUserId = [[dic objectForKey:@"userId"] integerValue];
                    self.billPushSetting.field = [dic objectForKey:@"field"];
                    self.billPushSetting.createTime = [dic objectForKey:@"createTime"];
                    self.billPushSetting.updateTime = [dic objectForKey:@"updateTime"];
                    self.billPushSetting.val = [[dic objectForKey:@"val"] integerValue];
                }else if ([[dic objectForKey:@"field"] isEqualToString:kCMPushContentNoDisturb]){
                    self.discrubPushSetting.seetingId = [[dic objectForKey:@"settingId"] integerValue];
                    self.discrubPushSetting.pushUserId = [[dic objectForKey:@"userId"] integerValue];
                    self.discrubPushSetting.field = [dic objectForKey:@"field"];
                    self.discrubPushSetting.createTime = [dic objectForKey:@"createTime"];
                    self.discrubPushSetting.updateTime = [dic objectForKey:@"updateTime"];
                    self.discrubPushSetting.val = [[dic objectForKey:@"val"] integerValue];
                }
            }
            [pushNoticeTableView reloadData];
        }else{
            NSLog(@"获取推送通知设置是失败:%@",data);
        }
        
    }else if (interface == COMMUNITY_SETTINGS_PUSH){            //设置推送返回
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            
        }else{
            NSLog(@"COMMUNITY_SETTINGS_PUSH 推送通知设置失败");
        }
    }
}

@end
