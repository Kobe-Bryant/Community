//
//  DetailInviteViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-4-4.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "DetailInviteViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "UIViewController+NavigationBar.h"
#import "MobClick.h"

@interface DetailInviteViewController ()
@property (nonatomic,retain) UILabel *inviteLable;
@property (nonatomic,retain) UILabel *numberInviteLable;
@property (nonatomic,retain) UIButton *sendButton;

@end

@implementation DetailInviteViewController
@synthesize inviteLable;
@synthesize numberInviteLable;
@synthesize sendButton;
@synthesize passStr;

//add vincent 内存释放
-(void)dealloc{
    [self.inviteLable release]; self.inviteLable  = nil;
    [self.numberInviteLable release]; self.numberInviteLable = nil;
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
    [MobClick beginLogPageView:@"DetailInvitePage"]; // 友盟统计
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DetailInvitePage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(255, 255, 255);
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"邀请码"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    detailInviteTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, MainHeight) style:UITableViewStylePlain];
    detailInviteTableView.delegate = self;
    detailInviteTableView.dataSource = self;
    [self.view addSubview:detailInviteTableView];
    [detailInviteTableView release];
}
#pragma mark ---uitableviewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"]autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    //邀请码
    self.inviteLable = [self newLabelWithText:@"邀请码：" frame:CGRectMake(20, 15, 80, 30) font:[UIFont systemFontOfSize:16.0] textColor:RGB(1, 1, 1)];
    [cell.contentView addSubview:self.inviteLable];
    
    //邀请码号码
    self.numberInviteLable = [self newLabelWithText:self.passStr frame:CGRectMake(self.inviteLable.frame.size.width+self.inviteLable.frame.origin.x-10, 15, 120, 30) font:[UIFont systemFontOfSize:16.0] textColor:[UIColor redColor]];
    [cell.contentView  addSubview:self.numberInviteLable];
    
    //发送button
    UIImage *sendImg = [UIImage imageNamed:@"sender_button.png"];
    self.sendButton = [self newButtonWithImage:sendImg highlightedImage:nil frame:CGRectMake(240, 12, sendImg.size.width, sendImg.size.height) title:@"发送" titleColor:RGB(255, 255, 255) titleShadowColor:nil font:[UIFont systemFontOfSize:18.0] target:self action:@selector(sendButton:)];
    [cell.contentView addSubview:self.sendButton];
    return cell;
}
#pragma mark -- uiatbleviewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58.0;
}

-(void)sendButton:(id)sender
{
//    UIButton *button = (UIButton *)sender;
//    NSInteger buttonTag = button.tag;
    BOOL flag = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sms://"]];
    if (flag) {
        [self sendSMS:self.passStr recipientList:nil];
    }else{
        
    }
    
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
        [self presentViewController:controller animated:YES completion:nil];
    }
}
// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"Message sent");
    else
        NSLog(@"Message failed");
}


//导航栏左右按钮
-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
