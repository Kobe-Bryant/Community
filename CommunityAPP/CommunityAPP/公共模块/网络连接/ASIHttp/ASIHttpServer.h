//
//  ASIHttpServer.h
//  AppPark
//
//  Created by UPMAC001 on 12-8-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASIHttpServer : NSObject

+(NSString *)request:(NSString *)url error:(NSError **)err;
+(NSString *)request1:(NSString *)url with:(NSDictionary *)dic error:(NSError **)err;
@end
