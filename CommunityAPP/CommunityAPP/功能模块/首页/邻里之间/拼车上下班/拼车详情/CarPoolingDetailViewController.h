//
//  CarPoolingDetailViewController.h
//  CommunityAPP
//
//  Created by yunlai on 14-3-17.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunitySendTextAndImageView.h"
#import "CarPoolDataModel.h"
#import "CommunityHttpRequest.h"
#import "MBProgressHUD.h"
#import "MyBaseViewController.h"
#import "MyPublishModel.h"
#import "MyCommentModel.h"
typedef NS_ENUM(NSInteger, CarVcType){
    MyCarConrrollerPush  = 0,       //myController
    CarControllerPush,           //carController
};
typedef NS_ENUM(NSInteger, CarPublishType){
    IsCarMyPublish = 0,
    IsNotCarMyPublish,                       // 判断是否是我的发布
    IsHisCarMyPublish                        // 判断是否是他的发布
};
typedef NS_ENUM(NSInteger, CarCommentType){
    IsCarMyComment = 0,
    IsNotCarMyComment,                    // 判断是否是我的评论
    IsHisCarMyComment                     //判断是否是他的评论
};
typedef NS_ENUM(NSInteger, NumberAndAdress) {
    OnlyNumber = 0,                      //判断是否有电话号，和地址
    OnlyAdress,
    AllNumberAdress,
    NoneNumberAdress
};
@interface CarPoolingDetailViewController : MyBaseViewController<UITableViewDelegate,UITableViewDataSource,CommunitySendTextAndImageViewDelegate,UIActionSheetDelegate>
{
    UITableView *carPoolTableView ;
    CommunityHttpRequest *request;
    MBProgressHUD *hudView;
    UIImage *rightImage;
    UIButton *rightBtn;
    CommunitySendTextAndImageView *sendTextView;
   
}
@property(nonatomic,retain)NSString *poolModelStr;
@property(nonatomic,retain)NSMutableDictionary *poolingDetailDictionary;//详情字典
@property(nonatomic,retain)NSMutableDictionary *conmmentListDictionary;//评论列表
@property(nonatomic,retain)NSMutableArray *commentListArray;
@property(nonatomic,assign) CarVcType carVcType; //判断从哪里push过来
@property(nonatomic,assign) CarPublishType carPublishType; // 判断是否是我的发布
@property(nonatomic,assign) CarCommentType carCommentType; // 判断是否是我的评论
@property (nonatomic,assign) MyPublishModel *publishModel; //从我的发布传值过来 add by devin
@property (nonatomic,assign) MyCommentModel *comModel; //从我的评论传值过来 add by devin
@property (nonatomic,assign) NumberAndAdress numberAndAdress;
@property (nonatomic,assign) BOOL flag;
@end
