//
//  SubwayBusMapLineViewController.h
//  CommunityAPP
//
//  Created by yunlai on 14-3-10.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface SubwayBusMapLineViewController : UIViewController<MAMapViewDelegate, AMapSearchDelegate>
{
//    UILabel *numLabel;
//    UILabel *stationLablel;
    UIScrollView *btnScrollView;
    
    int currentTag;
    
    BOOL yesOrNo;
}
@property (nonatomic, retain) AMapPOI *poi;
@property(nonatomic,retain)   NSMutableArray *busStopAnnotations;
@property (nonatomic, retain) AMapBusLine *mapBusLine;

@property (nonatomic, retain) MAMapView *maMapView;
@property (nonatomic, retain) AMapSearchAPI *search;
@end
