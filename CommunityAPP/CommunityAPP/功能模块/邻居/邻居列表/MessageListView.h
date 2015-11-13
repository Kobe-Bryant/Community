//
//  MessageListView.h
//  IMDemo
//
//  Created by Dream on 14-7-18.
//  Copyright (c) 2014年 Yunlai-mac02. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessageListViewDelegate <NSObject>
@optional
-(void)enterChatVc:(NSString *)sender;

@end
@interface MessageListView : UIView<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_messageListTableView;
}

@property (nonatomic, assign) id<MessageListViewDelegate> delegate;

@end
