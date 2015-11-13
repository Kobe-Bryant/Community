//
//  TeamViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-5-24.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamViewController : UIViewController<UIWebViewDelegate>
{
    UIWebView *webView;
    
    UIActivityIndicatorView *indicatorView;
}
@end
