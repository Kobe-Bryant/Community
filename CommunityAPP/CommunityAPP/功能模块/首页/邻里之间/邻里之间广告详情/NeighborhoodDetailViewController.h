//
//  NeighborhoodDetailViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-4-27.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeAdModel.h"
#import "MBProgressHUD.h"
@interface NeighborhoodDetailViewController : UIViewController<UIScrollViewDelegate,UIWebViewDelegate>
{
    UIScrollView *contentScrollView;
    MBProgressHUD *hudView;
}
@property (nonatomic,retain) HomeAdModel *adModel;

@end
