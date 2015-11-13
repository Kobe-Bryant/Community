//
//  LuckDrawViewController.h
//  CommunityAPP
//
//  Created by yunlai on 14-4-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwardView.h"
#import "AwardRecordingModel.h"
#import "AddressListModel.h"
@class AwardRecordingView;
@class DeliveryAddressView;
@class LuckDrawView;

@interface LuckDrawViewController : UIViewController
{
    NSInteger SelectedTagChang;
    UIView *choseView ;
    UIImageView *selectedImageView;
    
//    获奖记录
    AwardRecordingView *recordView;
//    奖项
    AwardView *awardView;
    
    DeliveryAddressView *addressView;
    LuckDrawView *luckDrawView ;
}

//添加收货地址
-(void)addAddress;
//地址详情
-(void)addressDetail:(AddressListModel *)model;
//奖品详情
-(void)awardDetail:(AwardRecordingModel *)awardRecordingModel;
-(void)finishAddress;
@end
