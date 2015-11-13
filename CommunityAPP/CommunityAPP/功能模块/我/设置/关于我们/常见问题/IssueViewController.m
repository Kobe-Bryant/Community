//
//  IssueViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-5-24.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "IssueViewController.h"
#import "UIViewController+NavigationBar.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "UserModel.h"
#import "MobClick.h"

@interface IssueViewController ()

@end

@implementation IssueViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    webView.delegate = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"IssuePage"]; // 友盟统计
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"IssuePage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:RGB(244, 244, 244)];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"常见问题"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //UserModel *userModel = [UserModel shareUser];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth,MainHeight)];
    [webView setDelegate:self];
    webView.scalesPageToFit = YES;
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/web/about/issue.do?%@=%@&%@=%@&%@=%@",HTTPURLPREFIX,USER_ID,userModel.userId,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/web/about/issue.do",HTTPURLPREFIX]]];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    [webView release];
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView setCenter:self.view.center];
    [self.view addSubview:indicatorView];
    [indicatorView release];
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
#pragma mark - UIWebViewDelegate Methods

- (void)webViewDidStartLoad:(UIWebView *)aWebView{
	[indicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView{
	[indicatorView stopAnimating];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error{
    [indicatorView stopAnimating];
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
