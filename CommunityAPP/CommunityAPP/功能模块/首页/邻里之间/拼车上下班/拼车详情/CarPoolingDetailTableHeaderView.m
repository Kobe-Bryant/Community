//
//  CarPoolingDetailTableHeaderView.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-17.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "CarPoolingDetailTableHeaderView.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@implementation CarPoolingDetailTableHeaderView
@synthesize imagesString;

-(void)dealloc{
    [adScrollView release]; adScrollView= nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame imageString:(NSString *)imageString
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imagesString = imageString;
        
        //构建滚动视图
        adScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 398/2)] ;
        adScrollView.pagingEnabled = YES;
        adScrollView.showsHorizontalScrollIndicator = NO;
        adScrollView.showsVerticalScrollIndicator = NO;
        adScrollView.scrollsToTop = NO;
        [adScrollView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:adScrollView];
        
        NSArray *listImageArray = [imageString componentsSeparatedByString:@";"];
        NSLog(@"listImageArray %@",listImageArray);
        NSLog(@"listImageArray count %d",[listImageArray count]);
        for (int i = 0; i<[listImageArray count]; i++) {
            CGRect imageframe = adScrollView.frame;
            imageframe.origin.x = ScreenWidth * i;
            imageframe.origin.y = 0;
            
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = imageframe;
            imageView.userInteractionEnabled = YES;
            [imageView setImageWithURL:[NSURL URLWithString:[listImageArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"bg_sample_2.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [adScrollView addSubview:imageView];
            [imageView release];

        }
        adScrollView.contentSize = CGSizeMake(listImageArray.count * adScrollView.frame.size.width, adScrollView.frame.size.height);
    }
    return self;
}

//下面类型的进入
- (void)tapImage:(UITapGestureRecognizer *)tap
{
    //小区图片
    NSArray *imgArr = [self.imagesString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";"]];
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:imgArr.count];
    for (int i = 0; i<imgArr.count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:[imgArr objectAtIndex:i]]; // 图片路径
        photo.srcImageView = adScrollView.subviews[i]; // 来源于哪个UIImageView
        [photos addObject:photo];
        [photo release];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[[MJPhotoBrowser alloc] init] autorelease];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
