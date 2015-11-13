//
//  MyNeihborView.h
//  IMDemo
//
//  Created by Dream on 14-7-18.
//  Copyright (c) 2014年 Yunlai-mac02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoldView.h"

@protocol MyNeihborViewDelegate <NSObject>
@optional
-(void)enterChatVc:(NSString *)sender;

@end

@interface MyNeihborView : UIView<UITableViewDataSource, UITableViewDelegate,FoldViewDelegate>{
    UITableView *_myNeighborTableView;
    
    UISearchBar *_mySearchBar;
    UISearchDisplayController *_searchDisplayController;
    
    NSArray *dataArray0;
    NSArray *dataArray1;
    NSArray *dataArray2;
    NSMutableArray *aryHeaderView;
    NSMutableArray *aryFoldCells;
}
@property (nonatomic, assign) id<MyNeihborViewDelegate> delegate;


@end
