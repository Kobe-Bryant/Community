//
//  AvoidTroubleViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-5-21.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PushNoticeViewController.h"
#import "PushSettingModel.h"

@interface AvoidTroubleViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *avoidTroubleTableView;

}

@property (nonatomic, retain) PushSettingModel *discrubSettingModel;

@end
