//
//  BankDataController.m
//  PABank
//
//  Created by pingan_tiger on 11-4-22.
//  Copyright 2011 pingan. All rights reserved.
//

#import "NetController.h"
#import "Connection_Parser.h"

@implementation NetController

static NetController *netController = NULL;
+ (NetController*)shareNetController {
	@synchronized(self)
	{
		if (netController == nil) {
			netController = [[NetController alloc] init];
		}
		return netController;
	}
}

- (id)init {
	if (self = [super init]) {
		connectionArray = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)sendRequestWithEnvironment:(NSString *)environmentString	
                         URLString:(NSString *)urlTypeString
                              Body:(NSString*)bodyString				//请求的body
                  CallBackDelegate:(id)callBackDelegate				//请求的回调对象
             RemovePreviousRequest:(BOOL)remove typeConnect:(NSString *)typeConnectString
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    Connection_Parser *con_par = [[Connection_Parser alloc] initWithConnectString:environmentString URLString:urlTypeString BodyString:bodyString CallBack:callBackDelegate typeConnect:typeConnectString];
    [connectionArray addObject:con_par];
    [con_par release];

}

//移除所有的请求，用于入口选择界面或者一级模块间的切换
- (void)removeAllRequest {
	for (int i=0; i<[connectionArray count]; i++) {
		Connection_Parser *con_par_Item = [connectionArray objectAtIndex:i];		
		if (i==0) [con_par_Item stop];
	}
	[connectionArray removeAllObjects];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (NSString*)getStringByKey:(NSString*)key From:(NSString*)bodyString {
	NSArray *array = [bodyString componentsSeparatedByString:@"&"];
	for (int i=0; i<[array count]; i++) {
		NSString *item = [array objectAtIndex:i];
		NSRange locate = [item rangeOfString:@"="];
		if ([[item substringToIndex:locate.location] isEqualToString:key]) {
			return [item substringFromIndex:locate.location+1];
		}
	}
	return nil;
}
- (void)dealloc {
	[connectionArray release];
	[super dealloc];
}

@end
