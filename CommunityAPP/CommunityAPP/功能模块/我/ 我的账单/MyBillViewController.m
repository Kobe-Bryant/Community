//
//  MyBillViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-5.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "MyBillViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "MyBillListBean.h"
#import "MyBillUITableViewCell.h"
#import "UserModel.h"
#import "MJRefresh.h"
#import "CommunityIntroduceModel.h"
#import "UIViewController+NavigationBar.h"
#import "MobClick.h"

@interface MyBillViewController (){
  MJRefreshHeaderView *_header;
    
    NSString *_yearTime;
    NSString *_yearTotal;
}
@property (nonatomic, retain) NSString *yearTime;
@property (nonatomic,retain) NSString *yearTotal;
@property (nonatomic, retain) NSMutableArray *yearTimeArray;
@property (nonatomic, retain) NSMutableArray *yearTotalArray;

@end

@implementation MyBillViewController
@synthesize myBillMutableDictionary =_myBillMutableDictionary;
@synthesize billArray = _billArray;
@synthesize billArray1 = _billArray1;
@synthesize yearTime = _yearTime;
@synthesize yearTotal = _yearTotal;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _myBillMutableDictionary = [[NSMutableDictionary alloc]init];
        _billArray = [[NSMutableArray alloc] init];
        _billArray1 = [[NSMutableArray alloc] init];
        self.yearTimeArray = [[NSMutableArray alloc]initWithCapacity:0];
        self.yearTotalArray = [[NSMutableArray alloc]initWithCapacity:0];
        }
    return self;
}
- (void)dealloc
{   [_header free];
    [request cancelDelegate:self];
    [_billArray release]; _billArray = nil;
    [_myBillMutableDictionary release]; _myBillMutableDictionary = nil;
    [self.yearTimeArray release]; self.yearTimeArray = nil;
    [self.yearTotalArray release]; self.yearTotalArray = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MyBillPage"]; // 友盟统计
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MyBillPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationController setNavigationBarHidden:NO];
    self.view.backgroundColor = RGB(244, 244, 244);
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"我的账单"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    [self requestTableViewData]; //加载tableview视图
    [self requestBillList]; //网络请求我的账单数据

}

-(void)requestBillList{
    //    请求当前的我的账单  add by vincent
    if (request == nil) {
        request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    NSString *string = [NSString stringWithFormat:@"?updateTime=%@&userId=%@&communityId=%@&propertyId=%@&lastTimeLabel=%@",DEF_UPDATE_TIME,userModel.userId,userModel.communityId,userModel.propertyId,@""];//参数
    [request requestBillList:self parameters:string];
}

-(void)requestTableViewData{
    //uitableview视图
    myBillTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, MainHeight) style:UITableViewStylePlain];
    myBillTableView.delegate = self;
    myBillTableView.dataSource = self;
    myBillTableView.showsHorizontalScrollIndicator = NO;
    myBillTableView.showsVerticalScrollIndicator = NO;
    myBillTableView.backgroundView = nil;
    myBillTableView.backgroundColor = [UIColor clearColor];
    myBillTableView.backgroundView.backgroundColor = RGB(244, 244, 244);
    myBillTableView.sectionHeaderHeight = 10.0;
    myBillTableView.sectionFooterHeight = 10.0;
    myBillTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    [self.view addSubview:myBillTableView];
    [myBillTableView release];
    //一进来就显示刷新loading
    [self addHeader];
}

#pragma mark ---refresh
- (void)addHeader
{
    __unsafe_unretained MyBillViewController *vc = self;
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = myBillTableView;
    
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:1.0];
    };
    _header = header;
    [_header beginRefreshing];
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    if ([[_myBillMutableDictionary objectForKey:@"monthBills"] count]==0) {
        UILabel *noDataContentLabel = [[UILabel alloc ]  initWithFrame:
                                       CGRectMake(0, (self.view.frame.size.height-64)/2, MainWidth, 22)];
        noDataContentLabel.text = GlobalCommunityNoDataWarning;
        noDataContentLabel.textColor = RGB(53, 53, 53);
        noDataContentLabel.hidden = NO;
        noDataContentLabel.textAlignment = NSTextAlignmentCenter;;
        noDataContentLabel.backgroundColor = [UIColor clearColor];
        noDataContentLabel.font = [UIFont systemFontOfSize:17];
        [self.view addSubview:noDataContentLabel];
        [noDataContentLabel release];
        //[Global showMBProgressHudHint:self SuperView:self.view Msg:@"当前没有数据" ShowTime:1.0];
    }

    [myBillTableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

#pragma mark - uitableviewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   NSInteger count = [[_myBillMutableDictionary objectForKey:@"monthBills"] count];
    return count;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *monthBillsArray = [_myBillMutableDictionary objectForKey:@"monthBills"];
    NSDictionary *dic = ([monthBillsArray count] > section) ? [monthBillsArray objectAtIndex:section]: nil;
        
    NSArray *array = [dic objectForKey:@"bills"];
    return [array count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indefer = @"Cell";
    MyBillUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indefer];
    if (cell == nil) {
        cell = [[[MyBillUITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indefer]autorelease];
        cell.textLabel.textColor = RGB(57, 57, 57);
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundView = [[[UIView alloc]initWithFrame:cell.bounds] autorelease];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    NSMutableArray *arry = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableDictionary *tic = [[_myBillMutableDictionary objectForKey:@"monthBills"] objectAtIndex:indexPath.section];
    NSArray *billsArr = [tic objectForKey:@"bills"];
    for (NSDictionary *dic in billsArr) {
        MyBillListBean *listBean = [[MyBillListBean alloc] init];
        listBean.timeLabelString = [tic objectForKey:@"timeLabel"];
        listBean.amountString = [dic objectForKey:@"total"];     //moneyOne
        listBean.countString  = [dic objectForKey:@"count"];
        listBean.damagesString = [dic objectForKey:@"damages"];
        listBean.endTimeString = [dic objectForKey:@"endTime"];
        listBean.idString = [dic objectForKey:@"id"];
        listBean.priceString = [dic objectForKey:@"price"];
        listBean.readingsString = [dic objectForKey:@"readings"];
        listBean.startTimeString = [dic objectForKey:@"startTime"];
        listBean.statusString = [dic objectForKey:@"status"];
        listBean.titleString = [dic objectForKey:@"title"];
        listBean.totalString = [dic objectForKey:@"moneyOne"];     //total
        listBean.typeString = [dic objectForKey:@"type"];
        listBean.unitString = [dic objectForKey:@"unit"];
        listBean.oldArrearsString = [dic objectForKey:@"oldArrears"];
        [arry addObject:listBean];
        [listBean release]; //add vincent 内存释放
    }
    self.billArray = arry;
    MyBillListBean *listBean = [self.billArray objectAtIndex:indexPath.row];

    cell.billTitleLab.text = listBean.titleString;
//  账单类型(2 水费，3 电费，4 煤气费，5 其他) type
    if ([listBean.typeString integerValue]==3) {
        cell.iconImage.image = [UIImage imageNamed:@"icon_electricity1.png"];
    }else if ([listBean.typeString integerValue]==2){
        cell.iconImage.image = [UIImage imageNamed:@"icon_water1.png"];
    }else{
        cell.iconImage.image = [UIImage imageNamed:@"icon_other.png"];
    }
    cell.electricMoneyLab.text = [NSString stringWithFormat:@"¥%@",listBean.amountString];
    //    状态 1 已缴费 2 代缴 3 逾期
    if ([listBean.statusString integerValue] ==1) {
        cell.electricStateLab.text = @"已缴费";
    }else if([listBean.statusString integerValue] == 2){
        cell.electricStateLab.text = @"待缴";
    }else{
        cell.electricStateLab.text = @"逾期";
    }
    return cell;
}

#pragma mark - uitableviewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

//设置headerView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //设置headerView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    headerView.layer.borderWidth = 0.5;
    headerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    headerView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    
    //设置headerView里的内容
    UILabel *headerYearLab = [[UILabel alloc] initWithFrame:CGRectMake(10,13, 100, 20)];//创建一个UILable（headerLab）用来显示标题
    headerYearLab.backgroundColor = [UIColor clearColor];//设置headerLab的背景颜色
    headerYearLab.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];//设置headerLab的字体颜色
    headerYearLab.font = [UIFont systemFontOfSize:15.0];
    headerYearLab.text = [self.yearTimeArray objectAtIndex:section];//self.yearTime;
    //[dic objectForKey:@"timeLabel"]
    UILabel *headerCountLab = [[UILabel alloc]initWithFrame:CGRectMake(210, 13, 50, 20)];
    headerCountLab.backgroundColor = [UIColor clearColor];
    headerCountLab.textColor = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1];
    headerCountLab.font = [UIFont systemFontOfSize:13.0];
    headerCountLab.text = @"[合计]";
    
    //合计钱数
    UILabel *headerMoneyLab = [[UILabel alloc]initWithFrame:CGRectMake(260, 13, 50, 20)];
    headerMoneyLab.backgroundColor = [UIColor clearColor];
    headerMoneyLab.textColor = [UIColor colorWithRed:215/255.0 green:43/255.0 blue:0 alpha:1];
    headerMoneyLab.font = [UIFont systemFontOfSize:13.0];
    headerMoneyLab.text = [NSString stringWithFormat:@"%@",[self.yearTotalArray objectAtIndex:section]]; //self.yearTotal
    //[dic objectForKey:@"total"]
    [headerView addSubview:headerYearLab];
    [headerView addSubview:headerCountLab];
    [headerView addSubview:headerMoneyLab];
    [headerYearLab release];
    [headerCountLab release];
    [headerMoneyLab release];
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetialElectricBillViewController *electricVc = [[DetialElectricBillViewController alloc]init];
    
    NSMutableArray *arry = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableDictionary *tic = [[_myBillMutableDictionary objectForKey:@"monthBills"] objectAtIndex:indexPath.section];
    NSArray *billsArr = [tic objectForKey:@"bills"] ;
    for (NSDictionary *dic in billsArr) {
        MyBillListBean *listBean = [[MyBillListBean alloc] init];
        listBean.timeLabelString = [tic objectForKey:@"timeLabel"];
        listBean.amountString = [dic objectForKey:@"total"];     //moneyOne
        listBean.countString  = [dic objectForKey:@"count"];
        listBean.damagesString = [dic objectForKey:@"damages"];
        listBean.endTimeString = [dic objectForKey:@"endTime"];
        listBean.idString = [dic objectForKey:@"id"];
        listBean.priceString = [dic objectForKey:@"price"];
        listBean.readingsString = [dic objectForKey:@"readings"];
        listBean.startTimeString = [dic objectForKey:@"startTime"];
        listBean.statusString = [dic objectForKey:@"status"];
        listBean.titleString = [dic objectForKey:@"title"];
        listBean.totalString = [dic objectForKey:@"moneyOne"];     //total
        listBean.typeString = [dic objectForKey:@"type"];
        listBean.unitString = [dic objectForKey:@"unit"];
        listBean.oldArrearsString = [dic objectForKey:@"oldArrears"];
        listBean.descriptionString = [dic objectForKey:@"description"];
        [arry addObject:listBean];
        [listBean release]; //add vincent 内存释放
    }
    self.billArray1 = arry;
    MyBillListBean *listBean = [self.billArray1 objectAtIndex:indexPath.row];
    electricVc.listBean = listBean;
   
    [self.navigationController pushViewController:electricVc animated:YES];
    [electricVc release]; //add vincent 内存释放
}
//导航返回按钮
-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------ 
//add by vincent
-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
        _myBillMutableDictionary = [data retain];
        for (NSInteger i = 0; i<[[data objectForKey:@"monthBills"] count] ; i++) {
            NSMutableDictionary *dic = [[data objectForKey:@"monthBills"] objectAtIndex:i];
            self.yearTime = [dic objectForKey:@"timeLabel"];
            self.yearTotal = [dic objectForKey:@"total"];
            [self.yearTimeArray addObject:self.yearTime];
            [self.yearTotalArray addObject:self.yearTotal];
        }}else{
        NSLog(@"小区介绍获取失败");
    }
   }
@end
