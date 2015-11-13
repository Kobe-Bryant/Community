//
//  AwardRecordingView.m
//  CommunityAPP
//
//  Created by yunlai on 14-4-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "AwardRecordingView.h"
#import "Global.h"
#import "LuckDrawViewController.h"
#import "UserModel.h"
#import "AwardRecordingModel.h"
#import "UIImageView+WebCache.h"

@implementation AwardRecordingView
@synthesize listArray;

-(void)dealloc{
    [recordTableView release]; recordTableView = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame viewController:(id)viewController
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        lastViewController = viewController;
        [self initTableView];
        
//        if ([self.listArray count]==0) {
        //        请求当前的奖品列表
        [self requestAwardRecordingList];
//        }
    }
    return self;
}

-(void)requestAwardRecordingList{
    //加载网络数据
    [self hideHudView];
    hudView = [Global showMBProgressHud:self SuperView:lastViewController.view Msg:@"请稍候..."];//  请求验证是否正确
    
    // 网络请求ß®
    if (request == nil) {
        request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    NSString *string = [NSString stringWithFormat:@"?userId=%@&communityId=%@&propertyId=%@",userModel.userId,userModel.communityId,userModel.propertyId];//参数
    [request requestLotteryRrecode:self parameters:string];
}

-(void)initTableView{
    recordTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.frame.size.height) style:UITableViewStylePlain];
    recordTableView.backgroundColor = RGB(244, 244, 244);
    recordTableView.delegate = self;
    recordTableView.dataSource = self;
    recordTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    [self addSubview:recordTableView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma UITableViewDelegate
#pragma mark UITableViewDataSource implementation
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AwardRecordingTableView"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:
                 UITableViewCellStyleSubtitle reuseIdentifier:@"AwardRecordingTableView"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        UIImage *iconImage = [UIImage imageNamed:@"bg_sample_4.png"];
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, iconImage.size.width, iconImage.size.height)];
        iconImageView.image = iconImage;
        iconImageView.tag = 77777;
        [cell addSubview:iconImageView];
        [iconImageView release];
        
        //名称
        UILabel *nameLabel = [[UILabel alloc ]  initWithFrame:
                              CGRectMake(iconImageView.frame.size.width+iconImageView.frame.origin.x+10, 12, 210, 22)];
        nameLabel.text = @"iphone6";
        nameLabel.tag = 77778;
        nameLabel.textColor= RGB(53, 53, 53);
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font=[UIFont systemFontOfSize:16];
        [cell addSubview:nameLabel];
        [nameLabel release];
        
//      时间
        UILabel *timeLabel = [[UILabel alloc ]  initWithFrame:
                              CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.size.height+nameLabel.frame.origin.y+4, 150, 18)];
        timeLabel.text = @"2014-04-20 18:30";
        timeLabel.tag = 77779;
        timeLabel.textColor=[UIColor grayColor];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font=[UIFont systemFontOfSize:14];
        [cell addSubview:timeLabel];
        [timeLabel release];
        
//        待发货 还是未发货的图片
        UIImage *waitImage = [UIImage imageNamed:@"bg_awardView_acceptGood.png"];
        UIImageView *waitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(220, timeLabel.frame.origin.y+2, waitImage.size.width, waitImage.size.height)];
        waitImageView.tag = 77780;
        waitImageView.image = waitImage;
        waitImageView.backgroundColor = [UIColor clearColor];
        [cell addSubview:waitImageView];
        [waitImageView release];
        
        //    状态
        UILabel *statusLabel = [[UILabel alloc ]  initWithFrame:
                              CGRectMake(waitImageView.frame.origin.x+waitImageView.frame.size.width+2, waitImageView.frame.origin.y, 70, 18)];
        statusLabel.text = @"待发货";
        statusLabel.tag = 77781;
        statusLabel.textColor = RGB(104, 184, 77);
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.font = [UIFont systemFontOfSize:15];
        [cell addSubview:statusLabel];
        [statusLabel release];
    }
    AwardRecordingModel *model = [self.listArray objectAtIndex:indexPath.row];
    UIImageView *iconImageViewTag = (UIImageView *)[cell viewWithTag:77777];
    [iconImageViewTag setImageWithURL:[NSURL URLWithString:model.picUrlString] placeholderImage:[UIImage imageNamed:@"bg_sample_4.png"]];
    UILabel *nameLabelTag = (UILabel *)[cell viewWithTag:77778];
    nameLabelTag.text = model.titleString;
    UILabel *timeLabelTag = (UILabel *)[cell viewWithTag:77779];
    timeLabelTag.text = model.getTimeString;
    UIImageView *waitImageViewTag = (UIImageView *)[cell viewWithTag:77780];
    UILabel *statusLabelTag = (UILabel *)[cell viewWithTag:77781];
//    2：待发货；3：已发货；4：已收货
    if ([model.statusString integerValue]==2) {
        statusLabelTag.text = @"待发货";
        waitImageViewTag.image = [UIImage imageNamed:@"bg_awardView_waitC.png"];
    }else if ([model.statusString integerValue]==3) {
        statusLabelTag.text = @"已发货";
        waitImageViewTag.image = [UIImage imageNamed:@"bg_awardView_sendGood.png"];
    }else{
        statusLabelTag.text = @"已收货";
        waitImageViewTag.image = [UIImage imageNamed:@"bg_awardView_acceptGood.png"];
    }
    return cell;
}
#pragma mark UITableViewDelegate implementation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AwardRecordingModel *model = [self.listArray objectAtIndex:indexPath.row];
    [lastViewController awardDetail:model];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark
-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    NSLog(@"interface :%d status:%@",interface,status);
    [self hideHudView];
    if (interface == COMMENT_LOTTERY_RECODE) {
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            NSArray *array = [data objectForKey:@"recordList"];
            NSMutableArray *object_Arr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in array) {
                AwardRecordingModel  *model = [[AwardRecordingModel alloc] init];
                model.contentString = [dic objectForKey:@"content"];
                model.getTimeString = [dic objectForKey:@"getTime"];
                model.idString = [dic objectForKey:@"id"];
                model.isUrlString = [dic objectForKey:@"isUrl"];
                model.picUrlString = [dic objectForKey:@"picUrl"];
                model.statusString = [dic objectForKey:@"status"];
                model.titleString = [dic objectForKey:@"title"];
                [object_Arr addObject:model];
                [model release];
            }
            self.listArray = object_Arr;
            [object_Arr release]; //add Vincent 内存释放
            
            if ([self.listArray count]==0) {
                [Global showMBProgressHudHint:self SuperView:lastViewController.view Msg:@"当前没有数据" ShowTime:1.0];
            }else {
                [recordTableView reloadData];
            }
        }
    }
}
- (void) hideHudView
{
    if (hudView) {
        [hudView hide:YES];
    }
}
@end
