//
//  MessagesListView.m
//  CommunityAPP
//
//  Created by yunlai on 14-5-7.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "MessagesListView.h"
#import "Global.h"
#import "DataBaseManager.h"
#import "FriendUserInformationModel.h"
#import "UIImageView+WebCache.h"
#import "FriendAndGroupListModel.h"
#import "NSObject_extra.h"
#import "TQRichTextView.h"
#import "FriendListDetailInfromation.h"
#import "NeighboorHoodFriendList.h"

@implementation MessagesListView
@synthesize listArray;
-(void)dealloc{
    [noDataContentLabel release];  noDataContentLabel = nil;
//    [messagesListTableView release]; messagesListTableView = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame delegateController:(UIViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        lastViewC = controller;

        [self getMessageListData];
        
    }
    return self;
}

-(void)haveNoMessageList{
    noDataContentLabel = [[UILabel alloc ]  initWithFrame:
                          CGRectMake(0, self.frame.size.height/2, MainWidth, 22)];
    noDataContentLabel.text = GlobalCommunityNoDataWarning;
    noDataContentLabel.textColor = RGB(53, 53, 53);
    noDataContentLabel.hidden = YES;
    noDataContentLabel.textAlignment = NSTextAlignmentCenter;;
    noDataContentLabel.backgroundColor = [UIColor clearColor];
    noDataContentLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:noDataContentLabel];
}

#pragma mark - my method
-(void)getMessageListData{
    self.listArray = [[NSMutableArray alloc] init];
    DataBaseManager *dbManager = [DataBaseManager shareDBManeger];
    NSArray *tempArray = [dbManager selectMessageList];
    NSArray *friendInfrArray = [dbManager selectNeighboorHoodList];
    for (int i = 0; i<[tempArray count]; i++) {
        XmppMessageListModel *xmppMessageList = [tempArray objectAtIndex:i];
        for (int  j = 0; j<[friendInfrArray count]; j++) {
            NeighboorHoodFriendList *infromationModel = [friendInfrArray objectAtIndex:j];
            NSString *jidString;
            NSArray *jidStringArray = [xmppMessageList.fromJidString componentsSeparatedByString:@"/"];
            if ([jidStringArray count]!=0) {
                jidString = [jidStringArray objectAtIndex:0];
            }else{
                jidString = xmppMessageList.fromJidString;
            }
            NSString *userString = [infromationModel.usernameString stringByAppendingString:[NSString stringWithFormat:@"@%@",kHost]];
            NSLog(@"%@",userString);
            if ([jidString isEqualToString:userString]) {
                xmppMessageList.iconString = infromationModel.avatarString;
                xmppMessageList.sexString = infromationModel.genderString;
                xmppMessageList.nickNameString = infromationModel.nicknameString;
                xmppMessageList.signString = infromationModel.signatureString;
                [dbManager updateMessageList:xmppMessageList];
                
            }
        }
    }
    [self initTableView];
    [self haveNoMessageList];
//    从数据库中读取数据
    [self requestList];
}

-(void)requestList{
    DataBaseManager *dbManager = [DataBaseManager shareDBManeger];
    self.listArray = [dbManager selectMessageList];
    if ([self.listArray count]!=0) {
        noDataContentLabel.hidden = YES;
        
        [messagesListTableView reloadData];
    }else{
        [messagesListTableView removeFromSuperview];
    
        //        当前没有数据
        noDataContentLabel.hidden = NO;
    }
}

-(void)initTableView{
    messagesListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.frame.size.height)];
    messagesListTableView.backgroundColor = [UIColor whiteColor];
    messagesListTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    messagesListTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    messagesListTableView.dataSource = self;
    messagesListTableView.delegate = self;
    [self addSubview:messagesListTableView];
    [messagesListTableView release];
}

-(void)lableTap:(UITapGestureRecognizer *)sender{
    NSLog(@"sender = %d",sender.view.tag);
    XmppMessageListModel *model = [self.listArray objectAtIndex:sender.view.tag];
    DataBaseManager *dbManager = [DataBaseManager shareDBManeger];
    model.isRead = @"1";
    BOOL flag = [dbManager updateMessageList:model];
    if (flag) {
        NSLog(@"更新成功");
    }else{
        NSLog(@"更新失败");
    }
    [self requestList];
    
    XmppMessageListModel *modelList = [self.listArray objectAtIndex:sender.view.tag];
    [lastViewC messagelistEnterChatIngVc:modelList];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark -- uitableviewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        UIImage *iconImage = [UIImage imageNamed:@"default_head.png"];
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, iconImage.size.width, iconImage.size.height)];
        iconImageView.image = iconImage;
        iconImageView.layer.cornerRadius = 25.0f;
        iconImageView.layer.masksToBounds = YES;
        iconImageView.tag = 99997;
        [cell addSubview:iconImageView];
        [iconImageView release];
        
        UILabel *redpointLable = [self newLabelWithText:nil frame:CGRectMake(iconImageView.frame.size.width+iconImageView.frame.origin.x-11,iconImageView.frame.origin.y-2, 14, 20) font:[UIFont systemFontOfSize:20.0] textColor:[UIColor redColor]];
        redpointLable.tag = 100001;
        [cell addSubview:redpointLable];
        [redpointLable release];
        
        //        性别图片
        UIImage *sexImage = [UIImage imageNamed:@"icon_female.png"];
        UIImageView *sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(iconImageView.frame.size.width+iconImageView.frame.origin.x+5, iconImageView.frame.origin.y+5, sexImage.size.width, sexImage.size.height)];
        sexImageView.image = sexImage;
        sexImageView.tag = 99998;
        [cell addSubview:sexImageView];
        [sexImageView release];

        //    title
        UILabel *nameLabel = [[UILabel alloc ]  initWithFrame:
                              CGRectMake(sexImageView.frame.size.width+sexImageView.frame.origin.x+3, iconImageView.frame.origin.y, 180, 22)];
        nameLabel.text = @"胖墩也很可爱";
        nameLabel.tag = 99999;
        nameLabel.textColor=[UIColor blackColor];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font=[UIFont systemFontOfSize:18];
        [cell addSubview:nameLabel];
        [nameLabel release];
        
        TQRichTextView *signLabel = [[TQRichTextView alloc] initWithFrame:CGRectMake(sexImageView.frame.origin.x, nameLabel.frame.size.height+nameLabel.frame.origin.y+3, 230, 35)];
        signLabel.font = [UIFont systemFontOfSize:14];
        signLabel.tag = 100000;
        signLabel.backgroundColor = [UIColor clearColor];
        signLabel.textColor = [UIColor lightGrayColor];;
        [cell addSubview:signLabel];
        [signLabel release];
    }
    XmppMessageListModel *xmppMessageList = [self.listArray objectAtIndex:indexPath.row];
    UIImageView *iconImageViewTag = (UIImageView *)[cell viewWithTag:99997];
    UIImageView *sexImageViewTag = (UIImageView *)[cell viewWithTag:99998];
    UILabel *nameLabelTag = (UILabel *)[cell viewWithTag:99999];
    TQRichTextView *signLabelTag = (TQRichTextView *)[cell viewWithTag:100000];
    UILabel *redpointLableTag = (UILabel *)[cell viewWithTag:100001];
    [iconImageViewTag setImageWithURL:[NSURL URLWithString:xmppMessageList.iconString] placeholderImage:[UIImage imageNamed:@"default_head.png"]];
    signLabelTag.text = xmppMessageList.bodyString;
    
    UITapGestureRecognizer *labTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lableTap:)];
    signLabelTag.tag = indexPath.row;
    [signLabelTag addGestureRecognizer:labTap];
    [labTap release];
    
    if([xmppMessageList.sexString isEqualToString:@"1"]){
        sexImageViewTag.image = [UIImage imageNamed:@"icon_male1.png"];
    }else{
        sexImageViewTag.image = [UIImage imageNamed:@"icon_female1.png"];
    }
    if ([xmppMessageList.isRead isEqualToString:@"0"]) {
        redpointLableTag.text = @"●";
    }else{
        redpointLableTag.text = @"";
    }
    if (xmppMessageList.nickNameString) {
        nameLabelTag.text = xmppMessageList.nickNameString;
    }else{
        nameLabelTag.text = [[xmppMessageList.fromJidString componentsSeparatedByString:@"@"] objectAtIndex:0];
    }
//    nameLabelTag.text = xmppMessageList.nickNameString;
    return cell;
}

#pragma mark -- uitableviewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}
// 选中row执行的操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XmppMessageListModel *model = [self.listArray objectAtIndex:indexPath.row];
    DataBaseManager *dbManager = [DataBaseManager shareDBManeger];
    model.isRead = [NSString stringWithFormat:@"1"];
    BOOL flag = [dbManager updateMessageList:model];
    if (flag) {
        NSLog(@"更新成功");
    }else{
        NSLog(@"更新失败");
    }
    [self requestList];

}

#pragma mark - MessgeListRefreshDelegate
-(void)refreshMessageList{
    [self getMessageListData];
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableVie titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
}
// 当点击删除时，删除该条记录
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        XmppMessageListModel *model = [self.listArray objectAtIndex:indexPath.row];
        // 删除数据库中数据
        DataBaseManager *dbManager = [DataBaseManager shareDBManeger];
        [dbManager deleteMessageList:model];
        
        [self requestList];
        
        //    设置当前的红点
        AppDelegate *delegate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate setNeighboorBadge];
    }
}
@end
