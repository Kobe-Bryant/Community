//
//  FeedBackViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-5-21.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "FeedBackViewController.h"
#import "UIViewController+NavigationBar.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "ASIFormDataRequest.h"
#import "UserModel.h"
#import "JSONKit.h"
#import "MobClick.h"

@interface FeedBackViewController ()

@end

@implementation FeedBackViewController

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
    [MobClick beginLogPageView:@"FeedBackPage"]; // 友盟统计
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"FeedBackPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     [self.view setBackgroundColor:RGB(244, 244, 244)];
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"意见反馈"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"发送" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(280,0,60,44);
    [self setRightBarButtonItem:rightBtn];
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 15, 300, 235)];
    textView.layer.borderWidth = 0.5f;
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.font = [UIFont systemFontOfSize:14.0];
    textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//返回导航按钮
-(void)backBtnAction{
    [textView resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightBtnAction{
    [textView resignFirstResponder];
    if (textView.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"意见反馈不能为空" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }else{
        [self requestAddAuction];
    }
    
}

#pragma mark ---network
- (void)requestAddAuction{
     hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *str = HTTPURLPREFIX;  //@"http://192.168.2.46:8080/property";
        NSString *urlString = [str stringByAppendingString:MY_ADDVICE_POST];
        
        UserModel *userModel = [UserModel shareUser];
        
        ASIFormDataRequest *uploadImageRequest= [ ASIFormDataRequest requestWithURL:[NSURL URLWithString:[urlString   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [uploadImageRequest setStringEncoding:NSUTF8StringEncoding];
        [uploadImageRequest setRequestMethod:@"POST"];
        [uploadImageRequest setPostValue:userModel.userId forKey:@"userId"];
        [uploadImageRequest setPostValue:textView.text forKey:@"content"];
        [uploadImageRequest setPostValue:@"4" forKey:@"os"];
        [uploadImageRequest setPostValue:APP_VERSION forKey:@"appVersion"];
        [uploadImageRequest setPostFormat:ASIMultipartFormDataPostFormat];
        [uploadImageRequest setDelegate : self ];
        [uploadImageRequest setDidFinishSelector : @selector (responseComplete:)];
        [uploadImageRequest setDidFailSelector : @selector (responseFailed:)];
        [uploadImageRequest startAsynchronous];
        
    });
}

- (void)responseComplete:(ASIFormDataRequest *)request{
    [self hideHudView];
    NSString* response = [request responseString];
    NSLog(@"response %@",response);
    request.delegate = nil;
    NSDictionary *dictionary = [response objectFromJSONString];
    NSString *code = [dictionary objectForKey:@"errorCode"];
    if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
        [Global hideProgressViewForType:success message:@"反馈成功" afterDelay:1.0f];
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [Global hideProgressViewForType:failed message:@"反馈失败" afterDelay:1.0f];
    }
    
}

- (void)responseFailed:(ASIFormDataRequest *)request{
    [self hideHudView];
    NSString* response = [request responseString];
    NSLog(@"response %@",response);
    request.delegate = nil;
    NSDictionary *dictionary = [response objectFromJSONString];
    NSString *code = [dictionary objectForKey:@"errorCode"];
    if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
        [Global hideProgressViewForType:success message:@"反馈成功" afterDelay:1.0f];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [Global hideProgressViewForType:failed message:@"反馈失败" afterDelay:1.0f];
    }
}
- (void) hideHudView
{
    if (hudView) {
        [hudView hide:YES];
    }
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
