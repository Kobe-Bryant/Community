//
//  CMBPNotification.h
//  CommunityAPP
//
//  Created by Stone on 14-5-27.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>

//
typedef NS_ENUM(NSInteger, CMBPNotificationType){
    CMBPNotificationNone = 0,    //无类型
    CMBPNotice  = 1,       //服务端通知
    CMBPMyComments,           //评论
    CMBPMyBills,              //账单    
};

#define kCMBPNotice                     @"kCMBPNotice"
#define kCMBPMyComments                 @"kCMBPMyComments"
#define kCMBPMyBills                    @"kCMBPMyBills"
#define kCMBPRules                      @"kCMBPRules"

@interface CMBPNotification : NSObject

@property (nonatomic, retain) NSMutableArray *noticesArray;
@property (nonatomic, retain) NSMutableArray *myComments;
@property (nonatomic, retain) NSMutableArray *myBills;
@property (nonatomic, retain) NSMutableArray *ruleRegulations;

@property (nonatomic, assign) BOOL isCommentRead;
@property (nonatomic, assign) BOOL isBillRead;

+ (CMBPNotification *)shareInstance;

- (void)applicationLaunchNotification;

- (void)requestCommunityNotification;

- (void)requestMyBills;

- (void)requestMyPublish;

- (void)requestMyComments;

- (void)requestRuleRegulations;

@end
