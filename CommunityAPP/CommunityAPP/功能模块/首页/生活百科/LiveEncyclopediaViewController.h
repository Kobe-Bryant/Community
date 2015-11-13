//
//  LiveEncyclopediaViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-3-17.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveEncyclopediaModel.h"
#import "MBProgressHUD.h"
#import "DetailLiveEncyclopediaViewController.h"
@interface LiveEncyclopediaViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *liveEncyclopediaTableView;
    MBProgressHUD *hudView;
}
@end
