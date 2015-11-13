//
//  MyCollectionViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-3-13.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface MyCollectionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *collectionTableView;
    MBProgressHUD *hudView;
}
@property (nonatomic,retain) NSMutableArray *mycollectionArray;
@end
