//
//  GoodsPrview.m
//  CommunityAPP
//
//  Created by Stone on 14-3-18.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "GoodsPrview.h"
#import "UIImageView+WebCache.h"
#import "AuctionModel.h"
#import "UIButton+WebCache.h"
#import "NSObject+Time.h"

@interface GoodsPrview ()

@property (nonatomic, retain) UILabel *lbPrice;
@property (nonatomic, retain) UILabel *lbTitle;

@end

@implementation GoodsPrview
{
    UIImageView *lineImg;
}

@synthesize auctionModel = _auctionModel;
@synthesize goodsPrviewImg = _goodsPrviewImg;
@synthesize title = _title;
@synthesize bgUsericon = _bgUsericon;
@synthesize userIcon = _userIcon;
@synthesize communityNameImg = _communityNameImg;
@synthesize publishTimeImg = _publishTimeImg;
@synthesize lbCommunityName = _lbCommunityName;
@synthesize lbPublishTime = _lbPublishTime;
@synthesize btnGoodsPrview = _btnGoodsPrview;

@synthesize lbPrice = _lbPrice;
@synthesize lbTitle = _lbTitle;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 320, 1)];
        lineImg.image = [UIImage imageNamed:@"线.png"];
        [self addSubview:lineImg];
        [lineImg release];
        
        _bgUsericon = [[UIImageView alloc] initWithFrame:CGRectMake(11, 13, 57, 61)];
        _bgUsericon.image = [UIImage imageNamed:@"bg_photo.png"];
        _bgUsericon.userInteractionEnabled = YES;
        [self addSubview:_bgUsericon];
        [_bgUsericon release];
        
        _userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(3.5, 2.5, 50, 50)];
        //_userIcon.image = [UIImage imageNamed:@"头像.png"];
        _userIcon.userInteractionEnabled = YES;
        _userIcon.layer.cornerRadius = 25.0;
        _userIcon.layer.masksToBounds = YES;
        [_bgUsericon addSubview:_userIcon];
        [_userIcon release];
        
        _userIconTap = [[UITapGestureRecognizer alloc] init];
        [_userIcon addGestureRecognizer:_userIconTap];
        [_userIconTap release];
        
        _communityNameImg = [[UIImageView alloc] initWithFrame:CGRectMake(111, 28, 26, 26)];
        _communityNameImg.image = [UIImage imageNamed:@"icon_map.png"];
        [self addSubview:_communityNameImg];
        [_communityNameImg release];
        
        _lbCommunityName = [[UILabel alloc] initWithFrame:CGRectMake(111, 48, 95, 36)];
        _lbCommunityName.font = [UIFont systemFontOfSize:14];
        _lbCommunityName.backgroundColor = [UIColor clearColor];
        _lbCommunityName.textColor = [UIColor whiteColor];
        _lbCommunityName.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_lbCommunityName];
        [_lbCommunityName release];
        //UICollectionView
        _publishTimeImg = [[UIImageView alloc]  initWithFrame:CGRectMake(213, 28, 26, 26)];
        _publishTimeImg.image = [UIImage imageNamed:@"icon_clocks.png"];
        [self addSubview:_publishTimeImg];
        [_publishTimeImg release];
 
        _lbPublishTime = [[UILabel alloc] initWithFrame:CGRectMake(213, 48, 100, 36)];
        _lbPublishTime.font = [UIFont systemFontOfSize:14];
        _lbPublishTime.backgroundColor = [UIColor clearColor];
        _lbPublishTime.textColor = [UIColor whiteColor];
        //_lbPublishTime.text = @"10月13号";
        [self addSubview:_lbPublishTime];
        [_lbPublishTime release];
        
        _btnGoodsPrview = [GoodsPrviewButton buttonWithType:UIButtonTypeCustom];
        _btnGoodsPrview.frame = CGRectMake(25, 80, 270, 322);
        //[_btnGoodsPrview setImage:[UIImage imageNamed:@"bg_sample_1.png"] forState:UIControlStateNormal];
        //[_btnGoodsPrview setBackgroundImage:[UIImage imageNamed:@"home_test_ad.png"] forState:UIControlStateNormal];
        [self addSubview:_btnGoodsPrview];
        
        _imgGoodsPrview = [[UIImageView alloc] initWithFrame:CGRectMake(25, 80, 270, 322)];
        [self addSubview:_imgGoodsPrview];
        [_imgGoodsPrview release];
        
        _lbPrice = [[UILabel alloc] initWithFrame:CGRectMake(25, 95, 71, 30)];//227
        //_lbPrice.text = @" ￥459";
        _lbPrice.lineBreakMode = NSLineBreakByTruncatingTail;
        _lbPrice.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _lbPrice.textColor = [UIColor colorWithRed:255.0/255.0 green:168.0f/255.0 blue:0./255 alpha:1.0f];
        _lbPrice.font = [UIFont boldSystemFontOfSize:17.0f];
        [self addSubview:_lbPrice];
        [_lbPrice release];
        
        _lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(25, 410, 270, 40)];
        _lbTitle.backgroundColor = [UIColor clearColor];
        _lbTitle.textColor = [UIColor whiteColor];
        [self addSubview:_lbTitle];
        [_lbTitle release];
    }
    return self;
}


- (void)setAuctionModel:(AuctionModel *)auctionModel{
    /*
     @synthesize goodsPrviewImg = _goodsPrviewImg;
     @synthesize title = _title;
     @synthesize bgUsericon = _bgUsericon;
     @synthesize userIcon = _userIcon;
     @synthesize communityNameImg = _communityNameImg;
     @synthesize publishTimeImg = _publishTimeImg;
     @synthesize lbCommunityName = _lbCommunityName;
     @synthesize lbPublishTime = _lbPublishTime;
     @synthesize btnGoodsPrview = _btnGoodsPrview;
     */
    if (_auctionModel != auctionModel) {
        [_auctionModel release];
        _auctionModel = [auctionModel retain];
    }
    
    _btnGoodsPrview.auctionModel = _auctionModel;
    
    NSURL *userIcon = [NSURL URLWithString:_auctionModel.residentIcon];
    NSURL *auctionImg = [NSURL URLWithString:_auctionModel.images];
    _lbCommunityName.text = _auctionModel.communityName;
    _lbPublishTime.text = [self formateDate:_auctionModel.auctionUpdateTime];//_auctionModel.auctionUpdateTime;
    [_userIcon setImageWithURL:userIcon placeholderImage:[UIImage imageNamed:@"default_head.png"] options:SDWebImageRetryFailed];
    //[_btnGoodsPrview setImageWithURL:auctionImg forState:UIControlStateNormal placeholderImage:nil options:SDWebImageRetryFailed];
    [_imgGoodsPrview setImageWithURL:auctionImg placeholderImage:[UIImage imageNamed:@"bg_sample_1.png"]];
    
    _lbTitle.text = _auctionModel.title;
    NSString *str = [NSString stringWithFormat:@"￥%@",_auctionModel.cost];
    CGSize size = [str sizeWithFont:[UIFont boldSystemFontOfSize:17.0f] forWidth:100 lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat width = MAX(size.width*1.1, 71);
    CGRect rect = _lbPrice.frame;
    CGRect newRect = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), width, CGRectGetHeight(rect));
    _lbPrice.frame = newRect;
    _lbPrice.text = str;
    
}

//返回日月的时间
- (NSString *)formateDate:(NSString *)time{

    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    //inputFormatter.dateStyle = kCFDateFormatterMediumStyle;
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [inputFormatter dateFromString:time];
    
    NSDateFormatter *outPutFormatter = [[NSDateFormatter alloc] init];
    [outPutFormatter setDateFormat:@"MM月dd日"];
    NSString *timeString = [outPutFormatter stringFromDate:inputDate];
    
    return timeString;

}

@end

@implementation GoodsPrviewButton

@synthesize auctionModel = _auctionModel;

@end
