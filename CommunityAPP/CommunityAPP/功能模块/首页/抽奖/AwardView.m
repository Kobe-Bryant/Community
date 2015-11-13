//
//  AwardView.m
//  CommunityAPP
//
//  Created by yunlai on 14-4-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "AwardView.h"
#import "Global.h"
#import <QuartzCore/QuartzCore.h>
#import "SubCollectionsCell.h"
#import "UserModel.h"
#import "AwardRecordingModel.h"
#import "UIImageView+WebCache.h"
#import "LuckDrawViewController.h"

@implementation AwardView
@synthesize listArray;

-(void)dealloc{
    [recordTableView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame viewController:(id)viewController;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        lastViewController = viewController;
//        [self loardAwardView];
        [self loardTableView];
        
        //        请求当前的奖品列表
        [self requestAwardViewList];
    }
    return self;
}

-(void)requestAwardViewList{
    // 网络请求ß®
    if (request == nil) {
        request = [CommunityHttpRequest shareInstance];
    }
    //    userModel.userId
    UserModel *userModel = [UserModel shareUser];
    NSString *string = [NSString stringWithFormat:@"?userId=%@&communityId=%@&propertyId=%@",userModel.userId,userModel.communityId,userModel.propertyId];//参数
    [request requestLotteryProduct:self parameters:string];
}

-(void)loardTableView{
    recordTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.frame.size.height) style:UITableViewStylePlain];
    recordTableView.backgroundColor = [UIColor whiteColor];
    recordTableView.delegate = self;
    recordTableView.dataSource = self;
    recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
-(void)cellviewTaped:(UITapGestureRecognizer *)recognizer
{
    int tag=[recognizer view].tag-8000;
    NSLog(@"%d",tag);
    AwardRecordingModel *model=[self.listArray objectAtIndex:tag];
    [lastViewController awardDetail:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 155;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.listArray.count-1)/CommunityRowcellCount+1;
}

-(void)selectBtItem:(id)sender{
 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier1 = @"Cell1";
    SubCollectionsCell *cell =(SubCollectionsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (cell == nil)
    {
        cell = [[[SubCollectionsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] autorelease];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    NSUInteger row=[indexPath row];
    for (NSInteger i = 0; i < 2; i++)
    {
        //奇数
        if (row*2+i>self.listArray.count-1)
        {
            break;
        }
        AwardRecordingModel *model=[self.listArray objectAtIndex:row*CommunityRowcellCount + i];
        if (i==0)
        {
            /*
             UIViewContentModeScaleToFill,
             UIViewContentModeScaleAspectFit,      // contents scaled to fit with fixed aspect. remainder is transparent
             UIViewContentModeScaleAspectFill,
             */
            [cell.cellView1.iconImageView setImageWithURL:[NSURL URLWithString:model.picUrlString] placeholderImage:[UIImage imageNamed:@"bg_sample_5.png"]];
            cell.cellView1.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
            [cell.cellView1.titleNameLabel setText:model.titleString];
            cell.cellView1.tag=8000+row*CommunityRowcellCount + i;
            
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellviewTaped:)];
            [ cell.cellView1 addGestureRecognizer:tapRecognizer];
            [tapRecognizer release];
        }
        else
        {
            [cell.cellView2.iconImageView setImageWithURL:[NSURL URLWithString:model.picUrlString] placeholderImage:[UIImage imageNamed:@"bg_sample_5.png"]];
            cell.cellView2.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
            [cell.cellView2.titleNameLabel setText:model.titleString];
            
            cell.cellView2.tag=8000+row*CommunityRowcellCount + i;
            
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellviewTaped:)];
            [ cell.cellView2 addGestureRecognizer:tapRecognizer];
            [tapRecognizer release];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark
-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    NSLog(@"interface :%d status:%@",interface,status);
    if (interface == COMMENT_LOTTERY_PRODUCT) {
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            NSArray *array = [data objectForKey:@"productList"];
            NSMutableArray *object_Arr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in array) {
                AwardRecordingModel  *model = [[AwardRecordingModel alloc] init];
                model.contentString = [dic objectForKey:@"content"];
                model.idString = [dic objectForKey:@"id"];
                model.isUrlString = [dic objectForKey:@"isUrl"];
                model.picUrlString = [dic objectForKey:@"picUrl"];
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
@end
