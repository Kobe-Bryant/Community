//
//  AddAndChoseAddressViewController.h
//  CommunityAPP
//
//  Created by yunlai on 14-5-15.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityHttpRequest.h"
#import "MBProgressHUD.h"
@class AddressListModel;

@interface AddAndChoseAddressViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    //  当前的选中的行
    NSInteger selectedIndex;
    
    UIViewController *lastViewController;
    
    CommunityHttpRequest *request;
    
    UITableView *recordTableView;
    
    MBProgressHUD *hudView;
    
    AddressListModel  *modelData;
}
@property(nonatomic,retain) NSArray *listArray;


@end
