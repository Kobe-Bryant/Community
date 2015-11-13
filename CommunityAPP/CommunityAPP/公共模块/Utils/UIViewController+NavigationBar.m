//
//  UIViewController+NavigationBar.m
//  CommunityAPP
//
//  Created by Stone on 14-5-12.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "UIViewController+NavigationBar.h"
#import "UIImage+extra.h"

@implementation UIViewController (NavigationBar)


- (BOOL)isIOS7
{
    return ([[[UIDevice currentDevice] systemVersion] compare:@"7" options:NSNumericSearch] != NSOrderedAscending);
}

- (UIBarButtonItem *)spacer:(CGFloat)margin
{
    UIBarButtonItem *space = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    space.width = -margin;
    return space;
}

- (UIBarButtonItem *)spacer
{
    UIBarButtonItem *space = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    space.width = -20;
    return space;
}

- (void)adjustiOS7NaviagtionBar
{
    
    if ( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) )
    {        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:87.0f/255.0 green:182.0/255.0f blue:16.0/255 alpha:1.0];
    }
    else{
        self.navigationController.navigationBar.translucent = NO;

    }
    
}

- (void)setNavigationTitle:(NSString *)title{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.font = [UIFont boldSystemFontOfSize:18.0f];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = label;
    [label release];
}


- (void)setBackBarButtonItem:(UIView *)view{
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    if ([self isIOS7]) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItems = @[[self spacer], backButtonItem];
    }else{
        self.navigationItem.leftBarButtonItem = backButtonItem;
    }
    
    [backButtonItem release];
    
}


- (UIButton *)setBackBarButton{
    UIImage *image = [UIImage imageNamed:@"icon_back.png"];
    UIButton *backButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)] autorelease];
    [backButton setImage:image forState:UIControlStateNormal];
    

    /*
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        [backButton  setImageEdgeInsets:UIEdgeInsetsMake(0, -24,0, 24)];
    }
    else
    {
        [backButton  setImageEdgeInsets:UIEdgeInsetsMake(0,0, 0,0)];
    }
    */
    return backButton;
}


- (void)setRightBarButtonItem:(UIView *)view{
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    if ([self isIOS7]) {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItems = @[[self spacer], rightButtonItem];
    }else{
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    
    
    [rightButtonItem release];
}

- (void)setRightBarButtonItem:(UIView *)view offset:(CGFloat)offset{
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    if ([self isIOS7]) {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItems = @[[self spacer:offset], rightButtonItem];
    }else{
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    
    
    [rightButtonItem release];
}




@end
