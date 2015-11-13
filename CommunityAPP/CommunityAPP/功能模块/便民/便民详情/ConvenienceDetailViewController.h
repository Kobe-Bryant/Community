//
//  ConvenienceDetailViewController.h
//  CommunityAPP
//
//  Created by yunlai on 14-4-3.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConvenienceListData.h"
#import <MAMapKit/MAMapKit.h>

@interface ConvenienceDetailViewController : UIViewController<MAMapViewDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>{
    UITableView *detailTableView;
    
    UIWebView *_phoneCallWebView;
    int integer;
    NSArray *imageArray;
}
@property (nonatomic,retain) MAMapView *maMapView;
@property(nonatomic,retain)ConvenienceListData *listData;
@end
