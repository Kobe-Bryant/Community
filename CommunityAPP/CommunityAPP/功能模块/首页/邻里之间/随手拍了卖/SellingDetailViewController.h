//
//  SellingDetailViewController.h
//  CommunityAPP
//
//  Created by Stone on 14-3-18.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MyBaseViewController.h"
#import "MyPublishModel.h"
#import "MyCommentModel.h"
typedef NS_ENUM(NSInteger, EntryType) {
    CMEntryPresent    =   0,            //present
    CMEntryPush,                        //PUSH
};
typedef NS_ENUM(NSInteger, SellPublishType){
    IsSellMyPublish = 0,
    IsNotSellMyPublish,                    // 判断是否是我的发布
    IsHisSellMyPublish                     //判断是否是他的发布
};
typedef NS_ENUM(NSInteger, SellCommentType){
    IsSellMyComment = 0,
    IsNotSellMyComment,                    // 判断是否是我的评论
    IsHisSellMyComment                     //判断是否是他的评论
};
@interface SellingDetailViewController : MyBaseViewController
{
    MBProgressHUD *hudView;
    UIImage *rightImage;
    UIButton *rightBtn;
    
}
@property (nonatomic, assign) EntryType entryType; // 区别presend和push
@property (nonatomic, assign) SellPublishType sellPublishType;
@property (nonatomic, assign) SellCommentType sellCommentType;
@property (nonatomic ,assign) MyPublishModel *publishModel; //从我的发布传值过来 add by devin
@property (nonatomic ,assign) MyCommentModel *comModel; //从我的评论传值过来 add by devin
@property (nonatomic, assign) BOOL flag;
@end
