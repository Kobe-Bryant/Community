//
//  MyNeighborView.h
//  CommunityAPP
//
//  Created by yunlai on 14-5-7.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NeighborhoodViewController.h"

@interface MyNeighborView : UIView<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UITableView *myNeighborTableView;
    
    NSInteger didselect;
    NSInteger endselect;
    
    NSInteger insertCount;
    NSInteger deleteCount;
    
    BOOL ifOpen;
    BOOL ifInsert;
    
    NSInteger selectSection;
    NSInteger oldSection;
    
    UIViewController *lastViewC;
    
    UISearchBar *mySearchBar;
    UISearchDisplayController *searchDisplayController;
}
@property (retain, nonatomic) NSMutableArray *searchResults;
@property (retain, nonatomic) NSMutableArray *groupArray;
@property (retain, nonatomic) NSMutableArray *oldArr;
@property (retain, nonatomic) NSMutableArray *cellArray;
@property (retain, nonatomic) UIImageView *fselectImageV;
@property (retain, nonatomic) UIImageView *bselectImageV;

@property (retain, nonatomic) NSMutableArray *listArray;

- (id)initWithFrame:(CGRect)frame delegateController:(UIViewController *)controller;
@end
