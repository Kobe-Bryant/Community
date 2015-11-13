//
//  ConvenienceBusinessWebViewController.h
//  CommunityAPP
//
//  Created by yunlai on 14-6-16.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConvenienceBusinessWebViewController : UIViewController<UIWebViewDelegate>
{
    UIWebView *webView;
    
    UIActivityIndicatorView *indicatorView;
}
@property(nonatomic,retain)NSString *businessString;
@end
