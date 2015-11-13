//
//  AwardRecordingView.h
//  CommunityAPP
//
//  Created by yunlai on 14-4-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityHttpRequest.h"
#import "MBProgressHUD.h"
@class LuckDrawViewController;

@interface AwardRecordingView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UIViewController *lastViewController;
    
    CommunityHttpRequest *request;
    
    UITableView *recordTableView ;
    
    MBProgressHUD *hudView;
}
@property(nonatomic,retain)NSArray *listArray;
- (id)initWithFrame:(CGRect)frame viewController:(id)viewController;
@end
