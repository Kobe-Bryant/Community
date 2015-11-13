//
//  SubwayBusViewController.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-7.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "SubwayBusViewController.h"
#import "NSObject_extra.h"
#import "Global.h"
#import "SubwayBuysTableViewSection.h"
#import "SubwayBusDetailViewController.h"
#import "CommonUtility.h"
#import "POIAnnotation.h"
#import "GeocodeAnnotation.h"
#import "SBJsonParser.h"
#import "BusDetailViewController.h"
#import "SubwayBusTableViewCell.h"
#import "UIViewController+NavigationBar.h"
#import "AppConfig.h"
#import "MobClick.h"

@interface SubwayBusViewController ()

@end

@implementation SubwayBusViewController
@synthesize search  = _search;
@synthesize subwayPoiPlaceSearch;
@synthesize buyPoiPlaceSearch;
@synthesize keyString;
@synthesize latitudeString;
@synthesize longitudeString;
@synthesize introduceInfo;

-(void)dealloc{
    self.search.delegate = nil;
    hudView = nil;
    [busTableView release]; busTableView = nil;
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
    [MobClick beginLogPageView:@"SubwayBusPage"]; // 友盟统计
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"SubwayBusPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:RGB(240, 240, 240)];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"附近公交地铁"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //    列表
    busTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth-20,MainHeight-10) style:UITableViewStylePlain];
    busTableView.delegate = self;
    busTableView.dataSource = self;
    busTableView.showsVerticalScrollIndicator = NO;
    busTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    busTableView.backgroundColor = [UIColor clearColor];
    busTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    [self.view addSubview:busTableView];
    
//    add vincent 2014.3.9
    [self hideHudView];
    hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];//       请求验证验证码是否正确
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [self initSearch];
    
    if (![userDefault objectForKey:GlobalCommunityLatitude]||![userDefault objectForKey:GlobalCommunityLongitude]) {
        
        //    反解析当前的地址
        [self searchGeocodeWithKey:[[self getCacheDataDictionaryString:GlobalCommunityAddress] objectForKey:@"address"]];

    }else{
        self.latitudeString = [userDefault objectForKey:GlobalCommunityLatitude];
        self.longitudeString = [userDefault objectForKey:GlobalCommunityLongitude];
        
        [self searchPoiByCenterCoordinate:@"公交站"];
    }
    
    // 启动分线程去加载 add vincent 这边有的异议
//    [NSThread detachNewThreadSelector:@selector(requestAddress) toTarget:self withObject:nil];
}

#pragma mark - Initialization

/* 初始化search. */
- (void)initSearch
{
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:nil];
    self.search.delegate = self;
}

//右边按钮
//-(void)rightBtnAction
//{
//
//}

//返回
-(void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requestAddress{
    if (request == nil) {
        request = [CommunityHttpRequest shareInstance];
    }
    NSString *string = [NSString stringWithFormat:@"?communityId=%d",1];//参数
    [request requestAddress:self parameters:string];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* 根据中心点坐标来搜周边的POI. */
- (void)searchPoiByCenterCoordinate:(NSString *)keywordString
{
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceAround;
    poiRequest.location = [AMapGeoPoint locationWithLatitude:[self.latitudeString floatValue] longitude:[self.longitudeString floatValue]];
    poiRequest.keywords = keywordString;
    poiRequest.sortrule = 1;
    poiRequest.city     = @[@"shenzhen"];
    poiRequest.offset = 20;
    self.keyString = keywordString;
    poiRequest.radius= 1000;
    [self.search AMapPlaceSearch:poiRequest];
    [poiRequest release];//add Vincent 内存释放
}

#pragma UITableViewDelegate
#pragma mark UITableViewDataSource implementation
#pragma mark Table View Data Source Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 20.0f;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result = 0;
    switch (section) {
        case 0:
            result = [self.subwayPoiPlaceSearch count];
            break;
        case 1:
            result = [self.buyPoiPlaceSearch count];
            break;
        default:
            break;
    }
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:
                 UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        cell.backgroundColor = RGB(240, 240, 240);
        UIImage *backImage = [UIImage imageNamed:@"bg_List1.png"];
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, backImage.size.width, backImage.size.height)];
        
        backImageView.image = backImage;

        [cell addSubview:backImageView];
        [backImageView release];
        
        
        UIImage *arrowImage= [UIImage imageNamed:@"arrow_right_icon.png"];
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(275, (backImage.size.height-arrowImage.size.height)/2, arrowImage.size.width, arrowImage.size.height)];
        arrowImageView.image = arrowImage;
        [backImageView addSubview:arrowImageView];
        [arrowImageView release];
        
        //图片icon
        UIImage *iconImage = [UIImage imageNamed:@"bg_buy1.png"];
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:
                                      CGRectMake(10,(68-iconImage.size.height)/2, iconImage.size.width, iconImage.size.height)];
        iconImageView.image = iconImage;
        iconImageView.tag = 2016;
        [cell addSubview:iconImageView];
        [iconImageView release];
        
        //名称
        UILabel *nameLabel = [[UILabel alloc ]  initWithFrame:
                              CGRectMake(iconImageView.frame.origin.x+iconImageView.frame.size.width+7, 12, 210, 23)];
        nameLabel.text = @"科苑站";
        nameLabel.tag = 2017;
        nameLabel.textColor=RGB(102, 102, 102);
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font=[UIFont systemFontOfSize:14];
        [cell addSubview:nameLabel];
        [nameLabel release];
        
        //站点名称
        UILabel *stationLabel = [[UILabel alloc ]  initWithFrame:
                                 CGRectMake(nameLabel.frame.origin.x,
                                            nameLabel.frame.origin.y+nameLabel.frame.size.height-1, 210, 20)];
        stationLabel.text = @"地铁2号线";
        stationLabel.tag = 2018;
        stationLabel.textColor=RGB(51, 51, 51);
        stationLabel.backgroundColor = [UIColor clearColor];
        stationLabel.font=[UIFont systemFontOfSize:14];
        [cell addSubview:stationLabel];
        [stationLabel release];
        
        //距离
        UILabel *distanceLabel = [[UILabel alloc ]  initWithFrame:
                                  CGRectMake(235,
                                             15.5, 60, 17)];
        distanceLabel.text = @"400 m";
        distanceLabel.tag = 2019;
        distanceLabel.textColor=RGB(153, 153, 153);
        distanceLabel.backgroundColor = [UIColor clearColor];
        distanceLabel.font=[UIFont systemFontOfSize:12];
        [cell addSubview:distanceLabel];
        [distanceLabel release];
    }
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    UIImageView *iconImageViewTag = (UIImageView *)[cell viewWithTag:2016];
    UILabel *nameLabelTag = (UILabel *)[cell viewWithTag:2017];
    UILabel *stationLabelTag = (UILabel *)[cell viewWithTag:2018];
    UILabel *distanceLabelTag = (UILabel *)[cell viewWithTag:2019];
    if (section == 0) {
        POIAnnotation *poiAnnotation =[self.subwayPoiPlaceSearch objectAtIndex:row];
        iconImageViewTag.image = [UIImage imageNamed:@"bg_subway1.png"];
        nameLabelTag.text = poiAnnotation.poi.name;
        stationLabelTag.text = poiAnnotation.poi.address;
        distanceLabelTag.text = [NSString stringWithFormat:@"%d m",poiAnnotation.poi.distance];
    }else{
        POIAnnotation *poiAnnotation =[self.buyPoiPlaceSearch objectAtIndex:row];
        iconImageViewTag.image = [UIImage imageNamed:@"bg_buy1.png"];
        NSArray *buyArray = [poiAnnotation.poi.name componentsSeparatedByString:@"("];
        nameLabelTag.text = [buyArray objectAtIndex:0];
        stationLabelTag.text = poiAnnotation.poi.address;
        distanceLabelTag.text = [NSString stringWithFormat:@"%d 米",poiAnnotation.poi.distance];
    }
    return cell;
}


#pragma mark -
#pragma mark Table Delegate Methods
//行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = [indexPath section];
    POIAnnotation *poiAnnotation;
    if (section == 0) {
        poiAnnotation =[self.subwayPoiPlaceSearch objectAtIndex:indexPath.row];
        
        SubwayBusDetailViewController *subwayBuyDetailVc = [[SubwayBusDetailViewController alloc] init];
        subwayBuyDetailVc.poi = poiAnnotation.poi;
        [self.navigationController pushViewController:subwayBuyDetailVc animated:YES];
        [subwayBuyDetailVc release];
    }else{
        poiAnnotation =[self.buyPoiPlaceSearch objectAtIndex:indexPath.row];
        BusDetailViewController *subwayBuyDetailVc = [[BusDetailViewController alloc] init];
        subwayBuyDetailVc.poi = poiAnnotation.poi;
        [self.navigationController pushViewController:subwayBuyDetailVc animated:YES];
        [subwayBuyDetailVc release];

    }
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SubwayBuysTableViewSection *headerView =  [[SubwayBuysTableViewSection alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 20.0f) section:section labelTitle:[tableView.dataSource tableView:tableView titleForHeaderInSection:section]];
    [headerView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    headerView.tag = section;
    return headerView;
}
#pragma mark UITableViewDelegate implementation
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"附近地铁站点";
        case 1:
            return @"附近公交站点";
        default:
            return nil;
    }
}

#pragma mark - AMapSearchDelegate
- (void)search:(id)searchRequest error:(NSString *)errInfo
{
    NSLog(@"%s: searchRequest = %@, errInfo= %@", __func__, [searchRequest class], errInfo);
    [self searchPoiByCenterCoordinate:@"公交站"];
}

/* 地理编码 搜索. */
- (void)searchGeocodeWithKey:(NSString *)key
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = key;
    
    [self.search AMapGeocodeSearch:geo];
    [geo release]; //add Vincent 内存释放
}

#pragma mark - AMapSearchDelegate

/* 地理编码回调.*/
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count == 0)
    {
        return;
    }
    NSMutableArray *geocodeAnnotationArray = [NSMutableArray array];
    [response.geocodes enumerateObjectsUsingBlock:^(AMapGeocode *obj, NSUInteger idx, BOOL *stop) {
        GeocodeAnnotation *geocodeAnnotation = [[GeocodeAnnotation alloc] initWithGeocode:obj];
        [geocodeAnnotationArray addObject:geocodeAnnotation];
        [geocodeAnnotation release];
    }];
    GeocodeAnnotation *annotation = [geocodeAnnotationArray objectAtIndex:0];
    self.latitudeString = [NSString stringWithFormat:@"%f",annotation.coordinate.latitude];
    self.longitudeString = [NSString stringWithFormat:@"%f",annotation.coordinate.longitude];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:self.latitudeString forKey:GlobalCommunityLatitude];
    [userDefault setObject:self.longitudeString forKey:GlobalCommunityLongitude];
    
    //中心点地铁和公交搜索
    [self searchPoiByCenterCoordinate:@"公交站"];
}


/* POI 搜索回调. */
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)respons
{
    
    if (respons.pois.count == 0)
    {
        return;
    }
    NSMutableArray *listArray = [NSMutableArray arrayWithCapacity:respons.pois.count];
    [respons.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        [listArray addObject:[[POIAnnotation alloc] initWithPOI:obj]];
        
    }];

    NSMutableArray *subWayListArray = [NSMutableArray array];
    NSMutableArray *busListArray = [NSMutableArray array];
    for (int i = 0; i<[listArray count]; i++) {
         POIAnnotation *poiAnnotation =[listArray objectAtIndex:i];
        NSRange range = [poiAnnotation.poi.name rangeOfString:@"(地铁站)"];
        if (range.location != NSNotFound)
        {   //包含
            [subWayListArray addObject:[listArray objectAtIndex:i]];
        }else if([poiAnnotation.poi.name rangeOfString:@"(公交站)"].location!=NSNotFound){
            [busListArray addObject:[listArray objectAtIndex:i]];
        }
    }
    
    self.subwayPoiPlaceSearch = subWayListArray;
    self.buyPoiPlaceSearch = busListArray;
    
    [self hideHudView];
    [busTableView reloadData];
}

#pragma mark ------ add vincent  地址回调
-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
        introduceInfo = [data retain];
        
        [self saveCacheUrlString:GlobalCommunityAddress andNSDictionary:introduceInfo];
        //    反解析当前的地址
        [self searchGeocodeWithKey:[introduceInfo objectForKey:@"address"]];
    }
}

- (void) hideHudView
{
    if (hudView) {
        [hudView hide:YES];
    }
}
@end
