//
//  MakePhoneCall.h
//  CommunityAPP
//
//  Created by liuzhituo on 14-3-7.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MakePhoneCall : NSObject

+ (MakePhoneCall *) getInstance;

- (BOOL) makeCall:(NSString *)phoneNumber;

@end
