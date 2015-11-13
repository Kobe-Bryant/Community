//
//  SubwayBusDetailViewController.h
//  CommunityAPP
//
//  Created by yunlai on 14-3-7.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POIAnnotation.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import "MBProgressHUD.h"

@interface SubwayBusDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate>
{
    UITableView *subwayBusDetailTableView;
    MBProgressHUD *hudView;
}
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) AMapPOI *poi;
@property (nonatomic, strong) NSMutableArray *busLines;
@end
