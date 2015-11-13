//
//  NeighborhoodBetweenViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-3-7.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCTopic.h"
@interface NeighborhoodBetweenViewController : UIViewController<JCTopicDelegate>
{
    UIImageView *navImageView;
    CGSize pageSize;
    UIScrollView *backScrollview;
}
@property (nonatomic,retain) NSMutableDictionary *neighborhoodAdDic;
@property (nonatomic ,retain) NSMutableArray *imageArray;
@property (nonatomic,retain) NSMutableArray *homeArray;
@property (nonatomic ,retain) UIImageView *image;
@property (strong, nonatomic)  UIPageControl *page;
@property (strong, nonatomic)  JCTopic * Topic;

@end
