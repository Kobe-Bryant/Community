//
//  MyBillViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-3-5.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetialElectricBillViewController.h"
#import "CommunityHttpRequest.h"

@interface MyBillViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *myBillTableView;
  
    CommunityHttpRequest *request;//add vincent 2014.3.12
}
@property(nonatomic,retain)NSMutableDictionary *myBillMutableDictionary;
@property(nonatomic,retain)NSMutableArray *billArray;
@property(nonatomic,retain)NSMutableArray *billArray1;

@end
