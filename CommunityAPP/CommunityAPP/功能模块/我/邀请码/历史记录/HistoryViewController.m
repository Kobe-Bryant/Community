//
//  HistoryViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-4-3.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "HistoryViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "HistoryCell.h"
#import "CommunityHttpRequest.h"
#import "UserModel.h"
#import "NSString+MD5.h"
#import "HistoryIntoryModel.h"
#import "UIViewController+NavigationBar.h"
#import "MobClick.h"

@interface HistoryViewController ()
@property (nonatomic, retain) CommunityHttpRequest *request;
@property (nonatomic,retain) NSMutableArray *historyArray;

@end

@implementation HistoryViewController
@synthesize request = _request;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.historyArray = [[NSMutableArray alloc]initWithCapacity:0];
        lastIdStr = @"0";
    }
    return self;
}
- (void)dealloc
{
    [_request cancelDelegate:self];
    [_historyArray release]; _historyArray = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"HistoryPage"]; // 友盟统计
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"HistoryPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = RGB(255, 255, 255);
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"历史记录"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    historyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, MainHeight) style:UITableViewStylePlain];
    historyTableView.delegate = self;
    historyTableView.dataSource = self;
    [self.view addSubview:historyTableView];
    [historyTableView release];
    
    hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];//等待指示器出现
    // 网络请求
    if (_request == nil) {
        _request = [CommunityHttpRequest shareInstance];
    }
    //Auth 2.0加密
    UserModel *userModel = [UserModel shareUser];
    NSLog(@"userModel.token = =%@",userModel.token);
    NSString *newToken = [NSString stringWithFormat:@"%@%@%@%@%@",userModel.userId,userModel.communityId,userModel.propertyId,lastIdStr,userModel.token];
    NSString *md5NewToken = [newToken md5];
    NSLog(@"md5NewToken = =%@",md5NewToken);
    NSString *parameters = [NSString stringWithFormat:@"?userId=%@&communityId=%@&propertyId=%@&lastId=%@&token=%@",userModel.userId,userModel.communityId,userModel.propertyId,lastIdStr,md5NewToken];//参数
    NSLog(@"parameters = =%@",parameters);
    [_request requestInviteHistory:self parameters:parameters];
    
}
#pragma mark --- uitableviewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.historyArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
    if (cell == nil) {
        cell = [[[HistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HistoryCell"]autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    
    HistoryIntoryModel *model = [self.historyArray objectAtIndex:indexPath.row];
    cell.numberInviteLable.text = [NSString stringWithFormat:@"%@",model.inviteCodeStr];
    //model.stateStr 2为可用邀请码 3为不可用邀请码
    if ([model.stateStr isEqualToString:@"2"]) {
        cell.numberInviteLable.textColor = [UIColor redColor];
    }
    if ([model.stateStr isEqualToString:@"3"]) {
        cell.numberInviteLable.textColor = [UIColor blackColor];
        [cell.sendButton removeFromSuperview];
    }
    cell.timeLable.text = model.createTimeStr;
    
    cell.sendButton.tag = indexPath.row;
    [cell.sendButton addTarget:self action:@selector(sendButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark -- uiatbleviewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58.0;
}
//导航栏左右按钮
-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)sendButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger buttonTag = button.tag;
    HistoryIntoryModel *model = [self.historyArray objectAtIndex:buttonTag];
   BOOL flag = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sms://"]];
    if (flag) {
        [self sendSMS:model.inviteCodeStr recipientList:nil];
    }else{
    
    }
    
}

#pragma mark ------
-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    [self hideHudView];//隐藏等待指示器
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSString *code = [data objectForKey:ERROR_CODE];
        if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            NSArray *array = [data objectForKey:@"codeList"];
            for (NSDictionary *dic in array) {
                HistoryIntoryModel *model = [[HistoryIntoryModel alloc]init];
                model.codeTypeStr = [dic objectForKey:@"codeType"];
                model.inviteCodeStr = [dic objectForKey:@"inviteCode"];
                model.stateStr = [dic objectForKey:@"state"];
                model.createTimeStr = [dic objectForKey:@"createTime"];
                [self.historyArray addObject:model];
                [model release];
            }

        }
    }
    [historyTableView reloadData];
}
//内容，收件人列表
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;
        
        controller.recipients = recipients;
        
        controller.messageComposeDelegate = self;
        
        [self presentViewController:controller animated:YES completion:^{}];
        
    }
}
// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:^{}];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
        else if (result == MessageComposeResultSent)
            NSLog(@"Message sent");
            else 
                NSLog(@"Message failed");
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

@end
