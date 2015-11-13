//
//  AwardDetailViewController.h
//  CommunityAPP
//
//  Created by yunlai on 14-4-22.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwardRecordingModel.h"

@interface AwardDetailViewController : UIViewController<UIWebViewDelegate>
{
//    UIWebView *webView;
    
    UIActivityIndicatorView *indicatorView;
    
    UIScrollView *contentScrollView;
}
@property(nonatomic,retain)AwardRecordingModel *model;
@end
