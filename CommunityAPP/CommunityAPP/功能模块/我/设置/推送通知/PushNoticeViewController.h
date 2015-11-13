//
//  PushNoticeViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-5-21.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *kCMPushContentTypeChat = @"chat";
static NSString *kCMPushContentTypeComment = @"comment";
static NSString *kCMPushContentTypeBill = @"function";
static NSString *kCMPushContentNoDisturb = @"discrub";

typedef NS_ENUM(NSInteger, CMPushStatus) {
    CMPushStatusOff,            //关闭
    CMPushStatusOn,             //开启
    CMPushStatusNoBother,       //免打扰
};

@interface PushNoticeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UITableView *pushNoticeTableView;
}

@end
