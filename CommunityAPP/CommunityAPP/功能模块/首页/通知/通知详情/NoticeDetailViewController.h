//
//  NoticeDetailViewController.h
//  CommunityAPP
//
//  Created by yunlai on 14-3-5.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NOticeModel.h"
@interface NoticeDetailViewController : UIViewController<UIScrollViewDelegate,UIWebViewDelegate>
{
    UIScrollView *contentScrollView;
    
    NSString *curHeight;
}

@property(nonatomic,retain)NOticeModel *noticeModel;//当前详情数据字典
@end
