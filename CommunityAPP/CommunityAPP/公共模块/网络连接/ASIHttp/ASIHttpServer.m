//
//  ASIHttpServer.m
//  AppPark
//
//  Created by UPMAC001 on 12-8-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ASIHttpServer.h"
#import "ASIFormDataRequest.h"

@implementation ASIHttpServer
+(NSString *)request:(NSString *)url error:(NSError **)err{
	NSURL *requestURL = [NSURL URLWithString:url];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:requestURL];
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
    //同步调用  resp*****eString
    [request startSynchronous];
    
    NSError *error = nil;
    error = [request error];
    //    // 是否报错
    //    if ([request error]) {
    //        // 得到错误信息
    //        [showText setText:[[request error] localizedDescription]];
    if (!error)
    {
        NSData *data = [request responseData];
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *theXML = [[[NSString alloc] initWithData:data encoding:enc] autorelease];
        
        theXML = [theXML stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        theXML = [theXML stringByReplacingOccurrencesOfString:@" " withString:@""];
        return theXML;
    }
    else
    {
        *err = error;
        //出现调用错误，则使用错误前缀+错误描述
        return [error localizedDescription];
    }
}
+(NSString *)request1:(NSString *)url with:(NSDictionary *)dic error:(NSError **)err{
	NSURL *requestURL = [NSURL URLWithString:url];
	
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:requestURL];
    for (NSString *key in [dic allKeys]) {
        [request setPostValue:[NSString stringWithFormat:@"%@",[dic objectForKey:key]] forKey:key];
    }
    
    [request startSynchronous];
    //同步调用  resp*****eString
    //[request startSynchronous];
    NSError *error = nil;
    error = [request error];
    
    if (!error)
    {
        NSData *data = [request responseData];
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *theXML = [[[NSString alloc] initWithData:data encoding:enc] autorelease];
        
        theXML = [theXML stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        theXML = [theXML stringByReplacingOccurrencesOfString:@" " withString:@""];
        return theXML;
    }
    else
    {
        *err = error;
        //出现调用错误，则使用错误前缀+错误描述
        return [error localizedDescription];
    }
}
@end
