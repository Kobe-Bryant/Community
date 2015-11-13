//
//  BankDataController.h
//  PABank
//
//  Created by pingan_tiger on 11-4-22.
//  Copyright 2011 pingan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetController : NSObject {
	
	NSMutableArray *connectionArray;
}

+ (NetController*)shareNetController;

- (void)sendRequestWithEnvironment:(NSString *)environmentString	
				  URLString:(NSString *)urlTypeString			
					 Body:(NSString*)bodyString				//请求的body
		 CallBackDelegate:(id)callBackDelegate				//请求的回调对象
             RemovePreviousRequest:(BOOL)remove //是否移除之前的请求
                      typeConnect:(NSString *)typeConnectString;
- (void)removeAllRequest;

@end
