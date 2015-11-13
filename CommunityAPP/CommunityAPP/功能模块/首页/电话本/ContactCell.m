//
//  ContactCell.m
//  CommunityAPP
//
//  Created by Stone on 14-3-21.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "ContactCell.h"
#import "NSObject+Time.h"
#import "Common.h"
#import "ContactModel.h"

@implementation ContactCell
@synthesize btnPhoneCall = _btnPhoneCall;
@synthesize contactModel = _contactModel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _isRecently = NO;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_home_line.png"]];
        [imageView setFrame:CGRectMake(320-45, 5, 1, 34)];
        [self addSubview:imageView];
        [imageView release];
        
        _btnPhoneCall = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnPhoneCall setFrame:CGRectMake(320-44, 0, 44, 44)];
        [_btnPhoneCall setImage:[UIImage imageNamed:@"icon_phone_call.png"] forState:UIControlStateNormal];
        [self addSubview:_btnPhoneCall];
        
        
        _clockImg = [[UIImageView alloc] initWithFrame:CGRectMake(200, 14, 10, 10)];
        _clockImg.image = [UIImage imageNamed:@"icon_time.png"];
        _clockImg.hidden = YES;
        [self addSubview:_clockImg];
        [_clockImg release];
        
        _lbSinceNowTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_clockImg.frame)+2, 10, 50, 16)];
        _lbSinceNowTime.font = [UIFont systemFontOfSize:12];
        _lbSinceNowTime.textColor = [UIColor lightGrayColor];
        _lbSinceNowTime.backgroundColor = [UIColor clearColor];
        _lbSinceNowTime.hidden = YES;
        [self addSubview:_lbSinceNowTime];
        [_lbSinceNowTime release];
        
    }
    return self;
}

- (void)setIsRecently:(BOOL)isRecently{
    _isRecently = isRecently;
    if (isRecently) {
        _clockImg.hidden = NO;
        _lbSinceNowTime.hidden = NO;
    }else{
        _clockImg.hidden = YES;
        _lbSinceNowTime.hidden = YES;
    }
}

- (void)setContactModel:(ContactModel *)contactModel{
    _contactModel = contactModel;
    self.isRecently = _contactModel.isRecently;
    if (_contactModel) {
        if (_contactModel.isRecently) {
        
            NSDate *formateDate = [NSObject fromatterDateFromStr:_contactModel.lastCallTime];
            NSString *time = [NSObject compareCurrentTime:formateDate];
            //NSString *time = [Common intervalSinceNow:_contactModel.lastCallTime];
            _lbSinceNowTime.text = time;
        }

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
