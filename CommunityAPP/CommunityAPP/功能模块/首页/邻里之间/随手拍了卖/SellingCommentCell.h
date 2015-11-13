//
//  SellingCommentCell.h
//  CommunityAPP
//
//  Created by Stone on 14-3-19.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQRichTextView.h"

@class AuctionCommentModel;

@interface SellingCommentCell : UITableViewCell

@property (nonatomic, retain) AuctionCommentModel *commentModel;

@property(nonatomic,retain)UIButton *iconImageBtn;
@property(nonatomic,retain)UIImageView *maleImageView;
@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,retain)UILabel *timeLabel;
@property(nonatomic,retain)TQRichTextView *contentLabel;

@end
