//
//  CMDefaultShare.m
//  ShareDemo
//
//  Created by Stone on 14-4-20.
//  Copyright (c) 2014年 Stone. All rights reserved.
//

#import "CMDefaultShare.h"
#import <ShareSDK/ShareSDK.h>
#import "CMActionSheet.h"
#import "CMActionSheetCell.h"



@interface CMDefaultShare ()<CMActionSheetDelegate>

@end

@implementation CMDefaultShare

@synthesize shareList = _shareList;

+(id)shareInstance{
    static CMDefaultShare *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CMDefaultShare alloc] init];
    });
    
    return instance;
}

- (void)dealloc{
    [super dealloc];
}

- (id)init{
    self = [super init];
    if (self) {
        self.shareList = [[NSMutableArray alloc] initWithCapacity:7];
        
        //新浪微博
        ShareItemModel *sinaWeibo = [[[ShareItemModel alloc] initWithIcon:@"sinaweibo_share_store.png"
                                                                    title:@"微博"
                                                                shareType:ShareTypeSinaWeibo] autorelease];
        ShareItemModel *tencentWeibo = [[[ShareItemModel alloc] initWithIcon:@"txweibo_share_store.png"
                                                                       title:@"腾讯微博"
                                                                   shareType:ShareTypeTencentWeibo] autorelease];
        ShareItemModel *weChatSession = [[[ShareItemModel alloc] initWithIcon:@"txmicro_share_store.png"
                                                                        title:@"微信好友"
                                                                    shareType:ShareTypeWeixiSession] autorelease];
        ShareItemModel *weChatTimeline = [[[ShareItemModel alloc] initWithIcon:@"txcircle_share_store.png" title:@"微信朋友圈" shareType:ShareTypeWeixiTimeline] autorelease];
        
        ShareItemModel *sms = [[[ShareItemModel alloc] initWithIcon:@"sms_share_store.png" title:@"短信" shareType:ShareTypeSMS] autorelease];
        
        ShareItemModel *mail = [[[ShareItemModel alloc] initWithIcon:@"mail_share_store.png"
                                                               title:@"邮件"
                                                           shareType:ShareTypeMail] autorelease];
        
        ShareItemModel *copy = [[[ShareItemModel alloc] initWithIcon:@"copy_share_store.png"
                                                               title:@"复制链接"
                                                           shareType:ShareTypeCopy] autorelease];
        
        
        [self.shareList addObject:weChatSession];
        [self.shareList addObject:weChatTimeline];
        [self.shareList addObject:tencentWeibo];
        [self.shareList addObject:sinaWeibo];
        [self.shareList addObject:sms];
        [self.shareList addObject:mail];
        [self.shareList addObject:copy];
        
    }
    return self;
}

- (void)popInController:(UIViewController *)viewController delegate:(id)delegate{
    self.delegate = delegate;
    CMActionSheet *sheet = [[CMActionSheet alloc] initwithIconSheetDelegate:self ItemCount:7];
    [sheet showInView:viewController.view];
    [sheet release];
}


- (int)numberOfItemsInActionSheet{
    return [self.shareList count];
}
- (CMActionSheetCell*)cellForActionAtIndex:(NSInteger)index{
    
    CMActionSheetCell* cell = [[[CMActionSheetCell alloc] init] autorelease];
    
    ShareItemModel *model = [self.shareList objectAtIndex:index];
    cell.iconView.image = [UIImage imageNamed:model.iconName];
    cell.titleLabel.text = model.title;
    cell.shareType = model.shareType;
    return cell;
    
}
- (void)DidTapOnItemAtIndex:(NSInteger)shareType{
    NSLog(@"tap on %d",shareType);
    
    if ([self.delegate respondsToSelector:@selector(shareWithType:)]) {
        [self.delegate shareWithType:shareType];
    }
    
    return;
    switch (shareType) {
        case ShareTypeSinaWeibo:    //新浪微博
            
            //[self shareSinaWeibo];
            
            break;
        case ShareTypeTencentWeibo: //腾讯微博
            //[self shareTencentWeibo];
            break;
        case ShareTypeWeixiSession: //微信
            
            break;
            
        case ShareTypeWeixiTimeline:    //朋友圈
            break;
            
        case ShareTypeSMS:      //短信
            break;
            
        case ShareTypeMail:     //邮件
            //[self shareSendMail];
            
            break;
        case ShareTypeCopy:     //复制链接
            
            break;
        default:
            break;
    }
    
}

- (void)dismissCancle{
    if ([self.delegate respondsToSelector:@selector(shareCancel)]) {
        [self.delegate shareCancel];
    }
}

@end

@implementation ShareSDK (SharePlatform)

//分享到微博平台
+ (void)shareWeibo:(NSString *)nsText type:(ShareType)shareType{
    if ([ShareSDK hasAuthorizedWithType:shareType])        //
    {
        //构造分享内容
        id<ISSContent> publishContent =
        [ShareSDK content:nsText
           defaultContent:nil
                    image:nil
                    title:nil
                      url:nil
              description:nil
                mediaType:SSPublishContentMediaTypeText];
        
        [ShareSDK shareContent:publishContent
                          type:shareType       //shareType
                   authOptions:nil
                 statusBarTips:YES
                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                            if (state == SSPublishContentStateSuccess)
                            {
                                NSLog(@"分享成功");
                                if (shareType == ShareTypeSinaWeibo) {              //新浪微博
                                    [ShareSDK postSinaWeiboSucceedNotification];
                                }else if (shareType == ShareTypeTencentWeibo){      //腾讯微博
                                    [ShareSDK postTencentWeiboSucceedNotification];
                                }
                            }
                            else if (state == SSPublishContentStateFail)
                            {
                                NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode],  [error errorDescription]);
                            }
                        }];
    }
    else
    {
        [ShareSDK authWithType:shareType
                   options:nil
                        result:^(SSAuthState state, id<ICMErrorInfo> error) {
                            
                            if (state == SSPublishContentStateSuccess)
                            {
                                //构造分享内容
                                id<ISSContent> publishContent = [ShareSDK content:nsText
                                                                   defaultContent:nil
                                                                            image:nil
                                                                            title:nil
                                                                              url:nil
                                                                      description:nil
                                                                        mediaType:SSPublishContentMediaTypeText];
                                
                                [ShareSDK shareContent:publishContent
                                                  type:shareType
                                           authOptions:nil
                                         statusBarTips:YES
                                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                    if (state == SSPublishContentStateSuccess)
                                                    {
                                                        NSLog(@"分享成功");
                                                        if (shareType == ShareTypeSinaWeibo) {              //新浪微博
                                                            [ShareSDK postSinaWeiboSucceedNotification];
                                                        }else if (shareType == ShareTypeTencentWeibo){      //腾讯微博
                                                            [ShareSDK postTencentWeiboSucceedNotification];
                                                        }
                                                    }
                                                    else if (state == SSPublishContentStateFail)
                                                    {
                                                        NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode],  [error errorDescription]);
                                                    }
                                                }];
                            }else{
                                NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode],  [error errorDescription]);
                            }
                        }];
        
        /*
        [ShareSDK authWithType:shareType
                       options:nil
                        result:^(SSAuthState state, id<ICMErrorInfo> error) {
                            if (state == SSPublishContentStateSuccess)
                            {
                                //构造分享内容
                                id<ISSContent> publishContent = [ShareSDK content:nsText
                                                                   defaultContent:nil
                                                                            image:nil
                                                                            title:nil
                                                                              url:nil
                                                                      description:nil
                                                                        mediaType:SSPublishContentMediaTypeNews];
                                
                                [ShareSDK shareContent:publishContent
                                                  type:shareType
                                           authOptions:nil
                                         statusBarTips:YES
                                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                    if (state == SSPublishContentStateSuccess)
                                                    {
                                                        NSLog(@"分享成功");
                                                    }
                                                    else if (state == SSPublishContentStateFail)
                                                    {
                                                        NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode],  [error errorDescription]);
                                                    }
                                                    
                                                }];
                            }
                        }];
        */
        
    }

}




+ (void)shareWeChat:(NSString *)nsText type:(ShareType)shareType{
    
    id<ISSContent> content = [ShareSDK content:nsText
                                defaultContent:nil
                                         image:nil
                                         title:nil
                                           url:nil
                                   description:nil
                                     mediaType:SSPublishContentMediaTypeText];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
//    //在授权页面中添加关注官方微博
//    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
//                                    nil]];
    
    [ShareSDK shareContent:content
                      type:shareType
               authOptions:authOptions
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        
                        if (state == SSPublishContentStateSuccess)
                        {
                            NSLog(@"success");
                            if (shareType == ShareTypeWeixiSession) {           //微信好友
                                [ShareSDK postWeChatSessionSucceedNotification];
                            }else if (shareType == ShareTypeWeixiTimeline){     //微信朋友圈
                                [ShareSDK postWeChatTimelineNotification];
                            }
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            if ([error errorCode] == -22003)
                            {
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TEXT_TIPS", @"提示")
                                                                                    message:[error errorDescription]
                                                                                   delegate:nil
                                                                          cancelButtonTitle:NSLocalizedString(@"TEXT_KNOW", @"知道了")
                                                                          otherButtonTitles:nil];
                                [alertView show];
                                [alertView release];
                            }
                        }
                    }];

}

+ (void)shareSendMail:(NSString *)nsText{
    //创建分享内容
    //NSString *imagePath = [[NSBundle mainBundle] pathForResource:IMAGE_NAME ofType:IMAGE_EXT];
    id<ISSContent> publishContent = [ShareSDK content:nsText
                                       defaultContent:@""
                                                image:nil      //[ShareSDK imageWithPath:imagePath]
                                                title:nil
                                                  url:nil
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeText];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
//    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
//                                    nil]];
    
    //显示分享菜单
    [ShareSDK showShareViewWithType:ShareTypeMail
                          container:container
                            content:publishContent
                      statusBarTips:YES
                        authOptions:authOptions
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                            qqButtonHidden:NO
                                                     wxSessionButtonHidden:NO
                                                    wxTimelineButtonHidden:NO
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:nil
                                                       friendsViewDelegate:nil
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                     [ShareSDK postMailSucceedNotification];
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                 }
                             }];
}


+ (void)shareCopy:(NSString *)nsText{
    //NSString *imagePath = [[NSBundle mainBundle] pathForResource:IMAGE_NAME ofType:IMAGE_EXT];
    id<ISSContent> publishContent = [ShareSDK content:nsText
                                       defaultContent:@""
                                                image:nil          //[ShareSDK imageWithPath:imagePath]
                                                title:nil
                                                  url:nil
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeText];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
//    //在授权页面中添加关注官方微博
//    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
//                                    nil]];
    
    //显示分享菜单
    [ShareSDK showShareViewWithType:ShareTypeCopy
                          container:container
                            content:publishContent
                      statusBarTips:YES
                        authOptions:authOptions
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                            qqButtonHidden:NO
                                                     wxSessionButtonHidden:NO
                                                    wxTimelineButtonHidden:NO
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:nil
                                                       friendsViewDelegate:nil
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                     [ShareSDK postCopySucceedNotification];
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                 }
                             }];

}

+ (void)shareSendSMS:(NSString *)nsText{
    //创建分享内容
    id<ISSContent> publishContent = [ShareSDK content:nsText
                                       defaultContent:@""
                                                image:nil
                                                title:nil
                                                  url:nil
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeText];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];

    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
//    //在授权页面中添加关注官方微博
//    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
//                                    nil]];
    
    //显示分享菜单
    [ShareSDK showShareViewWithType:ShareTypeSMS
                          container:container
                            content:publishContent
                      statusBarTips:YES
                        authOptions:authOptions
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                            qqButtonHidden:NO
                                                     wxSessionButtonHidden:NO
                                                    wxTimelineButtonHidden:NO
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:nil
                                                       friendsViewDelegate:nil
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                     [ShareSDK postSMSSucceedNotification];

                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                 }
                             }];

}


#pragma mark --- post notification
+ (void)postSinaWeiboSucceedNotification{       //发送
    [[NSNotificationCenter defaultCenter] postNotificationName:kCMShareSinaWeiboSucceed object:nil userInfo:nil];
}

+ (void)postTencentWeiboSucceedNotification{
    [[NSNotificationCenter defaultCenter] postNotificationName:kCMShareTencentWeiboSucceed object:nil userInfo:nil];
}

+ (void)postWeChatSessionSucceedNotification{
    [[NSNotificationCenter defaultCenter] postNotificationName:kCMShareWeChatSessionSucceed object:nil userInfo:nil];
}

+ (void)postWeChatTimelineNotification{
    [[NSNotificationCenter defaultCenter] postNotificationName:kCMShareWeChatTimelineSucceed object:nil userInfo:nil];
}

+ (void)postSMSSucceedNotification{
    [[NSNotificationCenter defaultCenter] postNotificationName:kCMShareSMSSucceed object:nil userInfo:nil];
}

+ (void)postMailSucceedNotification{
    [[NSNotificationCenter defaultCenter] postNotificationName:kCMShareMailSucceed object:nil userInfo:nil];
}

+ (void)postCopySucceedNotification{
    [[NSNotificationCenter defaultCenter] postNotificationName:kCMShareCopySucceed object:nil userInfo:nil];
}

@end

