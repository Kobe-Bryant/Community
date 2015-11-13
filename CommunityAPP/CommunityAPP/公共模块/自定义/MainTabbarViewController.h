//
//  MainTabbarViewController.h
//  CommunityAPP
//
//  Created by yunlai on 14-3-4.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabbarViewController : UITabBarController
{
    UIView *bottomView;
    UIImageView *imgViewLine;
    NSInteger currentIndex;
}
- (void)hideNewTabBar;
- (void)showNewTabBar;
@end
