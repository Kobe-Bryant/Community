//
//  LuckDrawView.m
//  CommunityAPP
//
//  Created by yunlai on 14-4-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "LuckDrawView.h"
#import "UserModel.h"
#import "Global.h"
#import "LuckDrawViewController.h"



@implementation LuckDrawView

-(void)dealloc{
    [webView setDelegate:nil];
    [webView release]; webView = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame viewController:(id)viewController
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        lastViewController = viewController;
        
        UserModel *userModel = [UserModel shareUser];
        
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,320,frame.size.height)];
        [webView setDelegate:self];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",HTTPURLPREFIX,LUCKDRAW_My_LOTTERY,userModel.userId]]];
        webView.scalesPageToFit = YES;
        [webView loadRequest:request];
        [self addSubview:webView];
        
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicatorView setCenter:CGPointMake(160, 160)];
        [self addSubview:indicatorView];
    }
    return self;
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

- (void)webViewDidStartLoad:(UIWebView *)aWebView{
	[indicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView{
	[indicatorView stopAnimating];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error{
    [indicatorView stopAnimating];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType //这个方法是网页中的每一个请求都会被触发的
{
    //    yunlai://property/lottery/address/?winLogId=1956
    NSString *urlString = [[request URL] absoluteString];
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    if([urlComps count] && [[urlComps objectAtIndex:0]
                            isEqualToString:@"yunlai"])
    {
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps
                                                       objectAtIndex:1] componentsSeparatedByString:@":/"];
        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        if (1 == [arrFucnameAndParameter count])
        {
            NSRange foundObj=[funcStr rangeOfString:@"address" options:NSCaseInsensitiveSearch];
            if(foundObj.length>0) {
                /*调用本地函数1*/
                [lastViewController finishAddress];
            } else {
                NSLog(@"Oops ! no jap");
            }
        }
        return NO;
    };
    return YES;
}
@end
