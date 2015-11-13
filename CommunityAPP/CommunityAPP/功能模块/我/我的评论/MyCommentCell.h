//
//  MyCommentCell.h
//  CommunityAPP
//
//  Created by Dream on 14-3-18.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQRichTextView.h"
@interface MyCommentCell : UITableViewCell
@property (nonatomic,retain) UIImageView *headerImg;
@property (nonatomic,retain) UILabel *nameLable;
@property (nonatomic,retain) UILabel *timeLable;
@property (nonatomic,retain) TQRichTextView *contentLable;
@property (nonatomic,retain) UIImageView *commentTypeImg;

@end
