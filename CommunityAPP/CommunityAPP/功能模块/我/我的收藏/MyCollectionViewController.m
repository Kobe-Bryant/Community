//
//  MyCollectionViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-13.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "MyCommentCell.h"
#import "CommunityHttpRequest.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"
#import "MyCollectionModel.h"
#import "MJRefresh.h"
#import "DetailLiveEncyclopediaViewController.h"
#import "SellingDetailViewController.h"
#import "CarPoolingDetailViewController.h"
#import "UIViewController+NavigationBar.h"
#import "MobClick.h"

@interface MyCollectionViewController (){
    MJRefreshFooterView *_footer;
}
@property (nonatomic, retain) CommunityHttpRequest *request;

@end

@implementation MyCollectionViewController
@synthesize request = _request;
@synthesize mycollectionArray = _mycollectionArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _mycollectionArray = [[NSMutableArray alloc]initWithCapacity:0];
      
    }
    return self;
}
- (void)dealloc
{    [_request cancelDelegate:self];
    [_mycollectionArray release]; _mycollectionArray = nil;
    [collectionTableView release]; collectionTableView = nil;
    [super dealloc];
}
-(void)viewWillAppear:(BOOL)animated
{
     [super viewWillAppear:animated];
    //加载网络数据
    [self hideHudView];
    hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];//  请求验证验证码是否正确
    
    //加载网络数据
    if (_request == nil) {
        _request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&lastId=%d",USER_ID,userModel.userId ,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,0];//参数
    [_request requestMyCollection:self parameters:parameters];
    
    [MobClick beginLogPageView:@"MyCollectionPage"]; // 友盟统计
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MyCollectionPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor whiteColor]];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"我的收藏"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //创建视图列表
    collectionTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, MainHeight) style:UITableViewStylePlain];
    collectionTableView.delegate = self;
    collectionTableView.dataSource = self;
    collectionTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    [self.view addSubview:collectionTableView];
    
}
#pragma mark ---refresh
- (void)addFooter
{
    __unsafe_unretained MyCollectionViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = collectionTableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //下拉刷新再次请求评论数据
        NSLog(@"%@",vc);
    };
    _footer = footer;
    
}
- (void)doneWithView//:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [collectionTableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [_footer endRefreshing];
}



#pragma mark ---uitableviewDataSorce
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_mycollectionArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCommentCell"];
    if (cell == nil) {
        cell = [[[MyCommentCell alloc] initWithStyle:
                 UITableViewCellStyleSubtitle reuseIdentifier:@"MyCommentCell"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    //网络数据设置
    MyCollectionModel *model = [_mycollectionArray objectAtIndex:indexPath.row];
    [cell.headerImg setImageWithURL:[NSURL URLWithString:model.mycollectionPublisherIcon] placeholderImage:[UIImage imageNamed:@"default_head.png"]];
    cell.nameLable.text = model.mycollectionPublisherNickName;
    cell.timeLable.text = model.mycollectionCreateTime;
    /* 2生活百科 3美食 4拼车上次班 5随手拍了卖
     */
    if ([model.mycollectionModuleId isEqualToString:@"2"]) {
        cell.nameLable.text = [NSString stringWithFormat:@"生活百科"];
       // cell.headerImg.image = [UIImage imageNamed:@"round_live.png"];
        cell.commentTypeImg.image = [UIImage imageNamed:@"small_live_more.png"];
    }else if([model.mycollectionModuleId isEqualToString:@"3"]){
        cell.commentTypeImg.image = [UIImage imageNamed:@"default_head.png"];
    }else if([model.mycollectionModuleId isEqualToString:@"4"]){
        cell.commentTypeImg.image = [UIImage imageNamed:@"small_neighbor_car_pic.png"];
    }else if([model.mycollectionModuleId isEqualToString:@"5"]){
        cell.commentTypeImg.image = [UIImage imageNamed:@"small_neighbor_photo_pic.png"];
    }

    //内容自适应高度
    //自适应
    CGFloat textHeight = [TQRichTextView getRechTextViewHeightWithText:model.mycollectionTitle viewWidth:250 font:[UIFont systemFontOfSize:14.0] lineSpacing:1.8];
    CGRect rect = cell.contentLable.frame;
    cell.contentLable.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width,MAX(textHeight+10, 44.0f));
    [cell.contentLable setText:model.mycollectionTitle];
    [cell.timeLable setFrame:CGRectMake(195, cell.contentLable.frame.size.height+cell.contentLable.frame.origin.y, 120, 20)];
    UITapGestureRecognizer *labTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lableTap:)];
    cell.contentLable.tag = indexPath.row;
    [cell.contentLable addGestureRecognizer:labTap];
    [labTap release];
    return cell;
}
#pragma mark -- uitableviewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionModel *model = ([self.mycollectionArray  count]>indexPath.row)?[self.mycollectionArray objectAtIndex:indexPath.row]:nil;
    
    NSString *strRemark = model.mycollectionTitle;
    
    //逻辑判断高度
    CGFloat textHeight = [TQRichTextView getRechTextViewHeightWithText:strRemark viewWidth:250 font:[UIFont systemFontOfSize:14.0] lineSpacing:1.8];
    
    CGFloat height = MAX(textHeight+10, 44.0f);
    
    return height+70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //网络数据设置
    MyCollectionModel *model = [self.mycollectionArray objectAtIndex:indexPath.row];
    /* 2生活百科 3美食 4拼车上次班 5随手拍了卖
     */
    if ([model.mycollectionModuleId isEqualToString:@"2"]) {
        DetailLiveEncyclopediaViewController *live = [[DetailLiveEncyclopediaViewController alloc]init];
        live.type = CMLIVEPEDIA;
        live.baseId = [NSString stringWithFormat:@"%d",model.mycollectionDetailsId];
        [self.navigationController pushViewController:live animated:YES];
        [live release];
      
    }else if([model.mycollectionModuleId isEqualToString:@"3"]){
        
    }else if([model.mycollectionModuleId isEqualToString:@"4"]){
        CarPoolingDetailViewController *car = [[CarPoolingDetailViewController alloc]init];
        car.type = CMSHARECAR;
        car.baseId = [NSString stringWithFormat:@"%d",model.mycollectionDetailsId];
        [self.navigationController pushViewController:car animated:YES];
        [car release];
    }else if([model.mycollectionModuleId isEqualToString:@"5"]){
        SellingDetailViewController *sell = [[SellingDetailViewController alloc]init];
        sell.entryType = CMEntryPush;
        sell.type = CMAUCTION;
        sell.baseId = [NSString stringWithFormat:@"%d",model.mycollectionDetailsId];
        [self.navigationController pushViewController:sell animated:YES];
        [sell release];
      
    }

}

//导航栏左按钮
-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------
-(void) callBackWith: (WInterface) interface status: (RESPONSE_CODE) status data:(id) data{
    [self.mycollectionArray removeAllObjects];
    NSString *code = [data objectForKey:ERROR_CODE];
    if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]){
        [self hideHudView];
        NSArray *array = [data objectForKey:@"myCollects"];
        for (NSDictionary *dic in array) {
            MyCollectionModel *model = [[[MyCollectionModel alloc]init] autorelease];
            model.mycollectionId = [[dic objectForKey:@"id"] integerValue];
            model.mycollectionPublisherId = [dic objectForKey:@"publisherId"];
            model.mycollectionPublisherIcon = [dic objectForKey:@"publisherIcon"];
            model.mycollectionPublisherNickName = [dic objectForKey:@"publisherNickName"];
            model.mycollectionModuleId = [dic objectForKey:@"moduleId"];
            model.mycollectionModuleType = [dic objectForKey:@"moduleType"];
            model.mycollectionDetailsId = [[dic objectForKey:@"detailsId"] integerValue];
            model.mycollectionTitle = [dic objectForKey:@"title"];
            model.mycollectionCreateTime = [dic objectForKey:@"createTime"];
            [self.mycollectionArray addObject:model];
        }
        if ([self.mycollectionArray count]==0) {
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
    }else{
        NSLog(@"获取网络数据失败");
    }
    [collectionTableView reloadData];
}

-(void)lableTap:(UITapGestureRecognizer *)sender{
    NSLog(@"sender = %d",sender.view.tag);
    //网络数据设置
    MyCollectionModel *model = [self.mycollectionArray objectAtIndex:sender.view.tag];
    /* 2生活百科 3美食 4拼车上次班 5随手拍了卖
     */
    if ([model.mycollectionModuleId isEqualToString:@"2"]) {
        DetailLiveEncyclopediaViewController *live = [[DetailLiveEncyclopediaViewController alloc]init];
        live.type = CMLIVEPEDIA;
        live.baseId = [NSString stringWithFormat:@"%d",model.mycollectionDetailsId];
        [self.navigationController pushViewController:live animated:YES];
        [live release];
        
    }else if([model.mycollectionModuleId isEqualToString:@"3"]){
        
    }else if([model.mycollectionModuleId isEqualToString:@"4"]){
        CarPoolingDetailViewController *car = [[CarPoolingDetailViewController alloc]init];
        car.type = CMSHARECAR;
        car.baseId = [NSString stringWithFormat:@"%d",model.mycollectionDetailsId];
        [self.navigationController pushViewController:car animated:YES];
        [car release];
    }else if([model.mycollectionModuleId isEqualToString:@"5"]){
        SellingDetailViewController *sell = [[SellingDetailViewController alloc]init];
        sell.entryType = CMEntryPush;
        sell.type = CMAUCTION;
        sell.baseId = [NSString stringWithFormat:@"%d",model.mycollectionDetailsId];
        [self.navigationController pushViewController:sell animated:YES];
        [sell release];
        
    }
}

- (void) hideHudView
{
    if (hudView) {
        [hudView hide:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
