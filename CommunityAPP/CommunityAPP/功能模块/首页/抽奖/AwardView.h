//
//  AwardView.h
//  CommunityAPP
//
//  Created by yunlai on 14-4-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityHttpRequest.h"

@interface AwardView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    CommunityHttpRequest *request;
    UITableView *recordTableView;
    UIViewController *lastViewController;
}
@property(nonatomic,retain) NSMutableArray *listArray;
- (id)initWithFrame:(CGRect)frame viewController:(id)viewController;
@end
