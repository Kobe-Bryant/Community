//
//  NoticeViewController.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-5.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "NoticeViewController.h"
#import "NSObject_extra.h"
#import "Global.h"
#import "NoticeTableViewCell.h"
#import "NoticeDetailViewController.h"
#import "CommunityHttpRequest.h"
#import "UserModel.h"
#import "AppConfig.h"
#import "DataBaseManager.h"
#import "NSObject+Time.h"
#import "MJRefresh.h"
#import "UpdateTimeModel.h"
#import "UIViewController+NavigationBar.h"
#import "MobClick.h"

@interface NoticeViewController (){
    MJRefreshHeaderView *_header;
}

@property (nonatomic, retain) CommunityHttpRequest *request;
@property (nonatomic,retain) NSMutableArray *noticeArr;
@property (nonatomic, retain) DataBaseManager *dbManager;

@end

@implementation NoticeViewController
@synthesize request = _request;
@synthesize noticeArr;

- (void)dealloc{
    [_header free];
    noticeTableView.delegate = nil;
    noticeTableView.dataSource = nil;
     [_request cancelDelegate:self];
    [noticeTableView release];  noticeTableView = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.noticeArr = [[NSMutableArray alloc]initWithCapacity:0];
        _dbManager = [DataBaseManager shareDBManeger];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"NoticePage"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"NoticePage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"通知"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
//    列表
    noticeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,MainHeight) style:UITableViewStylePlain];
    noticeTableView.delegate = self;
    noticeTableView.dataSource = self;
    noticeTableView.showsVerticalScrollIndicator = NO;
    noticeTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    noticeTableView.backgroundColor = [UIColor whiteColor];
    noticeTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
     //[noticeTableView setSeparatorInset:UIEdgeInsetsZero];//ios7分割线显示完整
    [self.view addSubview:noticeTableView];
    
    //查询数据库
    self.noticeArr = [_dbManager selectNoticeModel];
    [noticeTableView reloadData];
    
        // 网络请求ß®
        if (_request == nil) {
            _request = [CommunityHttpRequest shareInstance];
        }
     UpdateTimeModel *model = [_dbManager selectUpdateTimeByInterface:COMMUNITY_NOTICE_INFO];
     UserModel *userModel = [UserModel shareUser];
     NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&%@=%@",UPDATE_TIME,model.date,USER_ID,userModel.userId,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId];//参数
     NSLog(@"parameters %@",parameters);
     [_request requestNotice:self parameters:parameters];
 
    //一进来就显示刷新loading
//    [self performSelector:@selector(addHeader) withObject:nil afterDelay:0.5];

    [self addHeader];
}


//返回
-(void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)findLocalData{
    [self.noticeArr removeAllObjects];
    NSArray *array = [_dbManager selectNoticeModel];
    [self.noticeArr addObjectsFromArray:array];
    [noticeTableView reloadData];
}

#pragma mark ---refresh
- (void)addHeader
{
    __unsafe_unretained NoticeViewController *vc = self;
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = noticeTableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        NSLog(@"%@",vc);
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:1.0];

    };
    _header = header;
    [_header beginRefreshing];
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [noticeTableView reloadData];
    // (最好在刷新表格后调用)调用1可以结束刷新状态
    [refreshView endRefreshing];
}


#pragma UITableViewDelegate
#pragma mark UITableViewDataSource implementation
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.noticeArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeTableView"];
    if (cell == nil) {
        cell = [[[NoticeTableViewCell alloc] initWithStyle:
                 UITableViewCellStyleSubtitle reuseIdentifier:@"NoticeTableView"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        }
    NOticeModel *model = [self.noticeArr objectAtIndex:indexPath.row];

    NSDate *formateDate = [NSObject fromatterDateFromStr:model.noticeCreateTime];
    NSString *time = [NSObject compareCurrentTime:formateDate];
    //存放网络数据
    cell.titleLabel.text = model.noticeTitle;
    cell.timeLabel.text = time;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    //当extro为1时，标为已读
    if ([model.extra isEqualToString:@"1"]) {
        cell.titleLabel.frame = CGRectMake(cell.iconImageView.frame.origin.x+cell.iconImageView.frame.size.width+10,cell.iconImageView.frame.origin.y, 235, 20);
        cell.titleLabel.font = [UIFont systemFontOfSize:15];
        cell.titleLabel.textColor = RGB(153, 153, 153);
        cell.redpointLable.hidden = YES;
        
    }else{
        cell.redpointLable.hidden = NO;
        cell.titleLabel.frame = CGRectMake(cell.iconImageView.frame.origin.x+cell.iconImageView.frame.size.width+21,cell.iconImageView.frame.origin.y, 235, 20);
        cell.titleLabel.font = [UIFont systemFontOfSize:15];
        cell.titleLabel.textColor = RGB(69, 69, 69);
    }
    return cell;
}

#pragma mark UITableViewDelegate implementation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //点中选中状态，再刷新列表
    NOticeModel *model = [self.noticeArr objectAtIndex:indexPath.row];
    model.extra = [NSString stringWithFormat:@"1"];
    BOOL flag = [_dbManager updateNoticeModel:model];
    if (flag) {
        NSLog(@"更新成功");
    }else{
        NSLog(@"更新失败");
    }
    NoticeDetailViewController *detailVc = [[NoticeDetailViewController alloc] init];
    detailVc.noticeModel = model;
    [self.navigationController pushViewController:detailVc animated:YES];
    [noticeTableView reloadData];
    [detailVc release];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
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
        NOticeModel *model = [self.noticeArr objectAtIndex:indexPath.row];
        // 删除数据库中数据
        [_dbManager deleteNoticeWithId:model.noticeId];
        [self.noticeArr removeObjectAtIndex:indexPath.row];
        [noticeTableView reloadData];
    }
}
#pragma mark ------
-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSString *code = [data objectForKey:ERROR_CODE];
        if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            UpdateTimeModel *updateModel = [[UpdateTimeModel alloc] init];
            updateModel.type = [NSString stringWithFormat:@"%d",COMMUNITY_NOTICE_INFO];
            updateModel.date = [data objectForKey:@"updateTime"];
            _dbManager = [DataBaseManager shareDBManeger];
            BOOL flag = [_dbManager insertRequestUpdateTime:updateModel];
            if (flag) {
                NSLog(@"插入更新时间成功");
            }
            [updateModel release];
        }}
    if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
        NSArray *array = [data objectForKey:@"attentions"];
            for (NSDictionary *dic in array) {
                NOticeModel  *model = [[[NOticeModel alloc]init] autorelease];
                model.noticeId = [[dic objectForKey:@"id"] integerValue];
                model.noticeTitle = [dic objectForKey:@"title"];
                model.noticeContentLabel = [dic objectForKey:@"contentLabel"];
                model.noticeCreateTime = [dic objectForKey:@"createTime"];
                model.noticeIsUrl = [dic objectForKey:@"isUrl"];
                model.noticeContent = [dic objectForKey:@"content"];
                model.extra = [NSString stringWithFormat:@"0"];
                
                //0代表未读  1代表已读
                //插入数据
                BOOL flag = [_dbManager inserNoticeModel:model];
                if (flag) {
                    NSLog(@"插入成功");
                   }
                [self.noticeArr addObject:model];
            }
        [self findLocalData];
       
    }else{
        NSLog(@"小区介绍获取失败");
    }
      [noticeTableView reloadData];
}



@end
