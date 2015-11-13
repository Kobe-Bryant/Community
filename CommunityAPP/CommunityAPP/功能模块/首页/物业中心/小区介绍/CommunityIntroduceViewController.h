//
//  CommunityIntroduceViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-3-5.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAMutilColorLabel.h"

@interface CommunityIntroduceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
     UITableView *introTableView; //tableview列表
     UIScrollView *contentScrollView ;
}


@end
