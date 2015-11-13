//
//  DetialElectricBillViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-3-6.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyBillListBean.h"

@interface DetialElectricBillViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *detialEleBillTableView;
}
@property(nonatomic,retain)MyBillListBean *listBean;
@end
