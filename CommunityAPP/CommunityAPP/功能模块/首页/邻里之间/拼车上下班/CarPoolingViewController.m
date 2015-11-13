//
//  CarPoolingViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-7.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "CarPoolingViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "CarPoolingCell.h"
#import "AddCarPoolingViewController.h"
#import "CarPoolingDetailViewController.h"
#import "UserModel.h"
#import "CarPoolDataModel.h"
#import "UIImageView+WebCache.h"
#import "AppConfig.h"
#import "NSObject+Time.h"
#import "MJRefreshBaseView.h"
#import "UIButton+WebCache.h"
#import "NeighborhoodIntroduceViewController.h"
#import "MySelfViewController.h"
#import "UIViewController+NavigationBar.h"
#import "MJRefresh.h"
#import "MobClick.h"

@interface CarPoolingViewController ()
{
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}
@end

@implementation CarPoolingViewController
@synthesize listArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.listArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [request cancelDelegate:self];
    [carPoolingTableView release]; carPoolingTableView = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"拼车列表"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];

    
    //    右边按钮
    UIImage *rightImage = [UIImage imageNamed:@"icon_phone_add.png"];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:rightImage forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(275,0,44,44);
    [self setRightBarButtonItem:rightBtn];
    
    //列表视图
    carPoolingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, MainHeight) style:UITableViewStylePlain];
    carPoolingTableView.delegate = self;
    carPoolingTableView.dataSource = self;
    carPoolingTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    [self.view addSubview:carPoolingTableView];
    
    [self addHeader];//上拉刷新
    [self addFooter];//下拉刷新

    //    请求当前的数据
//    [self requestCarPoolData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //  请求当前的详情数据
    [self hideHudView];
    hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];//       请求验证验证码是否正确

    //    请求当前的数据
    [self requestCarPoolData];
    [MobClick beginLogPageView:@"CarPoolingPage"];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [MobClick endLogPageView:@"CarPoolingPage"];
}
-(void)requestCarPoolData{
    // 网络请求
    if (request == nil) {
        request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&%@=%@",USER_ID,userModel.userId,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,@"lastId",@"0"];//参数
    NSLog(@"parameters %@",parameters);
    [request requestCarPoolAdd:self parameters:parameters];
}

//进入详情的个人资料
//-(void)headImageViewBtnAction:(id)sender{
//    UIButton *headbtn = (UIButton *)sender;
//    UserModel *userModel = [UserModel shareUser];
//    CarPoolDataModel *model = [self.listArray objectAtIndex:headbtn.tag];
//    
//    if ([userModel.userId intValue] == [model.publisherIdString intValue]) {
//        MySelfViewController *myselfViewController = [[MySelfViewController alloc] init];//我的
//        myselfViewController.yesOrNo = YES;
//        [self.navigationController pushViewController:myselfViewController animated:YES];
//        [myselfViewController release];
//        
//    }else{
//        NeighborhoodIntroduceViewController *introduceVc = [[NeighborhoodIntroduceViewController alloc] initWithUserId:model.publisherIdString communityId:nil propertyId:nil name:model.publisherNameString];
//        [self.navigationController pushViewController:introduceVc animated:YES];
//        [introduceVc release];
//    }
//}
#pragma mark ---refresh
- (void)addFooter
{
    __unsafe_unretained CarPoolingViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = carPoolingTableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
    
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
    };
    _footer = footer;
}
- (void)addHeader
{
    __unsafe_unretained CarPoolingViewController *vc = self;
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = carPoolingTableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
    };
    _header = header;
}


- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    //[carPoolingTableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

#pragma mark -- uitableviewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarPoolingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CarPoolingListCell"];
    if (cell == nil) {
        cell = [[[CarPoolingCell alloc] initWithStyle:
                 UITableViewCellStyleSubtitle reuseIdentifier:@"CarPoolingListCell"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    CarPoolDataModel  *model = [self.listArray objectAtIndex:indexPath.row];
    [cell.headImageView setImageWithURL:[NSURL URLWithString:model.iconString] placeholderImage:[UIImage imageNamed:@"default_head.png"]];
    
    if ([model.sexString isEqualToString:@"男"]) {
        cell.sexImageView.image = [UIImage imageNamed:@"icon_male1.png"];
    }else{
        cell.sexImageView.image = [UIImage imageNamed:@"icon_female1.png"];
    }
    cell.nameLable.text = model.publisherNameString;

    NSDate *formateDate = [NSObject fromatterDateFromStr:model.createTimeString];
    NSString *time = [NSObject compareCurrentTime:formateDate];
    
    cell.timeLable.text = time;
    
    //add by devin (=2 则是打的士 其他的则是我有车)
    if ([model.typeString integerValue]==2) {
        cell.carImageView.image = [UIImage imageNamed:@"TAXI1.png"];
       //  cell.carLable.text = @"拼的士";
    }
    else{
        cell.carImageView.image = [UIImage imageNamed:@"IHAVECAR1.png"];
       // cell.carLable.text = @"我有车";
    }
    cell.commentLable.text = [NSString stringWithFormat:@"%@条评论",model.commentNumber] ;
    cell.goWorkLable.text = [NSString stringWithFormat:@"上班：%@",model.attendanceTimeString];
    cell.offWorkLable.text = [NSString stringWithFormat:@"下班：%@",model.closingTimeString];
    cell.returnLable.text = model.returnHomeString;
    cell.arriveLable.text = model.destinationString;
    return cell;
}

#pragma mark --Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CarPoolDataModel  *model = [self.listArray objectAtIndex:indexPath.row];
    CarPoolingDetailViewController *detailVc = [[CarPoolingDetailViewController alloc] init];
    detailVc.type = CMSHARECAR;
    detailVc.baseId = [NSString stringWithFormat:@"%d",model.idInteger];
    [self.navigationController  pushViewController:detailVc animated:YES];
    [detailVc release];
}
//导航栏左边按钮
-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
//导航栏右边按钮
-(void)addBtnAction
{
    AddCarPoolingViewController *addCarVc = [[AddCarPoolingViewController alloc]init];
    [self.navigationController pushViewController:addCarVc animated:YES];
    [addCarVc release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------
-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
        [self hideHudView];
        NSArray *array = [data objectForKey:@"carSharingList"];
        NSMutableArray *object_Arr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in array) {
            CarPoolDataModel  *model = [[CarPoolDataModel alloc]init];
            model.idInteger = [[dic objectForKey:@"id"] integerValue];
            model.residentId = [[dic objectForKey:@"userId"] integerValue];
            model.communityId = [[dic objectForKey:@"communityId"] integerValue];
            model.typeString = [dic objectForKey:@"type"];
            model.destinationString = [dic objectForKey:@"destination"];
            model.returnHomeString = [dic objectForKey:@"returnHome"];
            model.attendanceTimeString = [dic objectForKey:@"attendanceTime"];
            model.closingTimeString = [dic objectForKey:@"closingTime"];
            model.contactUsString = [dic objectForKey:@"contactUs"];
            model.remarkString = [dic objectForKey:@"remark"];
            model.createTimeString = [dic objectForKey:@"createTime"];
            model.publisherIdString = [dic objectForKey:@"publisherId"];
            model.publisherNameString = [dic objectForKey:@"publisherName"];
            model.iconString = [dic objectForKey:@"icon"];
            model.sexString = [dic objectForKey:@"sex"];
            model.commentNumber   = [dic objectForKey:@"commentNumber"];
            [object_Arr addObject:model];
            [model release];
        }
        self.listArray = object_Arr;
        [object_Arr release]; //add Vincent 内存释放
        if ([self.listArray count]!=0) {
            [carPoolingTableView reloadData];
        }else{
            [Global showMBProgressHudHint:self SuperView:self.view Msg:@"当前没有数据" ShowTime:1.0];
        }
        }else{
            if ([data objectForKey:@"errorMsg"]) {
                [Global showMBProgressHudHint:self SuperView:self.view Msg:[data objectForKey:@"errorMsg"] ShowTime:1.0];
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
