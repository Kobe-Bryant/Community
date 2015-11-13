//
//  SubWayBusMapShowViewController.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-10.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "SubWayBusMapShowViewController.h"
#import "NSObject_extra.h"
#import "Global.h"
#import "CusAnnotationView.h"
#import "CommonUtility.h"
#import "UIViewController+NavigationBar.h"
#import "MobClick.h"

@interface SubWayBusMapShowViewController ()

@end

@implementation SubWayBusMapShowViewController
@synthesize poi;

-(void)dealloc{
    self.mapView.delegate = nil;
    [self.mapView release];
    self.mapView = nil;
    [imageArray release]; imageArray = nil;
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
    [MobClick beginLogPageView:@"SubWayBusMapShowPage"]; // 友盟统计
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"SubWayBusMapShowPage"];
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
    
    imageArray = [[NSArray alloc ]initWithObjects:@"traffic_station_subway.png",@"bg_convenience_myselfNext.png", nil];
    integer = 0;
    [self initMapView];
}

//返回
-(void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Initialization

- (void)initMapView
{
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.mapView.delegate = self;
    [self.mapView setMapType:MAMapTypeStandard];
    [self.view addSubview:self.mapView];
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
    pointAnnotation.title      = poi.name;
    [self.mapView addAnnotation:pointAnnotation];
    [pointAnnotation release];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    MAPointAnnotation *myAnnotation = [[MAPointAnnotation alloc] init];
    myAnnotation.coordinate = CLLocationCoordinate2DMake([[userDefault objectForKey:GlobalCommunityLatitude] floatValue], [[userDefault objectForKey:GlobalCommunityLongitude] floatValue]);
    myAnnotation.title      = [[self getCacheDataDictionaryString:GlobalCommunityAddress] objectForKey:@"address"];
    [self.mapView addAnnotation:myAnnotation];
    [myAnnotation release];
    
    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(poi.location.latitude,poi.location.longitude));
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([[userDefault objectForKey:GlobalCommunityLatitude] floatValue], [[userDefault objectForKey:GlobalCommunityLongitude] floatValue]));
    
//    MAMapSize mapSize = MAMapSizeMake((point1.x - point2.x) / 2, (point1.y - point2.y) / 2);
//    [self.mapView setVisibleMapRect:[CommonUtility minMapRectForAnnotations:titleArray] animated:YES];
//    [self.mapView setZoomLevel:17];
    [self.mapView setVisibleMapRect:[CommonUtility unionMapRect1:MAMapRectMake(point2.x, point2.y, 0, 0) mapRect2:MAMapRectMake(point1.x, point1.y,0, 0)]
                           animated:YES];
    [self.mapView setZoomLevel:18];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        CusAnnotationView *annotationView = (CusAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[[CusAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:pointReuseIndetifier] autorelease];
        }
        
        annotationView.canShowCallout               = YES;
        annotationView.draggable                    = YES;
        annotationView.portrait                     = [UIImage imageNamed:[imageArray objectAtIndex:integer]];
        integer++;
        return annotationView;
    }
    
    return nil;
}

#pragma mark - Action Handle

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    /* Adjust the map center in order to show the callout view completely. */
    if ([view isKindOfClass:[CusAnnotationView class]]) {
        CusAnnotationView *cusView = (CusAnnotationView *)view;
        CGRect frame = [cusView convertRect:cusView.calloutView.frame toView:self.mapView];
        
        frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(-8, -8, -8, -8));
        
        if (!CGRectContainsRect(self.mapView.frame, frame))
        {
            /* Calculate the offset to make the callout view show up. */
            CGSize offset = [self offsetToContainRect:frame inRect:self.mapView.frame];
            
            CGPoint theCenter = self.mapView.center;
            theCenter = CGPointMake(theCenter.x - offset.width, theCenter.y - offset.height);
            
            CLLocationCoordinate2D coordinate = [self.mapView convertPoint:theCenter toCoordinateFromView:self.mapView];
            
            [self.mapView setCenterCoordinate:coordinate animated:YES];
        }
        
    }
}

- (CGPoint)randomPoint
{
    CGPoint randomPoint = CGPointZero;
    
    randomPoint.x = arc4random() % (int)(CGRectGetWidth(self.view.bounds));
    randomPoint.y = arc4random() % (int)(CGRectGetHeight(self.view.bounds));
    
    return randomPoint;
}

- (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect
{
    CGFloat nudgeRight = fmaxf(0, CGRectGetMinX(outerRect) - (CGRectGetMinX(innerRect)));
    CGFloat nudgeLeft = fminf(0, CGRectGetMaxX(outerRect) - (CGRectGetMaxX(innerRect)));
    CGFloat nudgeTop = fmaxf(0, CGRectGetMinY(outerRect) - (CGRectGetMinY(innerRect)));
    CGFloat nudgeBottom = fminf(0, CGRectGetMaxY(outerRect) - (CGRectGetMaxY(innerRect)));
    return CGSizeMake(nudgeLeft ?: nudgeRight, nudgeTop ?: nudgeBottom);
}
@end
