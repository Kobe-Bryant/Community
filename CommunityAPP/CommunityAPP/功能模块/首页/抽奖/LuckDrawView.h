//
//  LuckDrawView.h
//  CommunityAPP
//
//  Created by yunlai on 14-4-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LuckDrawView : UIView<UIWebViewDelegate>
{
    UIWebView *webView;
    
    UIActivityIndicatorView *indicatorView;
    
    UIViewController *lastViewController;
}
- (id)initWithFrame:(CGRect)frame viewController:(id)viewController;
@end
