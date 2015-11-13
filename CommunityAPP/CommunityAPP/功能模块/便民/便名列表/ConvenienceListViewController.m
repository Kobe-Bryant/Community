//
//  ConvenienceListViewController.m
//  CommunityAPP
//
//  Created by yunlai on 14-4-3.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "ConvenienceListViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "AppDelegate.h"
#import "ConvenienceTableViewCell.h"
#import "ConvenienceDetailViewController.h"
#import "ConvenienceListData.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "UIViewController+NavigationBar.h"
#import "JSONKit.h"
#import "MobClick.h"

@interface ConvenienceListViewController ()

@end

@implementation ConvenienceListViewController
@synthesize searchTextString;
@synthesize listDataArray;
@synthesize disArray;
@synthesize currentPage;

-(void)dealloc{
    [_footer free];
    listTableView.dataSource = nil; listTableView.delegate = nil;
    [listTableView release]; listTableView = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ConvenienceListPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ConvenienceListPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:self.searchTextString];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    self.disArray = [NSArray arrayWithObjects:@"500",@"1000",@"2000", @"5000",nil];
    UIImage *disImage = [UIImage imageNamed:@"bg_convenience_unSelected.png"];
    UIImage *lineImage = [UIImage imageNamed:@"bg_convenience_list_line.png"];
    UIButton *allDisBtn;
    UILabel *disLabel;
    for (int i = 0; i<[disArray count]; i++) {
        allDisBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        allDisBtn.frame = CGRectMake(10+70*i+23*i,10,disImage.size.width, disImage.size.height);
        [allDisBtn setImage:[UIImage imageNamed:@"bg_convenience_unSelected.png"] forState:UIControlStateNormal];
        [allDisBtn setImage:[UIImage imageNamed:@"bg_convenience_selected.png"] forState:UIControlStateHighlighted];
        [allDisBtn setImage:[UIImage imageNamed:@"bg_convenience_selected.png"] forState:UIControlStateSelected];
        allDisBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [allDisBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [allDisBtn setBackgroundColor:[UIColor clearColor]];
        allDisBtn.tag = i;
        [allDisBtn addTarget:self action:@selector(allDisBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:allDisBtn];
        
        disLabel = [[UILabel alloc ]  initWithFrame:
                                       CGRectMake(70*i+23*i-3,
                                                  allDisBtn.frame.origin.y+allDisBtn.frame.size.height, 50, 17)];
        disLabel.text = [NSString stringWithFormat:@"%@m",[disArray objectAtIndex:i]];
        disLabel.textColor = RGB(141, 141, 141);
        disLabel.textAlignment = NSTextAlignmentCenter;
        disLabel.font=[UIFont systemFontOfSize:11];
        [self.view addSubview:disLabel];
        [disLabel release];
        
        if (i<3) {
            UIImageView *lineImageView = [self newImageViewWithImage:lineImage frame:CGRectMake(10+70*i+23*(i+1), allDisBtn.frame.origin.y+allDisBtn.frame.size.height-12, 70, 2)];
            [self.view addSubview:lineImageView];
            [lineImageView release];
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, disLabel.frame.size.height+disLabel.frame.origin.y-1, ScreenWidth, 1)];
        lineView.backgroundColor = RGB(224, 224, 224);
        [self.view addSubview:lineView];
        [lineView release];
    }
    
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, disLabel.frame.size.height+disLabel.frame.origin.y, ScreenWidth, MainHeight-disLabel.frame.size.height-disLabel.frame.origin.y) style:UITableViewStylePlain];
    listTableView.backgroundColor = [UIColor clearColor];
    listTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    listTableView.delegate = self;
    listTableView.dataSource = self;
    [self.view addSubview:listTableView];
    
    [self addFooter];
    
    currnetInt = 2;
    currentPage = 1;//默认当前位第一页
    self.listDataArray = [[NSMutableArray alloc] init];
    
    [self requestData];
    [self setBtnSelected:currnetInt];
    
    //    大众点评的logo
    UIImage *apiImage = [UIImage imageNamed:@"bg_dpApi_logo.png"];
    UIImageView *apiImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-apiImage.size.width-10, MainHeight-10-apiImage.size.height, apiImage.size.width, apiImage.size.height)];
    [apiImageView setImage:apiImage];
    [self.view addSubview:apiImageView];
    [self.view insertSubview:apiImageView aboveSubview:listTableView];
    [apiImageView release];
    
}

#pragma mark ---refresh
-(void)addFooter{
    //_unsafe_unretained
    ConvenienceListViewController *vc = self;
    MJRefreshFooterView *footerView = [MJRefreshFooterView footer];
    footerView.scrollView = listTableView;
    footerView.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [vc performSelector:@selector(beginWithView:) withObject:refreshView afterDelay:0.3];
    };
    footerView.endStateChangeBlock = ^(MJRefreshBaseView *refreshView){
        //[vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:0.3];
        [vc doneWithView:refreshView];
    };
    self.footer = footerView;

}

- (void)beginWithView:(MJRefreshBaseView *)refreshView{
    // 刷新表格
    currentPage++;
    [self conveniencListRequest];
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    //    [listTableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [listTableView reloadData];
}

-(void)requestData{
    [self hideHudView];
    
    hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];
    //    请求当前的数据
    [self conveniencListRequest];
}

-(void)conveniencListRequest{
    [[AppDelegate instance] setAppKey:kDPAppKey];
	[[AppDelegate instance] setAppSecret:kDPAppSecret];

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];

    NSString *params = [NSString stringWithFormat:@"city=%@&latitude=%@&longitude=%@&category=%@&radius=%@&sort=7&limit=10&platform=2&page=%@",[[userDefault objectForKey:GlobalCommunityAddress] objectForKey:@"city"],[userDefault objectForKey:GlobalCommunityLatitude],[userDefault objectForKey:GlobalCommunityLongitude],self.searchTextString,[NSString stringWithFormat:@"%@",[disArray objectAtIndex:currnetInt]],[NSString stringWithFormat:@"%d",currentPage]];//参数
    NSLog(@"params %@",params);
    [[[AppDelegate instance] dpapi] requestWithURL:DZDP_FIND_BUSINESSES paramsString:params delegate:self];
}

//导航栏左按钮
-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)allDisBtnAction:(id)sender{
    currentPage = 1;//默认当前位第一页
    [self.listDataArray removeAllObjects];
    [listTableView reloadData];
    self.listDataArray = [[NSMutableArray alloc] init];
    [_footer setHidden:YES];
    
    UIButton *button = (UIButton *)sender;
    currnetInt = button.tag;
    [self setSelectedIndex:button.tag];
    [self requestData];
}
- (void) setSelectedIndex:(NSUInteger)selectedIndex {
    [self setBtnSelected:selectedIndex];
}
- (void)setBtnSelected:(NSInteger)tag {
    for(UIView *v in self.view.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            if (((UIButton *)v).tag == tag){
                [(UIButton *)v setSelected:YES];
            }
            else
                [(UIButton *)v setSelected:NO];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma UITableViewDelegate
#pragma mark UITableViewDataSource implementation
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify = @"ConvenienceListViewController";
    ConvenienceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[ConvenienceTableViewCell alloc] initWithStyle:
                 UITableViewCellStyleSubtitle reuseIdentifier:identify] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
//        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
//        cell.selectedBackgroundView.backgroundColor = RGB(1, 1, 1);
    }
    ConvenienceListData *listData = [self.listDataArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = listData.nameString;
    [cell.iconImageView setImageWithURL:[NSURL URLWithString:listData.s_photo_urlString] placeholderImage:[UIImage imageNamed:@"bg_sample_6.png"]];
    if ([listData.categoriesArray count]==0) {
        cell.addressLabel.text = [NSString stringWithFormat:@"%@   %@",[listData.regionsArray lastObject],@""];

    }else{
        cell.addressLabel.text = [NSString stringWithFormat:@"%@   %@",[listData.regionsArray lastObject],[listData.categoriesArray lastObject]];
    }
    cell.disLabel.text = [NSString stringWithFormat:@"%@ m",listData.distanceString];
    
    int grade = [listData.avg_ratingString intValue];
    UIImage *starImage = [UIImage imageNamed:@"bg_convenience_normalStar.png"];
    for (int i=0; i<5; i++) {
        UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14*i+cell.titleLabel.frame.origin.x, cell.addressLabel.frame.size.height+cell.addressLabel.frame.origin.y+9, starImage.size.width, starImage.size.height)];
        if (i<=(grade-1)) {
            [starImageView setImage:[UIImage imageNamed:@"bg_convenience_highStar.png"]];
        }else{
            [starImageView setImage:[UIImage imageNamed:@"bg_convenience_normalStar.png"]];
        }
        [cell addSubview:starImageView];
    }

    return cell;
}

#pragma mark UITableViewDelegate implementation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ConvenienceListData *listData = [self.listDataArray objectAtIndex:indexPath.row];
    ConvenienceDetailViewController *detailVc = [[ConvenienceDetailViewController alloc] init];
    detailVc.listData = listData;
    [self.navigationController pushViewController:detailVc animated:YES];
    [detailVc release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94.0;
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    [self hideHudView];
    NSDictionary *dictionary = [[error description] objectFromJSONString];
    [self alertWithFistButton:@"确定" SencodButton:nil Message:[dictionary objectForKey:@"status"]];
    NSLog(@"[error description] %@",[error description]);
}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    [self hideHudView];
    
    [result description];
    if ([[result objectForKey:@"businesses"] count]==0) {
        [_footer endRefreshing];
        [Global showMBProgressHudHint:self SuperView:self.view Msg:@"当前没有数据" ShowTime:1.0];
    }else{
        NSArray *listArray = [result objectForKey:@"businesses"];
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *tempDic in listArray) {
            ConvenienceListData *listData = [[ConvenienceListData alloc]init];
            listData.businessIdString = [tempDic objectForKey:@"business_id"];
            listData.nameString = [tempDic objectForKey:@"name"];
            listData.addressString = [tempDic objectForKey:@"address"];
            listData.telephoneString = [tempDic objectForKey:@"telephone"];
            listData.cityString = [tempDic objectForKey:@"city"];
            listData.categoriesArray = [tempDic objectForKey:@"categories"];
            listData.latitudeString = [tempDic objectForKey:@"latitude"];
            listData.longitudeString = [tempDic objectForKey:@"longitude"];
            listData.avg_ratingString = [tempDic objectForKey:@"avg_rating"];
            listData.distanceString = [tempDic objectForKey:@"distance"];
            listData.s_photo_urlString = [tempDic objectForKey:@"s_photo_url"];
            listData.regionsArray = [tempDic objectForKey:@"regions"];
            listData.business_urlString = [tempDic objectForKey:@"business_url"];
            [tempArray addObject:listData];
            [listData release];
        }
        [self.listDataArray addObjectsFromArray:tempArray];
        [tempArray release]; //add vincent  内存释放
        
        //停止下拉刷新
        if ([_footer isRefreshing]) {
            [_footer endRefreshing];
        }else{
            [listTableView reloadData];
        }
    }
    NSLog(@"self.listDataArray  %@",self.listDataArray );
}

- (void) hideHudView
{
    if (hudView) {
        [hudView hide:YES];
    }
}
@end
