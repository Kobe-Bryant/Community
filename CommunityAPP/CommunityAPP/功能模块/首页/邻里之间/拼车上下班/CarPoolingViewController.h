//
//  CarPoolingViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-3-7.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityHttpRequest.h"
#import "MBProgressHUD.h"

@interface CarPoolingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *carPoolingTableView;
    
    CommunityHttpRequest *request;
    
    MBProgressHUD *hudView;
}
@property(nonatomic,retain)NSMutableArray *listArray;
@end
