//
//  MyPublishViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-3-13.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
typedef NS_ENUM(NSInteger, IsWhoPublish){
  IsMyPublish = 0,     // 我的发布
  IsHisPublish         //他的发布
};

@interface MyPublishViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{

    UITableView *MyPublishTableView;
    MBProgressHUD *hudView;
    
//    add vincent
}
@property(nonatomic,retain) NSString *publishTitleString;
@property(nonatomic,retain) NSString *publishIdString;
@property (nonatomic,retain) NSMutableArray *sigleArray;
@property (nonatomic,retain) NSMutableArray *mypublishArray;
@property (nonatomic,assign) IsWhoPublish isWhoPublish;
-(id)initWithUserId:(NSString *)userIdString title:(NSString *)titleString;

@end
