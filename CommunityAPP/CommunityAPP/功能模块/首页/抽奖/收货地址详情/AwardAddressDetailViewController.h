//
//  AwardAddressDetailViewController.h
//  CommunityAPP
//
//  Created by yunlai on 14-4-22.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressListModel.h"
#import "CommunityHttpRequest.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface AwardAddressDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    
    CommunityHttpRequest *request;
    
    UITableView *recordTableView;
    
     MBProgressHUD *hudView;
    
    AppDelegate *appDelegate;
}
@property(nonatomic,retain)AddressListModel *addressModel;
@end
