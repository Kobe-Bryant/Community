//
//  InviteViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-4-3.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface InviteViewController : UIViewController
{
    UIButton *ownerBtn; //业主Button
    UIButton *renterBtn; //租客
    
    MBProgressHUD *hudView;
    
    NSString *clientTypeStr;//选择租客还是业主
    
    NSString *inviteCodeStr;
}

@end
