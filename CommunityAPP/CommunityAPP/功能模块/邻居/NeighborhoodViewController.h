//
//  NeighborhoodViewController.h
//  CommunityAPP
//
//  Created by yunlai on 14-3-4.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;
@class MyNeighborView;
@class MessagesListView;
@class NeighboorHoodFriendList;
@class CommunityHttpRequest;

@interface NeighborhoodViewController : UIViewController
{
    MyNeighborView *neighborView;
    
    MessagesListView *messageListView;
    
     MBProgressHUD *hudView;
    
    UISegmentedControl *segmentControl;
    
    CommunityHttpRequest *request;
}
@property(nonatomic,assign)BOOL whichSegment;
//进入聊天界面
-(void)enterChatIngVc:(NeighboorHoodFriendList *)listGroup;

- (void) hideHudView;
@end
