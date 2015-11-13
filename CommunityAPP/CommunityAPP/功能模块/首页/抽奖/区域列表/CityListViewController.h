//
//  CityListViewController.h
//  CommunityAPP
//
//  Created by yunlai on 14-5-14.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityHttpRequest.h"
@class MBProgressHUD;
@class DataLocitionModel;

@interface CityListViewController :  UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    CommunityHttpRequest *request;
    UITableView *recordTableView;
    
    MBProgressHUD *hudView;
    
}
@property(nonatomic,retain)NSMutableArray *provincesArray;
@property(nonatomic,retain)DataLocitionModel  *model;
@end
