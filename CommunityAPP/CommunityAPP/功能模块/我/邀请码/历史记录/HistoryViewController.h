//
//  HistoryViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-4-3.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MBProgressHUD.h"
@interface HistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate>
{
    UITableView *historyTableView;
    
    NSString *lastIdStr;
    
    MBProgressHUD *hudView;
}

@end
