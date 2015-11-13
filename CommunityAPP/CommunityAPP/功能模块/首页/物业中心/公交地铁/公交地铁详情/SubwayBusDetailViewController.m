//
//  SubwayBusDetailViewController.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-7.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "SubwayBusDetailViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "CommonUtility.h"
#import "BusStopAnnotation.h"
#import "SubWayBusMapShowViewController.h"
#import "SubwayBusMapLineViewController.h"
#import "UIViewController+NavigationBar.h"
#import "MobClick.h"

@interface SubwayBusDetailViewController ()

@end

@implementation SubwayBusDetailViewController
@synthesize poi;
@synthesize search  = _search;
@synthesize busLines = _busLines;

-(void)dealloc{
     self.search.delegate = nil;
    [subwayBusDetailTableView release]; subwayBusDetailTableView = nil;
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
    [MobClick beginLogPageView:@"SubwayBusDetailPage"]; // 友盟统计
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"SubwayBusDetailPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:RGB(240, 240, 240)];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"站点信息"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //    站点信息
    UIImage *stationImage = [UIImage imageNamed:@"bg_information_border1.png"];
    UIImageView *stationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    stationImageView.image = stationImage;
    stationImageView.userInteractionEnabled = YES;
    [self.view addSubview:stationImageView];
    [stationImageView release];
    
    //   按钮
    UIButton *stationBtn = [self newButtonWithImage:nil highlightedImage:nil frame:stationImageView.frame title:nil titleColor:nil titleShadowColor:nil font:nil target:self action:@selector(stationImageViewBtn)];
    [self.view  addSubview:stationBtn];
    
//  剪头
    UIImage *arrowImage = [UIImage imageNamed:@"arrow_right_icon.png"];
    UIImageView *arrowImageView = [self newImageViewWithImage:arrowImage frame:CGRectMake(285, (80-arrowImage.size.height)/2, arrowImage.size.width, arrowImage.size.height)];
    arrowImageView.image = arrowImage;
    [stationImageView addSubview:arrowImageView];
    [arrowImageView release];
    
    //名称
    UILabel *nameLabel = [[UILabel alloc ]  initWithFrame:
                          CGRectMake(16, 16, 210, 23)];
    nameLabel.text = [[poi.name componentsSeparatedByString:@"("] objectAtIndex:0];
    nameLabel.textColor=RGB(51, 51, 51);
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font=[UIFont systemFontOfSize:17];
    [stationImageView addSubview:nameLabel];
    [nameLabel release];
    
    //距离
    UILabel *distanceLabel = [[UILabel alloc ]  initWithFrame:
                              CGRectMake(nameLabel.frame.origin.x,
                                         nameLabel.frame.origin.y+nameLabel.frame.size.height+10, 60, 13)];
    distanceLabel.text = [NSString stringWithFormat:@"%d m",poi.distance];
    distanceLabel.textColor=RGB(102, 102, 102);
    distanceLabel.backgroundColor = [UIColor clearColor];
    distanceLabel.font=[UIFont systemFontOfSize:13];
    [stationImageView addSubview:distanceLabel];
    [distanceLabel release];
    
    //    列表
    subwayBusDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, stationImageView.frame.size.height+stationImageView.frame.origin.y+10, ScreenWidth-20,MainHeight-stationImageView.frame.size.height-stationImageView.frame.origin.y-10) style:UITableViewStylePlain];
    subwayBusDetailTableView.delegate = self;
    subwayBusDetailTableView.dataSource = self;
    subwayBusDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    subwayBusDetailTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    subwayBusDetailTableView.backgroundColor = RGB(240, 240, 240);
    [self.view addSubview:subwayBusDetailTableView];
    
    [self hideHudView];
    hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];//       请求验证验证码是否正确
    [self initSearch];
//    搜索当前的线路
    [self searchLineByKey:poi.address];
}

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

//站点详情
-(void)stationImageViewBtn{
    NSLog(@"stationImageViewBtn");
    SubWayBusMapShowViewController *showmapVC = [[SubWayBusMapShowViewController alloc] init];
    showmapVC.poi = poi;
    [self.navigationController pushViewController:showmapVC animated:YES];
    [showmapVC release];
}
/* 根据key搜索公交路线. */
- (void)searchLineByKey:(NSString *)key
{
    if (key.length == 0)
    {
        return;
    }
     NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    AMapBusLineSearchRequest *line = [[AMapBusLineSearchRequest alloc] init];
    NSString *keyString = [key stringByReplacingOccurrencesOfString:@";" withString:@"|"];
    line.keywords           = keyString;
    NSLog(@"line.keywords %@",line.keywords);
    line.city               = @[[[userDefault objectForKey:GlobalCommunityAddress] objectForKey:@"city"]];
    line.requireExtension   = YES;
    line.offset = 20;
    [self.search AMapBusLineSearch:line];
    [line release];//add vincent 内存释放
}
//返回
-(void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.busLines count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:
                 UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//        cell.backgroundView = [[[UIImageView alloc] initWithImage:
//                                [UIImage imageNamed:@"bg_List.png"]] autorelease];
//        cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:
//                                        [UIImage imageNamed:@"bg_List_over.png"]] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = RGB(240, 240, 240);
        
        UIImage *backImage = [UIImage imageNamed:@"bg_List2.png"];
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, backImage.size.width, 98)];
        backImageView.image = backImage;
        [cell addSubview:backImageView];
        [backImageView release];
        
//        UIImage *arrowImage= [UIImage imageNamed:@"bg_arrow.png"];
//        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(275, (76-arrowImage.size.height)/2, arrowImage.size.width, arrowImage.size.height)];
//        arrowImageView.image = arrowImage;
//        [backImageView addSubview:arrowImageView];
//        [arrowImageView release];
        
        //图片icon
        UIImage *iconImage = [UIImage imageNamed:@"bg_buy1.png"];
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:
                                      CGRectMake(10,11, iconImage.size.width, iconImage.size.height)];
        iconImageView.image = iconImage;
        iconImageView.tag = 2016;
        [cell addSubview:iconImageView];
        [iconImageView release];
        
        //名称
        UILabel *nameLabel = [[UILabel alloc ]  initWithFrame:
                              CGRectMake(iconImageView.frame.origin.x+iconImageView.frame.size.width+8, 14, 210, 23)];
        nameLabel.text = @"地铁2号线［蛇口线］";
        nameLabel.tag = 2017;
        nameLabel.textColor=RGB(51, 51, 51);
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font=[UIFont systemFontOfSize:15];
        [cell addSubview:nameLabel];
        [nameLabel release];
        
        UIImage *arrowImage= [UIImage imageNamed:@"arrow_right_icon.png"];
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(275, 20, arrowImage.size.width, arrowImage.size.height)];
        arrowImageView.image = arrowImage;
        [cell addSubview:arrowImageView];
        [arrowImageView release];
        
        //起始站 终点站
        UILabel *fromToStationLabel = [[UILabel alloc ]  initWithFrame:
                                 CGRectMake(iconImageView.frame.origin.x+6,
                                            iconImageView.frame.origin.y+iconImageView.frame.size.height+6, 150, 15)];
        fromToStationLabel.text = @"科学馆－科学馆";
        fromToStationLabel.tag = 2018;
        fromToStationLabel.textColor=RGB(102, 102, 102);
        fromToStationLabel.backgroundColor = [UIColor clearColor];
        fromToStationLabel.font=[UIFont systemFontOfSize:13];
        [cell addSubview:fromToStationLabel];
        [fromToStationLabel release];
        
        //终点站 起始站
        UILabel *toStationLabel = [[UILabel alloc ]  initWithFrame:
                                       CGRectMake(fromToStationLabel.frame.origin.x,
                                                  fromToStationLabel.frame.origin.y+fromToStationLabel.frame.size.height+6, 150, 15)];
        toStationLabel.text = @"科学馆－科学馆";
        toStationLabel.tag = 2019;
        toStationLabel.textColor=RGB(102, 102, 102);
        toStationLabel.backgroundColor = [UIColor clearColor];
        toStationLabel.font=[UIFont systemFontOfSize:13];
        [cell addSubview:toStationLabel];
        [toStationLabel release];
        
//        首发
        UIImage *firstStationImage = [UIImage imageNamed:@"bg_first_station.png"];
        UIImageView *firstStationImageView = [self newImageViewWithImage:firstStationImage frame:CGRectMake(170, fromToStationLabel.frame.origin.y, firstStationImage.size.height, firstStationImage.size.width)];
        firstStationImageView.image = firstStationImage;
        [cell addSubview:firstStationImageView];
        [firstStationImageView release];
        
        //时间
        UILabel *firstTimeLabel = [[UILabel alloc ]  initWithFrame:
                                  CGRectMake(firstStationImageView.frame.size.width+firstStationImageView.frame.origin.x+4,
                                             firstStationImageView.frame.origin.y-1, 44, 17)];
        firstTimeLabel.text = @"06:30";
        firstTimeLabel.tag = 2020;
        firstTimeLabel.textColor=RGB(153, 153, 153);
        firstTimeLabel.backgroundColor = [UIColor clearColor];
        firstTimeLabel.font=[UIFont systemFontOfSize:14];
        [cell addSubview:firstTimeLabel];
        [firstTimeLabel release];
        
//        到达
        UIImage *endStationImage = [UIImage imageNamed:@"bg_last_station.png"];
        UIImageView *endStationImageView = [self newImageViewWithImage:firstStationImage frame:CGRectMake(firstTimeLabel.frame.size.width+firstTimeLabel.frame.origin.x, fromToStationLabel.frame.origin.y, firstStationImage.size.height, firstStationImage.size.width)];
        endStationImageView.image = endStationImage;
        [cell addSubview:endStationImageView];
        [endStationImageView release];
        
        UILabel *endTimeLabel = [[UILabel alloc ]  initWithFrame:
                                   CGRectMake(endStationImageView.frame.size.width+endStationImageView.frame.origin.x+4,
                                              firstTimeLabel.frame.origin.y, 44, 17)];
        endTimeLabel.text = @"12:30";
        endTimeLabel.tag = 2021;
        endTimeLabel.textColor=RGB(153, 153, 153);
        endTimeLabel.backgroundColor = [UIColor clearColor];
        endTimeLabel.font=[UIFont systemFontOfSize:14];
        [cell addSubview:endTimeLabel];
        [endTimeLabel release];
        
        //        首发
        UIImageView *nestfirstStationImageView = [self newImageViewWithImage:firstStationImage frame:CGRectMake(firstStationImageView.frame.origin.x, firstStationImageView.frame.origin.y+firstStationImageView.frame.size.height+6, firstStationImage.size.height, firstStationImage.size.width)];
        nestfirstStationImageView.image = firstStationImage;
        [cell addSubview:nestfirstStationImageView];
        [nestfirstStationImageView release];
        
        //时间
        UILabel *nestFirstTimeLabel = [[UILabel alloc ]  initWithFrame:
                                   CGRectMake(nestfirstStationImageView.frame.size.width+nestfirstStationImageView.frame.origin.x+4,
                                              nestfirstStationImageView.frame.origin.y-1,44, 17)];
        nestFirstTimeLabel.text = @"06:30";
        nestFirstTimeLabel.tag = 2022;
        nestFirstTimeLabel.textColor=[UIColor grayColor];
        nestFirstTimeLabel.backgroundColor = [UIColor clearColor];
        nestFirstTimeLabel.font=[UIFont systemFontOfSize:14];
        [cell addSubview:nestFirstTimeLabel];
        [nestFirstTimeLabel release];
        
        //        到达
        UIImageView *nestEndStationImageView = [self newImageViewWithImage:firstStationImage frame:CGRectMake(nestFirstTimeLabel.frame.size.width+nestFirstTimeLabel.frame.origin.x, nestfirstStationImageView.frame.origin.y, firstStationImage.size.height, firstStationImage.size.width)];
        nestEndStationImageView.image = endStationImage;
        [cell addSubview:nestEndStationImageView];
        [nestEndStationImageView release];
        
        UILabel *nestEndTimeLabel = [[UILabel alloc ]  initWithFrame:
                                 CGRectMake(nestEndStationImageView.frame.size.width+nestEndStationImageView.frame.origin.x+4,
                                            nestfirstStationImageView.frame.origin.y, 44, 17)];
        nestEndTimeLabel.text = @"12:30";
        nestEndTimeLabel.tag = 2023;
        nestEndTimeLabel.textColor=[UIColor grayColor];
        nestEndTimeLabel.backgroundColor = [UIColor clearColor];
        nestEndTimeLabel.font=[UIFont systemFontOfSize:14];
        [cell addSubview:nestEndTimeLabel];
        [nestEndTimeLabel release];
    }
    AMapBusLine *busLine = [self.busLines objectAtIndex:indexPath.row];
    UIImageView *iconImageViewTag = (UIImageView *)[cell viewWithTag:2016];
    UILabel *nameLabelTag = (UILabel *)[cell viewWithTag:2017];
    UILabel *fromToStationLabelTag = (UILabel *)[cell viewWithTag:2018];
    UILabel *toStationLabelTag = (UILabel *)[cell viewWithTag:2019];
    UILabel *firstTimeLabelTag = (UILabel *)[cell viewWithTag:2020];
    UILabel *endTimeLabelTag = (UILabel *)[cell viewWithTag:2021];
    UILabel *nestFirstTimeLabelTag = (UILabel *)[cell viewWithTag:2022];
    UILabel *nestEndTimeLabelTag = (UILabel *)[cell viewWithTag:2023];
    
    iconImageViewTag.image = [UIImage imageNamed:@"bg_subway1.png"];
//    NSArray *buyArray = [busLine.name componentsSeparatedByString:@"("];
    nameLabelTag.text = busLine.name;//[buyArray objectAtIndex:0];
    fromToStationLabelTag.text = [NSString stringWithFormat:@"%@-%@",busLine.startStop.name,busLine.endStop.name];
    toStationLabelTag.text = [NSString stringWithFormat:@"%@-%@",busLine.endStop.name,busLine.startStop.name];
    
    if ([busLine.startTime length]!=0) {
        NSMutableString *startTimeString = [NSMutableString stringWithString:busLine.startTime];
        [startTimeString insertString:@":" atIndex:2];
        firstTimeLabelTag.text = startTimeString;
        nestEndTimeLabelTag.text = startTimeString;
    }else{
        firstTimeLabelTag.text = @"";
        nestEndTimeLabelTag.text = @"";
    }
    if ([busLine.endTime length]!=0) {
        NSMutableString *endTimeString = [NSMutableString stringWithString:busLine.endTime];
        [endTimeString insertString:@":" atIndex:2];
        
        endTimeLabelTag.text = endTimeString;
        nestFirstTimeLabelTag.text = endTimeString;
    }else{
        endTimeLabelTag.text = @"";
        nestFirstTimeLabelTag.text = @"";
    }
    
    return cell;
}


#pragma mark -
#pragma mark Table Delegate Methods
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellAccessoryNone;
}
//行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AMapBusLine *busLine = [self.busLines objectAtIndex:indexPath.row];

    SubwayBusMapLineViewController *busMapLine = [[SubwayBusMapLineViewController alloc] init];
    busMapLine.mapBusLine = busLine;
    busMapLine.poi = poi;
    [self.navigationController pushViewController:busMapLine animated:YES];
    [busMapLine release];
}
#pragma mark - AMapSearchDelegate

/* 路线回调*/
- (void)onBusLineSearchDone:(AMapBusLineSearchRequest *)request response:(AMapBusLineSearchResponse *)response
{
    self.busLines = [NSMutableArray array];
//    [self.busLines setArray:response.buslines];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (int i= 0;i<[response.buslines count];i++) {
        AMapBusLine *busLine = [response.buslines objectAtIndex:i];
        NSLog(@"busLine.name %@",busLine.name);
        NSArray *keyArray = [poi.address componentsSeparatedByString:@";"];
        for (int j = 0; j<[keyArray count]; j++) {
            NSRange range = [busLine.name rangeOfString:[NSString stringWithFormat:@"%@",[keyArray objectAtIndex:j]]];//判断字符串是否包含
          if (range.length >0)//包含
            {
                busLine.name = [keyArray objectAtIndex:j];
                [dict setObject:busLine forKey:[keyArray objectAtIndex:j]];
            }
        }
//        NSArray *buyArray = [busLine.name componentsSeparatedByString:@"("];
//        [dict setObject:busLine forKey:[buyArray objectAtIndex:0]];
    }
    [self.busLines setArray:[dict allValues]];
    
    [self hideHudView];
    [subwayBusDetailTableView reloadData];
}

- (void) hideHudView
{
    if (hudView) {
        [hudView hide:YES];
    }
}

@end
