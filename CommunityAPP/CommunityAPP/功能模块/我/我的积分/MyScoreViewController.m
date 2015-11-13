//
//  MyScoreViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-13.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "MyScoreViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "UserModel.h"
#import "UIViewController+NavigationBar.h"
#import "MobClick.h"

@interface MyScoreViewController ()

@end

@implementation MyScoreViewController

- (void)dealloc{
    webView.delegate = nil;
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
    [MobClick beginLogPageView:@"MyScorePage"]; // 友盟统计
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MyScorePage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    [self.view setBackgroundColor:RGB(241, 241, 241)];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"我的积分"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    UserModel *userModel = [UserModel shareUser];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth,MainHeight)];
    [webView setDelegate:self];
    webView.scalesPageToFit = YES;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",HTTPURLPREFIX,My_INTEGRAL,userModel.userId]]];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView setCenter:self.view.center];
    [self.view addSubview:indicatorView];
}


//导航栏左按钮
-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
