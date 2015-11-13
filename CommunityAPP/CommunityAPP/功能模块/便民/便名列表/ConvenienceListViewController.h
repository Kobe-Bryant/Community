//
//  ConvenienceListViewController.h
//  CommunityAPP
//
//  Created by yunlai on 14-4-3.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "DPRequest.h"
#import "MJRefresh.h"

@interface ConvenienceListViewController : UIViewController<DPRequestDelegate,UITableViewDataSource,UITableViewDelegate>{
    MBProgressHUD *hudView;
    UITableView *listTableView;
    
    int currnetInt;
    
    
    int currentPage;
}
@property (nonatomic, retain) MJRefreshFooterView *footer;
@property(nonatomic,assign)int currentPage;
@property(nonatomic,retain) NSArray *disArray;
@property(nonatomic,retain)NSMutableArray *listDataArray;
@property(nonatomic,retain)NSString *searchTextString;
@end
