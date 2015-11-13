//
//  NeighborhoodIntroduceViewController.h
//  CommunityAPP
//
//  Created by yunlai on 14-4-17.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityHttpRequest.h"
#import "MBProgressHUD.h"

@interface NeighborhoodIntroduceViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *selfTableView;
    CommunityHttpRequest *request;
//    UIImageView *iconImageView;
    UIButton *iconImageViewBtn;
    UIImageView *sexImage;
    UILabel *nameLab;
    UILabel *signatureLab;
    UILabel *homeLab;
    UILabel *identifyLab;
    UIImageView *jobImage;
    
    UIScrollView *contentScrollView;
    
    MBProgressHUD *hudView;
}
@property(nonatomic,retain)NSString *userNameJidString;
@property(nonatomic,retain)NSString *introduceUserIdString;
@property(nonatomic,retain)NSString *nickNameString;
@property (nonatomic, retain) NSMutableDictionary *personalInfo;
-(id)initWithUserId:(NSString *)userIdString communityId:(NSString *)communityIdString propertyId:(NSString *)propertyIdString name:(NSString *)nameString;
@end
