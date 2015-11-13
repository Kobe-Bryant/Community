//
//  SubWayBusMapShowViewController.h
//  CommunityAPP
//
//  Created by yunlai on 14-3-10.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import "POIAnnotation.h"

@interface SubWayBusMapShowViewController : UIViewController<MAMapViewDelegate>{
    int integer;
//    NSMutableArray *titleArray;
    NSArray *imageArray;
}
@property (nonatomic, retain) MAMapView *mapView;
@property (nonatomic, retain) AMapPOI *poi;
@end
