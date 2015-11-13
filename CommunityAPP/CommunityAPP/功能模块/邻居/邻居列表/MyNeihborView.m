//
//  MyNeihborView.m
//  IMDemo
//
//  Created by Dream on 14-7-18.
//  Copyright (c) 2014年 Yunlai-mac02. All rights reserved.
//

#import "MyNeihborView.h"
#import "NSObject_extra.h"
#import "Global.h"
#import "PAMutilColorLabel.h"
#import "GroupUserListModel.h"

@implementation MyNeihborView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        dataArray0 = [[NSArray alloc]init];
        dataArray1 = [[NSArray alloc]initWithObjects:@"test10",@"test20",@"test30",@"test40", nil];
        dataArray2 = [[NSArray alloc]initWithObjects:@"test100",@"test200",@"test300",@"test400", nil];
        
        aryHeaderView = [[NSMutableArray alloc] init];//headerView里放的数据
        aryFoldCells = [[NSMutableArray alloc] init]; //数组收藏cell里的数据
        [self initTableView];
    }
    return self;
}

- (void)dealloc
{
    [aryHeaderView release]; aryHeaderView = nil;
    [aryFoldCells release]; aryFoldCells = nil;
    [dataArray0 release]; dataArray0 = nil;
    [dataArray1 release]; dataArray1 = nil;
    [dataArray2 release]; dataArray2 = nil;
    [super dealloc];
}

- (void)initTableView{
    _myNeighborTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth , MainHeight) style:UITableViewStylePlain];
    _myNeighborTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myNeighborTableView.delegate = self;
    _myNeighborTableView.dataSource = self;
    [self addSubview:_myNeighborTableView];
    [_myNeighborTableView release];
    
    FoldView *foldView1 = [[FoldView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30) Title:@"HeaderView1"];
    foldView1.delegate = self;
    foldView1.tag = 1000;
    foldView1.isClicked = NO;
    
    FoldView *foldView2 = [[FoldView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30) Title:@"HeaderView2"];
    foldView2.delegate = self;
    foldView2.tag = 1001;
    foldView2.isClicked = NO;
    
    FoldView *foldView3 = [[FoldView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30) Title:@"HeaderView3"];
    foldView3.delegate = self;
    foldView3.tag = 1002;
    foldView3.isClicked = NO;
    
    [aryHeaderView addObject:foldView1];
    [aryHeaderView addObject:foldView2];
    [aryHeaderView addObject:foldView3];
    [foldView1 release];
    [foldView2 release];
    [foldView3 release];
    
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [aryHeaderView count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section < [aryFoldCells count]) {
        return [[aryFoldCells objectAtIndex:section] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"Cell";
    UITableViewCell *cell = [_myNeighborTableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer] autorelease];
        UIImage *line = [UIImage imageNamed:@"bg_speacter_line@2x.png"];
        UIImageView *lineImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43,line.size.width ,line.size.height)];
        lineImg.image = line;
        [cell.contentView addSubview:lineImg];
        [lineImg release];
        
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, -10, 300, 60)];
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.textAlignment = NSTextAlignmentLeft;
        lblTitle.font = [UIFont systemFontOfSize:16.0f];
        lblTitle.textColor = [UIColor blackColor];
        lblTitle.tag = 10000;
        [cell.contentView addSubview:lblTitle];
        [lblTitle release];
    }
    if (indexPath.section < [aryFoldCells count]) {
        NSArray *ary = [aryFoldCells objectAtIndex:indexPath.section];
        if (indexPath.row < [ary count]) {
            UILabel *lblText = (UILabel *)[cell.contentView viewWithTag:10000];
            lblText.text = [ary objectAtIndex:indexPath.row];
        }
    }
    return cell;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section < [aryHeaderView count]) {
        return [aryHeaderView objectAtIndex:section];
    }
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSArray *array = [aryFoldCells objectAtIndex:indexPath.section];
    if ([self.delegate respondsToSelector:@selector(enterChatVc:)]) {
        [self.delegate enterChatVc:[array objectAtIndex:indexPath.row]];
    }
}


#pragma mark - FoldView Delegate
- (void) headViewPressed:(NSInteger)tag {
    if ([aryFoldCells count] > 0) {
        [aryFoldCells removeAllObjects];
    }
    
    FoldView *foldView = (FoldView *)[aryHeaderView objectAtIndex:tag - 1000];
    foldView.isClicked = !foldView.isClicked;
    
    [foldView setFoldImage:foldView.isClicked];
    
    //
    if (tag == 1000 && foldView.isClicked == 1) {
        NSLog(@"Header1展开");
        
        NSArray *ary1 = [[NSArray alloc] init];
        NSArray *ary2 = [[NSArray alloc] init];
        [aryFoldCells addObject:dataArray0];
        [aryFoldCells addObject:ary1];
        [aryFoldCells addObject:ary2];
        
        FoldView *foldView1 = (FoldView *)[aryHeaderView objectAtIndex:1];
        FoldView *foldView2 = (FoldView *)[aryHeaderView objectAtIndex:2];
        [foldView1 setFoldImage:0];
        [foldView2 setFoldImage:0];
    }
    else if (tag == 1001 && foldView.isClicked == 1) {
        NSLog(@"Header2展开");
        NSArray *ary1 = [[NSArray alloc] init];
        NSArray *ary2 = [[NSArray alloc] init];
        [aryFoldCells addObject:ary1];
        [aryFoldCells addObject:dataArray1];
        [aryFoldCells addObject:ary2];
        
        FoldView *foldView1 = (FoldView *)[aryHeaderView objectAtIndex:0];
        FoldView *foldView2 = (FoldView *)[aryHeaderView objectAtIndex:2];
        [foldView1 setFoldImage:0];
        [foldView2 setFoldImage:0];
    }
    else if (tag == 1002 && foldView.isClicked == 1) {
        NSLog(@"Header3展开");
        NSArray *ary1 = [[NSArray alloc] init];
        NSArray *ary2 = [[NSArray alloc] init];
        [aryFoldCells addObject:ary1];
        [aryFoldCells addObject:ary2];
        [aryFoldCells addObject:dataArray2];
        
        FoldView *foldView1 = (FoldView *)[aryHeaderView objectAtIndex:0];
        FoldView *foldView2 = (FoldView *)[aryHeaderView objectAtIndex:1];
        [foldView1 setFoldImage:0];
        [foldView2 setFoldImage:0];
    }
    
    [_myNeighborTableView reloadData];
}


@end
