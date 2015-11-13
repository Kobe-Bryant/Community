//
//  HomeViewController.h
//  CommunityAPP
//
//  Created by yunlai on 14-3-4.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeAdModel.h"
#import "JCTopic.h"
@interface HomeViewController : UIViewController<JCTopicDelegate>
{
    //UIImageView *navImageView;
    UIScrollView *adScrollView; 
    UIPageControl *pageControl;
    UIView *marqueeView;
    CGSize pageSize;

    UIButton *rightBtn;//签到
}
@property (nonatomic,retain) NSMutableDictionary *homeAdDic;
@property (nonatomic,retain) NSMutableArray *imageArray;
@property (nonatomic,retain) NSMutableArray *homeArray;
@property (nonatomic,retain) UIImageView *image;
@property (strong,nonatomic)  UIPageControl *page;
@property (strong,nonatomic)  JCTopic * Topic;
@end
