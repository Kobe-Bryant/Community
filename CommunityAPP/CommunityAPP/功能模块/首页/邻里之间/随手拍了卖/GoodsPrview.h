//
//  GoodsPrview.h
//  CommunityAPP
//
//  Created by Stone on 14-3-18.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AuctionModel;



@class GoodsPrviewButton;

@interface GoodsPrview : UIView

@property (nonatomic, retain) AuctionModel *auctionModel;

@property (nonatomic, retain) UIImageView *bgUsericon;
@property (nonatomic, retain) UIImageView *userIcon;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) UIImageView *goodsPrviewImg;
@property (nonatomic, retain) UIImageView *communityNameImg;
@property (nonatomic, retain) UIImageView *publishTimeImg;
@property (nonatomic, retain) UILabel *lbCommunityName;
@property (nonatomic, retain) UILabel *lbPublishTime;
@property (nonatomic, retain) GoodsPrviewButton *btnGoodsPrview;
@property (nonatomic, retain) UIImageView *imgGoodsPrview;
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) UITapGestureRecognizer *userIconTap;

@end

@interface GoodsPrviewButton : UIButton

@property (nonatomic, retain) AuctionModel *auctionModel;

@end
