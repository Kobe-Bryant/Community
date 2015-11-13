//
//  MyCommentViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-3-13.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger,HisOrMyComment){
    HISCOMMENT = 0,        //他的评论
    MYCOMMENT             //我的评论
};

@interface MyCommentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myCommentTableView;
    MBProgressHUD *hudView;
}
@property(nonatomic,retain) NSString *commentTitleString;
@property(nonatomic,retain) NSString *commentIdString;
-(id)initWithUserId:(NSString *)userIdString title:(NSString *)titleString;
@property (nonatomic,retain) NSMutableArray *mycommentArray;

@property (nonatomic,assign) HisOrMyComment hisOrmycomment;

@end
