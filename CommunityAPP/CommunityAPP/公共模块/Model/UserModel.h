//
//  UserModel.h
//  CommunityAPP
//
//  Created by Stone on 14-3-11.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppConfig.h"
@interface UserModel : NSObject<NSCoding>

+ (UserModel *)shareUser;

@property (nonatomic, retain) NSString *userName;       //用户名

@property (nonatomic, retain) NSString *communityId;    //社区Id

@property (nonatomic, retain) NSString *propertyId;     //物业Id

@property (nonatomic, retain) NSString *userId;         //用户Id

@property (nonatomic, retain) NSString *token;          //token

@property (nonatomic, retain) NSString *communityName;  //小区名称

- (void)saveUserInfo;

- (void)getUserInfo;

- (void)clearUserInfo;

+ (BOOL)isLogin;

@end
