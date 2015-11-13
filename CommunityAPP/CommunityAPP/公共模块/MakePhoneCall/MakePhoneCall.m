//
//  MakePhoneCall.m
//  CommunityAPP
//
//  Created by liuzhituo on 14-3-7.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "MakePhoneCall.h"

@interface MakePhoneCall ()

@property (nonatomic, retain) UIWebView *phoneCallWebView;

@end

@implementation MakePhoneCall


//获取单例
+ (MakePhoneCall *) getInstance
{
    static MakePhoneCall *singlonInstance = nil;
    @synchronized(self)
    {
        if (singlonInstance == nil)
        {
            
            singlonInstance = [[self alloc] init];
        }
    }
    return singlonInstance;
}

//copy返回单例本身
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

//retain返回单例本身
- (id)retain
{
    return self;
}

//引用计数总是为1
- (NSUInteger)retainCount
{
    return 1;
}

////release不做任何处理
//- (void)release
//{
//
//}

//autorelease返回单例本身
- (id)autorelease
{
    return self;
}


//打电话
- (BOOL) makeCall:(NSString *)phoneNumber
{
    if (phoneNumber==nil ||[phoneNumber isEqualToString:@""])
    {
        return NO;
    }
    BOOL call_ok = false;
    NSString *numberAfterClear = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", numberAfterClear]];
    NSLog(@"make call, URL=%@", phoneNumberURL);
    
    
    if ( !_phoneCallWebView ) {
        _phoneCallWebView = [[UIWebView alloc]initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来 效果跟方法二一样 但是这个方法是合法的
    }
    [_phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneNumberURL]];
    
    call_ok = [[UIApplication sharedApplication] canOpenURL:phoneNumberURL];
    
    return call_ok;
}


@end
