//
//  SubwayBusMapLineViewController.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-10.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "SubwayBusMapLineViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "CommonUtility.h"
#import "BusStopAnnotation.h"
#import "CusAnnotationView.h"
#import "UIViewController+NavigationBar.h"
#import "MobClick.h"

#define kMapCoreAnimationDuration 2.f

@interface SubwayBusMapLineViewController ()

@end

@implementation SubwayBusMapLineViewController
@synthesize maMapView;
@synthesize search;
@synthesize mapBusLine;
@synthesize busStopAnnotations;
@synthesize poi;

-(void)dealloc{
    [maMapView release];  maMapView.delegate = nil;     maMapView = nil;
    self.search.delegate = nil;     self.search = nil; [self.search release];
    [self.busStopAnnotations release]; self.busStopAnnotations = nil;
    [btnScrollView release]; btnScrollView = nil;
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
    [MobClick beginLogPageView:@"SubwayBusMapLinePage"]; // 友盟统计
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"SubwayBusMapLinePage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"地图"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    [self initMapView];

    [self initSearch];
    
//    展示当前的地图信息
    [self presentMapBusLine];
    
    [self loadBusStationView];
}

-(void)loadBusStationView{
    UIImage *unSelectedImage = [UIImage imageNamed:@"bg_station_unSelected.png"];
    //构建滚动视图
    NSInteger stateBarHeight;
    if (IOS6_OR_LATER) {
        stateBarHeight = 0;
    }else{
        stateBarHeight = 20;
    }
    btnScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, ScreenHeight-unSelectedImage.size.height-NavigationBarHeight -stateBarHeight, 320,unSelectedImage.size.height)] ;
    btnScrollView.showsHorizontalScrollIndicator = NO;
    btnScrollView.showsVerticalScrollIndicator = NO;
    btnScrollView.bounces  = NO;
    btnScrollView.scrollsToTop = NO;
    [btnScrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:btnScrollView];
    
    for (int i=0;i<[mapBusLine.busStops count];i++) {
        AMapBusLine *busLine = [mapBusLine.busStops objectAtIndex:i];
        
//        UIImage *unSelectedImage = [UIImage imageNamed:@"bg_station_unSelected.png"];
        UIImageView *unSelectedImageView = [[UIImageView alloc] initWithImage:unSelectedImage highlightedImage:[UIImage imageNamed:@"bg_station_selected.png"]];
        unSelectedImageView.userInteractionEnabled = YES;
        unSelectedImageView.tag = i;
        [unSelectedImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)]];
        unSelectedImageView.frame = CGRectMake(34*i, 5, unSelectedImage.size.width, unSelectedImage.size.height);
        [btnScrollView addSubview:unSelectedImageView];
        [unSelectedImageView release];
        
        //        数字
        UILabel *numLabel = [self newLabelWithText:[NSString stringWithFormat:@"%d",i+1] frame:CGRectMake(0, 3,unSelectedImage.size.width,18) font:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor]];
        numLabel.textAlignment = NSTextAlignmentCenter;
        [numLabel setBackgroundColor:[UIColor clearColor]];
        [unSelectedImageView addSubview:numLabel];
        [numLabel release];
        numLabel = nil;
        
        //        站点
        UILabel *stationLablel = [[UILabel alloc]init];
        stationLablel.numberOfLines = 0;
        UIFont *font = [UIFont systemFontOfSize:15];
        //设置一个行高上限
        NSString *getOutString = [[busLine.name stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
        CGSize labelsize = [getOutString sizeWithFont:font constrainedToSize:CGSizeMake(20,2000) lineBreakMode:NSLineBreakByWordWrapping];
        [stationLablel setFrame:CGRectMake(7, 28, 20,labelsize.height+30)];
        stationLablel.lineBreakMode = NSLineBreakByWordWrapping;
        stationLablel.textAlignment = NSTextAlignmentCenter;
        stationLablel.text = busLine.name;
        [unSelectedImageView addSubview:stationLablel];
        [stationLablel release]; stationLablel = nil;
    }
    btnScrollView.contentSize = CGSizeMake((mapBusLine.busStops.count) * 34, btnScrollView.frame.size.height);
}

- (void) setSelectedIndex:(NSUInteger)selectedIndex {
    [self setBtnSelected:selectedIndex];
}

- (void)setBtnSelected:(NSInteger)tag {
    for(UIView *v in btnScrollView.subviews) {
        if ([v isKindOfClass:[UIImageView class]]) {
            if (((UIImageView *)v).tag == tag)
                [(UIImageView *)v setHighlighted:YES];
            else
                [(UIImageView *)v setHighlighted:NO];
        }
    }
}

-(void)tapGestureRecognizer:(UITapGestureRecognizer *)tap{
    UIImageView *tagImageView = (UIImageView *)tap.view;
    [self setSelectedIndex:tagImageView.tag];
    
    currentTag = tagImageView.tag;
    
    AMapBusStop *busStop = [mapBusLine.busStops objectAtIndex:tagImageView.tag];
    [self.maMapView setCenterCoordinate:CLLocationCoordinate2DMake(busStop.location.latitude,busStop.location.longitude) animated:YES];
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([[userDefault objectForKey:GlobalCommunityLatitude] floatValue], [[userDefault objectForKey:GlobalCommunityLongitude] floatValue]));
//    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(busStop.location.latitude,busStop.location.longitude));
//    [self.mapView setVisibleMapRect:[CommonUtility unionMapRect1:MAMapRectMake(point1.x, point1.y, 0, 0) mapRect2:MAMapRectMake(point2.x, point2.y, 0, 0)]
//                           animated:YES];
    [self.maMapView selectAnnotation:[self.busStopAnnotations objectAtIndex:tagImageView.tag] animated:YES];
}

//
-(void)presentMapBusLine{
    self.busStopAnnotations = [[NSMutableArray alloc] init];
    [mapBusLine.busStops enumerateObjectsUsingBlock:^(AMapBusStop *busStop, NSUInteger idx, BOOL *stop) {
        BusStopAnnotation *annotation = [[BusStopAnnotation alloc] initWithBusStop:busStop];
        [self.busStopAnnotations addObject:annotation];
        [annotation release];
    }];
    
    [self.maMapView addAnnotations:self.busStopAnnotations];
    
    MAPolyline *polyline = [CommonUtility polylineForBusLine:mapBusLine];
    [self.maMapView addOverlay:polyline];
    
    self.maMapView.visibleMapRect = polyline.boundingMapRect;
    
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([[userDefault objectForKey:GlobalCommunityLatitude] floatValue], [[userDefault objectForKey:GlobalCommunityLongitude] floatValue]));
//    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(poi.location.latitude,poi.location.longitude));
//    
//    MAMapPoint *mapPoints = (MAMapPoint*)malloc(2 * sizeof(MAMapPoint));
//    mapPoints[0] = point2;
//    mapPoints[1] = point1;
    
//    [self.mapView setVisibleMapRect:[CommonUtility minMapRectForMapPoints:mapPoints count:2] animated:YES];

//    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(([[userDefault objectForKey:GlobalCommunityLatitude] floatValue]+poi.location.latitude)/2, ([[userDefault objectForKey:GlobalCommunityLongitude] floatValue]+poi.location.longitude)/2) animated:YES];
    
    [self.maMapView setZoomLevel:13 animated:YES];
//    [self.mapView setVisibleMapRect:[CommonUtility unionMapRect1:MAMapRectMake(point1.x, point1.y, 10, 10) mapRect2:MAMapRectMake(point2.x, point2.y, 0, 0)]
//                           animated:YES];
    
//    [self.mapView setVisibleMapRect:[CommonUtility unionMapRect1:MAMapRectMake(point1.x, point1.y, 10, 10) mapRect2:MAMapRectMake(point2.x, point2.y, 0, 0)] edgePadding:UIEdgeInsetsMake(0, 0, 0, 0) animated:YES];
    
    [self.maMapView setCenterCoordinate:CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude) animated:YES];
    
//    [self.mapView setZoomLevel:12 animated:YES];
    
}

//返回
-(void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Initialization
- (void)initMapView
{
    maMapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-175)];
    maMapView.delegate = self;
    [self.view addSubview:maMapView];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    MAPointAnnotation *myAnnotation = [[MAPointAnnotation alloc] init];
    myAnnotation.coordinate = CLLocationCoordinate2DMake([[userDefault objectForKey:GlobalCommunityLatitude] floatValue], [[userDefault objectForKey:GlobalCommunityLongitude] floatValue]);
    myAnnotation.title = [[self getCacheDataDictionaryString:GlobalCommunityAddress] objectForKey:@"address"];
    [self.maMapView addAnnotation:myAnnotation];
    [myAnnotation release];
}

/* 初始化search. */
- (void)initSearch
{
    search = [[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:self];
    
    search.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BusStopAnnotation class]])
    {
        static NSString *busStopIdentifier = @"busStopIdentifier";
        
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.maMapView dequeueReusableAnnotationViewWithIdentifier:busStopIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:busStopIdentifier] autorelease];
            
            poiAnnotationView.canShowCallout = YES;
        }

        poiAnnotationView.image = [UIImage imageNamed:@"traffic_busline_station_normal.png"];

        return poiAnnotationView;
    }else if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        
        CusAnnotationView *annotationView = (CusAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[[CusAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier] autorelease];
        }
        
        annotationView.portrait = [UIImage imageNamed:@"traffic_station_subway.png"];
        annotationView.name      = [[self getCacheDataDictionaryString:GlobalCommunityAddress] objectForKey:@"address"];

        return annotationView;
    }
    return nil;
}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *overlayView = [[[MAPolylineView alloc] initWithPolyline:overlay] autorelease];
        
        overlayView.lineWidth   = 3;
        overlayView.strokeColor = RGB(67, 164, 232);
        return overlayView;
    }
    return nil;
}

#pragma mark - CoreAnimation Delegate

- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"%s: keyPath = %@", __func__, ((CAPropertyAnimation *)anim).keyPath);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    /* flag 参数暂时无效. */
    
    NSLog(@"%s: keyPath = %@", __func__, ((CAPropertyAnimation *)anim).keyPath);
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    view.image = [UIImage imageNamed:@"traffic_busline_station_selected.png"];
}
- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view{
    view.image = [UIImage imageNamed:@"traffic_busline_station_normal.png"];
}
@end
