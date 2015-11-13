//
//  ASIWebServer.h
//  AppPark
//
//  Created by long on 12-6-12.
//  Copyright 2012 Unite Power. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "Global.h"
#import "AppDelegate.h"

@protocol WebServiceHelperDelegate;
@interface ASIWebServer : NSObject
{
    ASINetworkQueue*  _networkQueue;
}
@property(nonatomic, assign) id<WebServiceHelperDelegate> delegate;
+ (ASIWebServer *)shareController;

- (ASIHTTPRequest *)CallWebServiceWithEnvironment:(NSString *)urlStr
					  byMethodName:(NSString *)methodName
                                    bodyUrlString:(NSString *)bodyUrlString;

-(void)sendRequestWithEnvironment:(NSString *)url       //域名
               bodyUrlString:(NSString *)bodyUrlString  //url的参数
        byMethodName:(NSString *)methodName             //通信接口
         byInterface:(WInterface)interface              //通信接口的枚举标识
  byCallBackDelegate:(id)callBackDelegate               //回调代理
            showLoad: (BOOL) showLoad;                  //是否加载菊花

-(void)sendRequestWithEnvironment:(NSString *)url
                    bodyUrlString:(NSString *)bodyUrlString
                     byMethodName:(NSString *)methodName
                      byInterface:(WInterface)interface
               byCallBackDelegate:(id)callBackDelegate
                              SSL:(BOOL)isEncrypt
                         showLoad: (BOOL) showLoad;

-(void) cancel:(id)callBackDelegate;

@end

@protocol WebServiceHelperDelegate <NSObject>

@optional
-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data;

@end