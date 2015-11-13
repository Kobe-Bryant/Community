//
//  NoticeViewController.h
//  CommunityAPP
//
//  Created by yunlai on 14-3-5.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NOticeModel.h"

@interface NoticeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView *noticeTableView;
}

@end
