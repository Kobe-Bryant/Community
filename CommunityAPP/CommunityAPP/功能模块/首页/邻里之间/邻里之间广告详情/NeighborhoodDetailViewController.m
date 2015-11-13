//
//  NeighborhoodDetailViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-4-27.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "NeighborhoodDetailViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "UIViewController+NavigationBar.h"
#import "MobClick.h"

@interface NeighborhoodDetailViewController ()

@end

@implementation NeighborhoodDetailViewController
@synthesize adModel = _adModel;

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
    [MobClick beginLogPageView:@"NeighborhoodDetailPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"NeighborhoodDetailPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"广告详情"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    

    if ([_adModel.adActionType isEqualToString:@"URL"]) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, MainHeight)];
        
        webView.delegate = self;
        
        webView.scalesPageToFit = YES;
        
        [self.view addSubview:webView];
        
        NSURL *url =[NSURL URLWithString:_adModel.adActionValue];
        
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        
        [webView loadRequest:request];
        [webView release];
    }else{
        //滚动视图
        contentScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, MainHeight)] ;
        contentScrollView.delegate  = self;
        contentScrollView.showsHorizontalScrollIndicator = NO;
        contentScrollView.showsVerticalScrollIndicator = NO;
        contentScrollView.scrollsToTop = NO;
        [contentScrollView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:contentScrollView];
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        NSString *filePath =[resourcePath stringByAppendingPathComponent:@"detailpageContent.html"];
        NSString *htmlstring=[[NSString alloc] initWithContentsOfFile:filePath  encoding:NSUTF8StringEncoding error:nil];
        NSString *newContent =[htmlstring stringByReplacingOccurrencesOfString:@"${content}" withString:_adModel.adActionValue];
        [htmlstring  release]; //add vincent 内存释放
        
        UIWebView *contentWebView = [[UIWebView alloc]init];
        contentWebView.frame = CGRectMake(0, 0, 320, 50);
        contentWebView.scalesPageToFit = NO;
        contentWebView.delegate = self;
        contentWebView.scrollView.scrollEnabled = NO;
        NSString *path1 = [[NSBundle mainBundle] resourcePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path1];
        [contentWebView loadHTMLString:newContent baseURL:baseURL];
        [contentScrollView addSubview:contentWebView];
        [contentWebView release];
    }
    //加载网络数据
    [self hideHudView];
    hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];//  请求验证验证码是否正确
}
#pragma mark - uiwebViewdelegate
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideHudView];
    NSString *curHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
	CGRect newFrame = webView.frame;
	newFrame.size.height = [curHeight floatValue];
	webView.frame = newFrame;
    contentScrollView.contentSize = CGSizeMake(ScreenWidth, webView.frame.size.height);
    
}

-(void)backBtnAction{
    [self.navigationController  popViewControllerAnimated:YES];
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
