//
//  AwardDetailViewController.m
//  CommunityAPP
//
//  Created by yunlai on 14-4-22.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "AwardDetailViewController.h"
#import "NSObject_extra.h"
#import "Global.h"
#import "UIViewController+NavigationBar.h"
#import "MobClick.h"

@interface AwardDetailViewController ()

@end

@implementation AwardDetailViewController
@synthesize model;

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
    [MobClick beginLogPageView:@"AwardDetailPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"AwardDetailPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"奖品详情"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
//    是否为URL，默认值为0（不是），取值0/1
    if ([self.model.isUrlString intValue]==0) {
        contentScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, MainHeight)] ;
        contentScrollView.showsHorizontalScrollIndicator = NO;
        contentScrollView.showsVerticalScrollIndicator = NO;
        contentScrollView.scrollsToTop = NO;
        [contentScrollView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:contentScrollView];
        [contentScrollView release];
        
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        NSString *filePath =[resourcePath stringByAppendingPathComponent:@"detailpageContent.html"];
        NSString *htmlstring=[[NSString alloc] initWithContentsOfFile:filePath  encoding:NSUTF8StringEncoding error:nil];
        NSString *newContent =[htmlstring stringByReplacingOccurrencesOfString:@"${content}" withString:self.model.contentString];
        [htmlstring  release]; //add vincent 内存释放

        UIWebView *contentWebView = [[UIWebView alloc]init];
        contentWebView.frame = CGRectMake(5, 0, 310, MainHeight);
        contentWebView.scalesPageToFit = NO;
        contentWebView.delegate = self;
        contentWebView.scrollView.scrollEnabled = NO;
        NSString *path1 = [[NSBundle mainBundle] resourcePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path1];
        [contentWebView loadHTMLString:newContent baseURL:baseURL];
        [contentScrollView addSubview:contentWebView];
        [contentWebView release];
    }else{
        UIWebView *urlWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth,MainHeight)];
        [urlWebView setDelegate:self];
        urlWebView.scalesPageToFit = YES;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.model.contentString]];
        [urlWebView loadRequest:request];
        [self.view addSubview:urlWebView];
    }
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView setCenter:self.view.center];
    [self.view addSubview:indicatorView];
}

//返回导航按钮
-(void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma mark - UIWebViewDelegate Methods

- (void)webViewDidStartLoad:(UIWebView *)aWebView{
	[indicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView{
	[indicatorView stopAnimating];
    
    CGRect newFrame = aWebView.frame;
	newFrame.size.height = [[aWebView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] floatValue];
	aWebView.frame = newFrame;
    contentScrollView.contentSize = CGSizeMake(ScreenWidth, aWebView.frame.size.height);
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error{
    [indicatorView stopAnimating];
}


- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
@end
