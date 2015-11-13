//
//  ContactCell.h
//  CommunityAPP
//
//  Created by Stone on 14-3-21.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactModel;

@interface ContactCell : UITableViewCell

@property (nonatomic, retain) UIButton *btnPhoneCall;
@property (nonatomic, assign) BOOL isRecently;
@property (nonatomic, retain) UIImageView *clockImg;
@property (nonatomic, retain) UILabel *lbSinceNowTime;
@property (nonatomic, retain) ContactModel *contactModel;

@end
