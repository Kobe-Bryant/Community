//
//  MessagesListView.h
//  CommunityAPP
//
//  Created by yunlai on 14-5-7.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MessagesListView : UIView<UITableViewDataSource,UITableViewDelegate>
{
     UITableView *messagesListTableView;
    UIViewController *lastViewC;
    UILabel *noDataContentLabel ;
}
@property(nonatomic,copy)NSMutableArray *listArray;
- (id)initWithFrame:(CGRect)frame delegateController:(UIViewController *)controller;
@end
