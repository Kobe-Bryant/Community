//
//  LiveEncyclopediaCell.h
//  CommunityAPP
//
//  Created by Dream on 14-3-17.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LiveEncyclopediaModel;

@interface LiveEncyclopediaButton : UIButton

@property (nonatomic, retain) LiveEncyclopediaModel *liveModel;

@end

@interface LiveEncyclopediaCell : UITableViewCell

@property (nonatomic,retain) UILabel *titleLable;
@property (nonatomic,retain) UILabel *subTitleLable;
@property (nonatomic,retain) UILabel *subTitleTypeLable;
@property (nonatomic,retain) UIImageView *contentImg;
@property (nonatomic,retain) UIImageView *backImg;// 底部横条
@property (nonatomic,retain) UILabel *contentTextView;
@property (nonatomic,retain) UIImageView *commentImg;
@property (nonatomic,retain) UILabel *commentLable;
@property (nonatomic,retain) LiveEncyclopediaButton *loveBtn;
@property (nonatomic,retain) UIButton *commentBtn;
@property (nonatomic,retain) UILabel *loveLable;
@property (nonatomic,assign) NSInteger countLable;
@property (nonatomic,retain) UIButton *backsBtn;

@property (nonatomic, retain) LiveEncyclopediaModel *liveModel;

@end
