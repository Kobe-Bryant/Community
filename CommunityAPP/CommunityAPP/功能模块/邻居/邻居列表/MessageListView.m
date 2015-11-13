//
//  MessageListView.m
//  IMDemo
//
//  Created by Dream on 14-7-18.
//  Copyright (c) 2014年 Yunlai-mac02. All rights reserved.
//

#import "MessageListView.h"
#import "Global.h"
#import "NSObject_extra.h"

@implementation MessageListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initTableView];
    }
    return self;
}

- (void)initTableView {
    _messageListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.frame.size.height) style:UITableViewStylePlain];
    _messageListTableView.delegate = self;
    _messageListTableView.dataSource = self;
    _messageListTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    _messageListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_messageListTableView];
    [_messageListTableView release];
}

#pragma mark - UITabelView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MessageCell";
    UITableViewCell *cell = [_messageListTableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        UIImage *line = [UIImage imageNamed:@"bg_speacter_line@2x.png"];
        UIImageView *lineImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 74,line.size.width ,line.size.height)];
        lineImg.image = line;
        [cell.contentView addSubview:lineImg];
    }
    return cell;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(enterChatVc:)]) {
        [self.delegate enterChatVc:@"谁呢"];
    }
}


@end
