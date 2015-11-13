//
//  CarPoolingDetailTableHeaderView.h
//  CommunityAPP
//
//  Created by yunlai on 14-3-17.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarPoolingDetailTableHeaderView : UIView
{
    UIScrollView *adScrollView;
  
}
@property(nonatomic,retain)NSString *imagesString;
- (id)initWithFrame:(CGRect)frame imageString:(NSString *)imageString;
@end
