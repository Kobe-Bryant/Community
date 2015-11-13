//
//  CMDefaultShare.h
//  ShareDemo
//
//  Created by Stone on 14-4-20.
//  Copyright (c) 2014年 Stone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>


#define kCMShareSinaWeiboSucceed        @"kCMShareSinaWeiboSucceed"         //新浪微博分享成功
#define kCMShareTencentWeiboSucceed     @"kCMShareTencentWeiboSucceed"      //腾讯微博分享成功
#define kCMShareWeChatTimelineSucceed   @"kCMShareWeChatTimelineSucceed"    //朋友圈分享成功
#define kCMShareWeChatSessionSucceed    @"kCMShareWeChatSessionSucceed"     //好友分享成功
#define kCMShareCopySucceed             @"kCMShareCopySucceed"              //复制链接成功
#define kCMShareMailSucceed             @"kCMShareMailSucceed"              //邮件分享成功
#define kCMShareSMSSucceed              @"kCMShareSMSSucceed"              

@protocol CMShareDelegate <NSObject>

@optional
- (void)shareWithType:(ShareType)shareType;
- (void)shareCancel;
- (void)shareSuccess;
- (void)shareFail;

@end

@interface CMDefaultShare : NSObject

@property (nonatomic, retain) NSMutableArray *shareList;
@property (nonatomic, assign) id<CMShareDelegate> delegate;

+(id)shareInstance;

- (void)popInController:(UIViewController *)viewController delegate:(id)delegate;

@end

@interface ShareSDK (SharePlatform)

/**
 *  分享到微信平台：
 *
 *  @param nsText    分享的内容
 *  @param shareType 分享的类型 ShareTypeWeixiSession:好友 ShareTypeWeixiTimeline:朋友圈
 */
+ (void)shareWeChat:(NSString *)nsText type:(ShareType)shareType;


/**
 *  分享到微博
 *
 *  @param nsText    分享的文本内容
 *  @param shareType 分享的类型 ShareTypeSinaWeibo:新浪微博 ShareTypeTencentWeibo:朋友圈
 */
+ (void)shareWeibo:(NSString *)nsText type:(ShareType)shareType;

/**
 *  分享邮件
 *
 *  @param nsText 分享的内容
 */
+ (void)shareSendMail:(NSString *)nsText;

/**
 *  分享拷贝连接
 *
 *  @param nsText 拷贝连接的内容
 */
+ (void)shareCopy:(NSString *)nsText;

/**
 *  分享短信
 *
 *  @param nsText 短信的内容
 */
+ (void)shareSendSMS:(NSString *)nsText;

@end
