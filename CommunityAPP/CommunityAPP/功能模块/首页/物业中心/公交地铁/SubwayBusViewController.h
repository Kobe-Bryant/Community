//
//  SubwayBusViewController.h
//  CommunityAPP
//
//  Created by yunlai on 14-3-7.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "CommunityHttpRequest.h"
#import "MBProgressHUD.h"

@interface SubwayBusViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, AMapSearchDelegate>{
    
    UITableView *busTableView;
    
    CommunityHttpRequest *request;
    
    NSString *locationString;
    
    MBProgressHUD *hudView;
}
@property (nonatomic,retain)  NSMutableDictionary *introduceInfo;
@property(nonatomic,retain)NSString *keyString;
@property(nonatomic,retain)NSMutableArray *subwayPoiPlaceSearch;
@property(nonatomic,retain)NSMutableArray *buyPoiPlaceSearch;
@property (nonatomic,strong)AMapSearchAPI *search;
@property(nonatomic,retain)NSString *latitudeString;
@property(nonatomic,retain)NSString *longitudeString;
@end
