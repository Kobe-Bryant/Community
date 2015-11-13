//
//  DeliveryAddressView.h
//  CommunityAPP
//
//  Created by yunlai on 14-4-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityHttpRequest.h"
#import "LuckDrawViewController.h"
#import "MBProgressHUD.h"

@interface DeliveryAddressView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    //  当前的选中的行
    NSInteger selectedIndex;
    
    UIViewController *lastViewController;
    
    CommunityHttpRequest *request;
    
    UITableView *recordTableView;
    
     MBProgressHUD *hudView;
    
    AddressListModel  *modelData;
}
@property(nonatomic,retain) NSMutableArray *listArray;
- (id)initWithFrame:(CGRect)frame viewController:(id)viewController;
@end
