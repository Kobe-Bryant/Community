//
//  HomeAdDetailViewController.h
//  CommunityAPP
//
//  Created by yunlai on 14-3-4.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeAdModel.h"
#import "MBProgressHUD.h"
@interface HomeAdDetailViewController : UIViewController<UIScrollViewDelegate,UIWebViewDelegate>
{
    UIScrollView *contentScrollView;
    MBProgressHUD *hudView;
}
@property (nonatomic,retain) HomeAdModel *adModel;

@end
