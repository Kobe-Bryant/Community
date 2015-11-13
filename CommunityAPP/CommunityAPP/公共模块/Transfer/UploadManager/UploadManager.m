//
//  UploadManager.m
//  CommunityAPP
//
//  Created by Stone on 14-4-9.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "UploadManager.h"
#import "ASIWebServer.h"
#import "JSONKit.h"

@implementation UploadManager

- (id)shareInstance{
    static UploadManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UploadManager alloc] init];
    });
    
    return instance;
}

- (id)init{
    self = [super init];
    if (self) {
        if (_networkQueue == nil) {
            _networkQueue = [[ASINetworkQueue alloc] init];
            [_networkQueue setDelegate:self];
            [_networkQueue setShouldCancelAllRequestsOnFailure:NO];
            [_networkQueue setRequestDidFinishSelector:@selector(requestFinished:)];
            [_networkQueue setRequestDidFailSelector:@selector(requestFailed:)];
            //[_networkQueue setQueueDidFinishSelector:@selector(queueFinished:)];
        }
    }
    
    return self;
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

- (NSString *)utf8String:(NSString *)urlString{
    NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL,  kCFStringEncodingUTF8 );
    
    return encodedString;
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
    if ( request.callBackDelegate && [request.callBackDelegate respondsToSelector:@selector(callBackWith:status:data:)])
    {
        [request.callBackDelegate callBackWith: request.wInterface status: status data: dictionary];
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
@end
