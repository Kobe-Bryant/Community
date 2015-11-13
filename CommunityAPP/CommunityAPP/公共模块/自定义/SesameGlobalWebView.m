//
//  SesameGlobalWebView.m
//  Sesame
//
//  Created by 刘文龙 on 13-11-25.
//  Copyright (c) 2013年 刘文龙. All rights reserved.
//

#import "SesameGlobalWebView.h"
#import "NSObject_extra.h"
#import "Global.h"



@implementation SesameGlobalWebView
@synthesize webView;
-(void)dealloc{
    [contentScrollView release]; contentScrollView = nil;
    [webView release]; webView= nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame DataString:(NSString *)dataString TitleString:(NSString *)titleString
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIImage *bottomImage = [UIImage imageNamed:@"bg_bottom_Image.png"];
        //滚动视图
        contentScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, frame.size.height-bottomImage.size.height)] ;
        contentScrollView.delegate  = self;
        contentScrollView.showsHorizontalScrollIndicator = NO;
        contentScrollView.showsVerticalScrollIndicator = NO;
        contentScrollView.scrollsToTop = NO;
        [contentScrollView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:contentScrollView];
        
        UILabel *titleLabel = [self newLabelWithText:titleString frame:CGRectMake(0, 20, ScreenWidth, 20) font:[UIFont systemFontOfSize:18] textColor:[UIColor blackColor]];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [contentScrollView addSubview:titleLabel];
        [titleLabel release];
        
        UIImageView *imageView = [self newImageViewWithImage:[UIImage imageNamed:@"bg_speacter_line.png"] frame:CGRectMake(0, titleLabel.frame.size.height+titleLabel.frame.origin.y+10, ScreenWidth, 1)];
        [contentScrollView addSubview:imageView];
        [imageView release];
        
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, imageView.frame.size.height+imageView.frame.origin.y+10, ScreenWidth,contentScrollView.frame.size.height- imageView.frame.size.height+imageView.frame.origin.y+10)];
        webView.delegate = self;
        webView.scalesPageToFit = YES;
                NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:dataString]  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:40.0];
        [webView loadRequest:request];
        [contentScrollView addSubview:webView];
        
        contentScrollView.contentSize = CGSizeMake(320, webView.frame.size.height+webView.frame.origin.y+20);
        
        //底板的向前向后  刷新
        bottomImageView = [[UIImageView alloc] init];
        bottomImageView.frame = CGRectMake(0,contentScrollView.frame.origin.y+contentScrollView.frame.size.height, bottomImage.size.width, bottomImage.size.height);
        bottomImageView.image = bottomImage;
        [bottomImageView setUserInteractionEnabled:YES];
        [self addSubview:bottomImageView];
        [bottomImageView release];
        
        UIImage *goBackImage = [UIImage imageNamed:@"bg_normalImage_goback.png"];
        goBackBtn = [self  newButtonWithImage:goBackImage highlightedImage:[UIImage imageNamed:@"bg_highImage_goback.png"] frame:CGRectMake(10, 0, goBackImage.size.width, goBackImage.size.height) title:nil titleColor:nil titleShadowColor:nil font:nil target:self action:@selector(goBackBtnAction)];
        goBackBtn.enabled = NO;
        [bottomImageView addSubview:goBackBtn];
        
        UIImage *goForwardImage = [UIImage imageNamed:@"bg_normalImage_goForward.png"];
        goForwardBtn = [self  newButtonWithImage:goForwardImage highlightedImage:[UIImage imageNamed:@"bg_highImage_goForward.png"] frame:CGRectMake(10+goBackBtn.frame.size.width+20, goBackBtn.frame.origin.y, goForwardImage.size.width, goBackBtn.frame.size.height) title:nil titleColor:nil titleShadowColor:nil font:nil target:self action:@selector(goForwardBtnAction)];
        goForwardBtn.enabled = NO;
        [bottomImageView addSubview:goForwardBtn];
        
        UIImage *goRefreshImage = [UIImage imageNamed:@"bg_normalImage_refresh.png"];
        UIButton *goRefreshBtn = [self  newButtonWithImage:goRefreshImage highlightedImage:[UIImage imageNamed:@"bg_highImage_refresh.png"] frame:CGRectMake(goForwardBtn.frame.origin.x+goForwardBtn.frame.size.width+130, goBackBtn.frame.origin.y, goRefreshImage.size.width, goBackBtn.frame.size.height) title:nil titleColor:nil titleShadowColor:nil font:nil target:self action:@selector(goRefreshBtnAction)];
        [bottomImageView addSubview:goRefreshBtn];
    
    }
    return self;
}

-(void)goBackBtnAction{
    [webView goBack];
}

-(void)goForwardBtnAction{
    [webView goForward];
}

-(void)goRefreshBtnAction{
    [webView reload];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark - UIWebViewDelegate Methods
- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = request.URL;
    if (![url.scheme isEqual:@"http"] && ![url.scheme isEqual:@"https"]) {
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
            return NO;
        }
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)aWebView{
	if (aWebView == webView) {
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.frame = CGRectMake(145, 200, 30, 30);
        [self addSubview:indicatorView];
        [indicatorView startAnimating];
        [indicatorView release];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView{
    if (aWebView == webView){
        [indicatorView stopAnimating];
        [indicatorView removeFromSuperview];
        indicatorView = nil;
    }
    goBackBtn.enabled = [aWebView canGoBack];
    goForwardBtn.enabled = [aWebView canGoForward];
    
    NSString *curHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
	CGRect newFrame = webView.frame;
	newFrame.size.height = [curHeight floatValue];
	webView.frame = newFrame;
    NSLog(@"webViewDidFinishLoad webView %@",webView);
    
    contentScrollView.contentSize = CGSizeMake(320, webView.frame.size.height+webView.frame.origin.y+20);

}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error{
    if (aWebView == webView){
        [indicatorView stopAnimating];
        [indicatorView removeFromSuperview];
        indicatorView = nil;
    }
}


@end
