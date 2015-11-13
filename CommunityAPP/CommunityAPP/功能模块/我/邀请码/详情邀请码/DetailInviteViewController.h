//
//  DetailInviteViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-4-4.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface DetailInviteViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate>
{
    UITableView *detailInviteTableView;
}
@property (nonatomic,retain) NSString *passStr;

@end
