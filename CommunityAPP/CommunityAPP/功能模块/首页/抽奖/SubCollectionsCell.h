//
//  SubCollectionsCell.m
//  CommunityAPP
//
//  Created by yunlai on 14-4-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubCollectionCellView.h"

@interface SubCollectionsCell : UITableViewCell
{
    SubCollectionCellView *_cellView1;
    SubCollectionCellView *_cellView2;
}

@property(retain,nonatomic) SubCollectionCellView *cellView1;
@property(retain,nonatomic) SubCollectionCellView *cellView2;

-(void) initSubCollectionsCell;

@end
