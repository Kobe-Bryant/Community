//
//  ASIWebServer.m
//  AppPark
//
//  Created by long on 12-6-12.
//  Copyright 2012 Unite Power. All rights reserved.
//

#import "ASIWebServer.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "JSONKit.h"

static ASIWebServer *sharedController = nil;
@implementation ASIWebServer

@synthesize delegate;

+ (ASIWebServer *)shareController
{
    if (!sharedController) {
        sharedController = [[ASIWebServer alloc] init];
    }
    return sharedController;
}
-(id) init
{
    self = [super init];
    
    if ( self )
    {
        if ( _networkQueue == nil )
        {
            _networkQueue = [[ASINetworkQueue alloc] init];
            
            [_networkQueue setDelegate:self];
            [_networkQueue setShouldCancelAllRequestsOnFailure:NO];
            [_networkQueue setRequestDidFinishSelector:@selector(requestFinished:)];
            [_networkQueue setRequestDidFailSelector:@selector(requestFailed:)];
            [_networkQueue setQueueDidFinishSelector:@selector(queueFinished:)];
        }
        
    }
    
    return self;
}
-(void) dealloc
{
    if ( _networkQueue != nil )
    {
        [_networkQueue cancelAllOperations];
        
        SAFE_RELEASE( _networkQueue );
    }

    
    [super dealloc];
}
-(void) cancel:(id)callBackDelegate
{
    if ( _networkQueue != nil )
    {
        for(ASIHTTPRequest *request in _networkQueue.operations)
        {
            if([request.callBackDelegate isKindOfClass:[callBackDelegate class]])
            {
                request.callBackDelegate = nil;
                [request clearDelegatesAndCancel];
                return;
            }
        }
    }
}
- (void)queueFinished:(ASIHTTPRequest *)request
{
    if ([_networkQueue requestsCount] == 0)
    {
        //[self setNetworkQueue:nil];
        
        //[GlobalApi hideWaitActivityView];
    }
    NSLog(@"队列请求完成\n");
}

- (NSString *)utf8String:(NSString *)urlString{
    NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL,  kCFStringEncodingUTF8 );
    
    return encodedString;
}
#pragma mark -

- (ASIHTTPRequest *)CallWebServiceWithEnvironment:(NSString *)urlStr
                                     byMethodName:(NSString *)methodName
                                    bodyUrlString:(NSString *)bodyUrlString{
    NSString *strUrl =[NSString stringWithFormat:@"%@%@%@",urlStr,methodName,bodyUrlString];
    strUrl = [self utf8String:strUrl];
    //NSString* webStringURL = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //	//请求发送到的路径
    NSURL *url = [NSURL URLWithString:strUrl];
    NSLog(@"startConnect url %@",url);
	ASIHTTPRequest * theRequest = [ASIHTTPRequest requestWithURL:url];
    [theRequest setRequestMethod:@"POST"];
	[theRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    return theRequest;
}

-(void)sendRequestWithEnvironment:(NSString *)url
                    bodyUrlString:(NSString *)bodyUrlString
                     byMethodName:(NSString *)methodName
                      byInterface:(WInterface)interface
               byCallBackDelegate:(id)callBackDelegate
                         showLoad: (BOOL) showLoad{
    [self sendRequestWithEnvironment:url bodyUrlString:bodyUrlString byMethodName:methodName byInterface:interface byCallBackDelegate:callBackDelegate SSL:NO showLoad:showLoad];
}

-(void)sendRequestWithEnvironment:(NSString *)url
                    bodyUrlString:(NSString *)bodyUrlString
                     byMethodName:(NSString *)methodName
                      byInterface:(WInterface)interface
               byCallBackDelegate:(id)callBackDelegate
                              SSL:(BOOL)isEncrypt
                         showLoad: (BOOL) showLoad{
    
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if (![reach isReachable]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"当前网络不可用，请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];\
        [alertView show];
        [alertView release];
    }
    
    
    if ( showLoad )  //显示加载等待窗口
    {
        [Global showLoadingProgressViewWithText:@"正在加载..."];
    }
    //创建请求
    ASIHTTPRequest * theRequest = [self CallWebServiceWithEnvironment:url byMethodName:methodName bodyUrlString:bodyUrlString];
	
    theRequest.wInterface = interface;
    theRequest.callBackDelegate = callBackDelegate;
    theRequest.action = methodName;
    //显示网络请求信息在status bar上
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
	
    if (isEncrypt) {
        [theRequest setValidatesSecureCertificate:NO];  //请求https的时候，就要设置这个属性
    }
    //同步调用  resp*****eString
    //[theRequest startSynchronous];
    [_networkQueue addOperation:theRequest];
    [_networkQueue go];
    
}

- (void)postMultipartWithEnvironment:(NSString *)url
                    bodyUrlString:(NSString *)bodyUrlString
                     byMethodName:(NSString *)methodName
                      byInterface:(WInterface)interface
               byCallBackDelegate:(id)callBackDelegate
                            showLoad: (BOOL) showLoad{
    if ( showLoad )  //显示加载等待窗口
    {
        [Global showLoadingProgressViewWithText:@"正在加载..."];
    }

    NSString *strUrl =[NSString stringWithFormat:@"%@%@%@",url,methodName,bodyUrlString];
    strUrl = [self utf8String:strUrl];
    //	//请求发送到的路径
    NSURL *postUrl = [NSURL URLWithString:strUrl];
    
    NSLog(@"startConnect url %@",url);
    
    ASIFormDataRequest *foramDataRequest = [ASIFormDataRequest requestWithURL:postUrl];
    [foramDataRequest setRequestMethod:@"POST"];
	[foramDataRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    foramDataRequest.wInterface = interface;
    foramDataRequest.callBackDelegate = callBackDelegate;
    foramDataRequest.action = methodName;
    [foramDataRequest setPostFormat:ASIMultipartFormDataPostFormat];
    //显示网络请求信息在status bar上
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
	
    //同步调用  resp*****eString
    //[theRequest startSynchronous];
    [_networkQueue addOperation:foramDataRequest];
    [_networkQueue go];
    
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString* response = [request responseString];
    NSLog(@"response %@",response);
    
    NSDictionary *dictionary = [response objectFromJSONString];
    NSString *status = [dictionary objectForKey:@"errorCode"];
    if ( request.callBackDelegate && [request.callBackDelegate respondsToSelector:@selector(callBackWith:status:data:)])
    {
        [request.callBackDelegate callBackWith: request.wInterface status: status data: dictionary];
    }
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString* response = [request responseString];
    NSLog(@"response %@",response);
    
    NSDictionary *dictionary = [response objectFromJSONString];
    NSString *status = [dictionary objectForKey:@"errorCode"];
    
    if(request.responseStatusCode > 400 && request.responseStatusCode != 408){
        NSLog(@"%@",request.responseStatusMessage);
        [Global hideProgressViewForType:failed message:@"服务器繁忙,请稍后再试" afterDelay:1.0f];
    }else if (request.responseStatusCode == 408){
        [Global hideProgressViewForType:failed message:@"网络连接不太顺畅,超时了,请重试" afterDelay:1.0f];
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([[dictionary objectForKey:@"pointContent"] length]!=0) {
        [Global showMBProgressHudHint:self SuperView:appDelegate.window Msg:[dictionary objectForKey:@"pointContent"] ShowTime:0.5];
    }    
    if (request.callBackDelegate && [request.callBackDelegate respondsToSelector:@selector(callBackWith:status:data:)])
    {
        [request.callBackDelegate callBackWith: request.wInterface status:status data:dictionary];
    }
    
}



@end
