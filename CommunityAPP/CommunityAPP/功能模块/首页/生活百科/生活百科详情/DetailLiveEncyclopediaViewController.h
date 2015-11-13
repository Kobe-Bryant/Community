//
//  DetailLiveEncyclopediaViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-3-18.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailLiveEncyclopediaModel.h"
#import "CommunitySendTextAndImageView.h"
#import "MBProgressHUD.h"
#import "MyBaseViewController.h"
#import "MyCommentModel.h"

@class LiveEncyclopediaModel;

@class SesameGlobalWebView;
typedef NS_ENUM(NSInteger, LiveVcType){
    MyConrrollerPush  = 0,       //myController 是从我的评论push过去
    LiveControllerPush           //liveController 是从生活百科push过去
};

typedef NS_ENUM(NSInteger, LiveCommentType) {
   IsLiveMyComment = 0,
   IsNotLiveMyComment,             // 判断是否是我的评论
   IsHisLiveMyComment              //判断是否是他的评论
};

@interface DetailLiveEncyclopediaViewController : MyBaseViewController<UITableViewDataSource,UITableViewDelegate,CommunitySendTextAndImageViewDelegate,UIWebViewDelegate,UIActionSheetDelegate>
{
    MBProgressHUD *hudView;
    UIButton *rightBtn;//导航栏又按钮（空心）
    UIImage *rightImage;//控制收藏与取消收藏的图标
    UITableView *DetailLiveEncyclopediaTableView;
    UIView *backView;
    UIView *mainView;
    UIImageView *contentImg;//详情内容图片
    UIImage *lineImage;  //直线图片
    UILabel *titleLable;  //表头title标题
    UIWebView *contentWebView;
    UIImageView *lineImg;  //表头分割直线
    UIImage *loveImage;    //表头点赞心形图片
    UIButton *loveBtn;    //表头点赞button
    UILabel *loveLable;   //表头点赞个数
    UILabel *endTypeLable; //详情类型（美容，生活。。。）
    UILabel *endLable;  //表头地址日期
    UIImage *normalImage;
    UIImage *selectedImage;
    DetailLiveEncyclopediaModel *detail;
    
    UILabel *commentCount; //评论条数
    NSInteger lastCommentId;//lastId
    NSInteger delegateId; //删除评论
    NSInteger clickIndexPathRow; //判断点了哪一个cell
   
    CommunitySendTextAndImageView *sendTextView; //   发送面板
}
@property (nonatomic,retain) NSString *passStr;
@property (nonatomic,retain) NSString *selectedId;//选中某人的评论
@property (nonatomic,assign) LiveVcType vcType;
@property (nonatomic,assign) LiveCommentType liveCommentType;
@property (nonatomic ,retain) MyCommentModel *comModel; //从我的评论传值过来 add by devin
@property (nonatomic,assign) BOOL flag;
@property (nonatomic, retain) LiveEncyclopediaModel *liveModel;
@end
