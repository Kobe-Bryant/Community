//
//  NoticeDetailViewController.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-5.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "NoticeDetailViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "SesameGlobalWebView.h"
#import "UIViewController+NavigationBar.h"
#import "MobClick.h"

@interface NoticeDetailViewController ()

@end

@implementation NoticeDetailViewController
@synthesize noticeModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"NoticeDetailPage"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"NoticeDetailPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"详情"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];

    if ([noticeModel.noticeIsUrl integerValue]!=0) {
        SesameGlobalWebView *globalView = [[SesameGlobalWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, MainHeight) DataString:noticeModel.noticeContentLabel TitleString:noticeModel.noticeTitle];
        [contentScrollView addSubview:globalView];
        [globalView release];
    }else{
        //滚动视图
        contentScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, MainHeight)] ;
        contentScrollView.delegate  = self;
        contentScrollView.showsHorizontalScrollIndicator = NO;
        contentScrollView.showsVerticalScrollIndicator = NO;
        contentScrollView.scrollsToTop = NO;
        [contentScrollView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:contentScrollView];
        
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        NSString *filePath =[resourcePath stringByAppendingPathComponent:@"detailpage.html"];
        NSString *htmlstring=[[NSString alloc] initWithContentsOfFile:filePath  encoding:NSUTF8StringEncoding error:nil];

        NSString *newTitle = [htmlstring stringByReplacingOccurrencesOfString:@"${title}" withString:noticeModel.noticeTitle];
        [htmlstring release];//add Vincent 内存释放
        NSString *newContent =[newTitle stringByReplacingOccurrencesOfString:@"${content}" withString:noticeModel.noticeContent];

        UIWebView *contentWebView = [[UIWebView alloc]init];
        contentWebView.frame = CGRectMake(0, 0, 320, 50);
        contentWebView.delegate = self;
        contentWebView.scalesPageToFit = NO;
        contentWebView.scrollView.scrollEnabled = NO;
        NSString *path1 = [[NSBundle mainBundle] resourcePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path1];
        [contentWebView loadHTMLString:newContent baseURL:baseURL];
        [contentScrollView addSubview:contentWebView];
        [contentWebView release];
    }
}
#pragma mark - uiwebViewdelegate
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    curHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
	CGRect newFrame = webView.frame;
	newFrame.size.height = [curHeight floatValue];
	webView.frame = newFrame;
    //  NSLog(@"webViewDidFinishLoad webView %@",webView);
    contentScrollView.contentSize = CGSizeMake(ScreenWidth, webView.frame.size.height);
                                               
}

//返回
-(void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
