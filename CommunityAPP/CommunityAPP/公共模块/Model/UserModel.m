//
//  UserModel.m
//  CommunityAPP
//
//  Created by Stone on 14-3-11.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "UserModel.h"
#import "NSFileManager+Community.h"
#import "AppConfig.h"

#define COMMUNITY_ID        @"communityId"
#define USER_ID             @"userId"
#define PROPERTY_ID         @"propertyId"
#define USERNAME            @"userName"
#define TOKEN               @"token"
#define COMMUNITY_NAME      @"communityName"

#define kDataKey            @"userInfo"

@interface UserModel ()

@property (nonatomic, retain) NSString *filePath;

@end

@implementation UserModel


@synthesize userId = _userId;
@synthesize propertyId = _propertyId;
@synthesize communityId = _communityId;
@synthesize token = _token;
@synthesize userName = _userName;

+ (UserModel *)shareUser
{
    static UserModel *user = nil;
    if (user == nil) {
        user = [[UserModel alloc] init];
        
    }
    return user;
}

- (id)init{
    self = [super init];
    if (self) {
        [self getUserInfo];
    }
    return self;
}

-(NSString *)userId{

    
    return _userId;
}

- (NSString *)communityId{

    return _communityId;
}

- (NSString *)propertyId{
    return _propertyId;
}




- (void)clearUserInfo{
    self.communityId = nil;
    self.userId = nil;
    self.propertyId = nil;
    self.token = nil;
    self.communityName = nil;
    [self saveUserInfo];
}

+ (BOOL)isLogin{
    if ([UserModel shareUser]) {
        if ([UserModel shareUser].userId.length > 0) {
            return YES;
        }
        
        return NO;
    }
    
    return NO;
}

#pragma mark ---
- (void)saveUserInfo{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:self.userId forKey:USER_ID];
    [userDefault setObject:self.userName forKey:USERNAME];
    [userDefault setObject:self.communityId forKey:COMMUNITY_ID];
    [userDefault setObject:self.propertyId forKey:PROPERTY_ID];
    [userDefault setObject:self.token forKey:TOKEN];
    [userDefault setObject:self.communityName forKey:COMMUNITY_NAME];
    [NSUserDefaults resetStandardUserDefaults];
    
    if ([UserModel isLogin]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCommunityLoginSucceedNotification object:self];
    }
    
    return;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dirPath = [fileManager applicationLibraryDirectory];
    self.filePath = [NSString stringWithFormat:@"%@/%@",dirPath,kDataKey];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:self.filePath atomically:YES];
    [archiver release];
    [data release];
}


- (void)getUserInfo{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.userId = [userDefault objectForKey:USER_ID];
    self.userName = [userDefault objectForKey:USERNAME];
    self.communityId = [userDefault objectForKey:COMMUNITY_ID];
    self.propertyId = [userDefault objectForKey:PROPERTY_ID];
    self.token = [userDefault objectForKey:TOKEN];
    self.communityName = [userDefault objectForKey:COMMUNITY_NAME];
    return;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dirPath = [fileManager applicationLibraryDirectory];
    
    self.filePath = [NSString stringWithFormat:@"%@/%@",dirPath,kDataKey];

    NSData *codedData = [[[NSData alloc] initWithContentsOfFile:self.filePath] autorelease];
    if (codedData == nil)
        return;
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    self = [unarchiver decodeObjectForKey:kDataKey];
    [unarchiver finishDecoding];
    [unarchiver release];
}


#pragma mark ----

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.communityId forKey:COMMUNITY_ID];
    [aCoder encodeObject:self.userId forKey:USER_ID];
    [aCoder encodeObject:self.propertyId forKey:PROPERTY_ID];
    [aCoder encodeObject:self.userName forKey:USERNAME];
    [aCoder encodeObject:self.token forKey:TOKEN];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [UserModel shareUser];
    if (self) {
        self.userId = [aDecoder decodeObjectForKey:USER_ID];
        self.userName = [aDecoder decodeObjectForKey:USERNAME];
        self.communityId = [aDecoder decodeObjectForKey:COMMUNITY_ID];
        self.propertyId = [aDecoder decodeObjectForKey:PROPERTY_ID];
        self.token = [aDecoder decodeObjectForKey:TOKEN];
    }
    
    return self;
}


@end
