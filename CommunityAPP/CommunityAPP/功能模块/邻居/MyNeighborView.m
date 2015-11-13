//
//  MyNeighborView.m
//  CommunityAPP
//
//  Created by yunlai on 14-5-7.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "MyNeighborView.h"
#import "Global.h"
#import "FriendUserInformationModel.h"
#import "UIImageView+WebCache.h"
#import "NSData+Base64.h"
#import "NeighborhoodViewController.h"
#import "DataBaseManager.h"
#import "PAMutilColorLabel.h"
#import "GroupUserListModel.h"
#import "NeighboorHoodFriendList.h"

#define BackViewDataNum 100000
#define BackViewHeaderViewH 44.f

@implementation MyNeighborView
@synthesize fselectImageV;
@synthesize bselectImageV;
@synthesize oldArr;
@synthesize groupArray;
@synthesize cellArray;
@synthesize searchResults;
@synthesize listArray;

-(void)dealloc{
    self.fselectImageV = nil;
    self.bselectImageV = nil;
    [myNeighborTableView release]; myNeighborTableView = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame delegateController:(UIViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        lastViewC = controller;
        
        didselect = BackViewDataNum;
        selectSection = BackViewDataNum;
        oldSection = BackViewDataNum;
        
        self.groupArray = [[NSMutableArray alloc] init];
        DataBaseManager *dbManager = [DataBaseManager shareDBManeger];
        self.listArray = [dbManager selectNeighboorHoodList];
//        通过http的通道走。。。。
        self.groupArray = [dbManager selectGroupList];
        
        [self initTableView];
    }
    return self;
}

-(void)initTableView{
    myNeighborTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.frame.size.height)];
    myNeighborTableView.backgroundColor = [UIColor whiteColor];
    myNeighborTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    myNeighborTableView.dataSource = self;
    myNeighborTableView.delegate = self;
    myNeighborTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    [self addSubview:myNeighborTableView];
    
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    mySearchBar.delegate = self;
    [mySearchBar setPlaceholder:@"搜索"];
//    if (!IOS7_OR_LATER) {
//        for (UIView *subview in mySearchBar.subviews) {
//            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
//                [subview removeFromSuperview];
//                break;
//            }
//        }
//    }
    float version = [[[ UIDevice currentDevice ] systemVersion ] floatValue ];
    if ([ mySearchBar respondsToSelector : @selector (barTintColor)]) {
        float  iosversion7_1 = 7.1 ;
        if (version >= iosversion7_1)
        {  //iOS7.1
            [[[[ mySearchBar . subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
            [ mySearchBar setBackgroundColor :RGB(240, 240, 240)];
        }
        else
        {
            //iOS7.0
            [ mySearchBar setBarTintColor :[ UIColor clearColor ]];
            [ mySearchBar setBackgroundColor :RGB(240, 240, 240)];
        }}
       else
       {
        //iOS7.0 以下
           [[ mySearchBar.subviews objectAtIndex : 0 ] removeFromSuperview ];
           [ mySearchBar setBackgroundColor :RGB(240, 240, 240)];
        }
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:lastViewC];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    myNeighborTableView.tableHeaderView = mySearchBar;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
// 创建一级分类的视图
- (UIView *)createHeaderView:(NSInteger)index
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, BackViewHeaderViewH)] autorelease];
    headerView.backgroundColor = [UIColor whiteColor];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.f, 0.f, ScreenWidth, BackViewHeaderViewH);
    button.tag = index;
    [button addTarget:self action:@selector(insertCell:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:button];
    
    if (selectSection == index) {
        button.selected = YES;
        [button setBackgroundColor:[UIColor colorWithRed:238.f/255.f green:238.f/255.f blue:238.f/255.f alpha:1.f]];
    }
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, ScreenWidth, 0.5)];
    lineView1.backgroundColor = [UIColor colorWithRed:232.f/255.f green:232.f/255.f blue:232.f/255.f alpha:1.f];
    [headerView addSubview:lineView1];
    [lineView1 release];
    
    // name Label
    DataBaseManager *dbManager = [DataBaseManager shareDBManeger];
    GroupUserListModel *model = [self.groupArray objectAtIndex:index];
    
    PAMutilColorLabel *groupLabel = [[PAMutilColorLabel alloc]initWithFrame:CGRectMake(14, 12.f, 150.f, 20)];
    groupLabel.backgroundColor = [UIColor clearColor];
    groupLabel.textColor = RGB(51, 51, 51);
    groupLabel.font = [UIFont systemFontOfSize:14.f];

    [groupLabel setMutilColorText:[NSString stringWithFormat:@"%@  ( %d )",model.groupNameString,[[dbManager selectNeighboorHoodFriendList:model.groupIdString] count]] ColorText:[NSString stringWithFormat:@"( %d )",[[dbManager selectNeighboorHoodFriendList:model.groupIdString] count]] Color:RGB(152, 152, 152) DefaultColor:RGB(51, 51, 51)];
    [headerView addSubview:groupLabel];
    [groupLabel release];
    
    
    // image  icon_front_store.png
    UIImage *arrowImage = [UIImage imageNamed:@"icon_front_store1.png"];
    int xValue = 0;
    xValue = 310 - arrowImage.size.width;
    
    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(xValue, BackViewHeaderViewH/2-arrowImage.size.height/2, arrowImage.size.width, arrowImage.size.height)];
    arrowImageView.image = arrowImage;
    [button addSubview:arrowImageView];
    [arrowImageView release];
    [pool release];
    
    if ([self.groupArray lastObject]) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0.f, BackViewHeaderViewH-0.5, ScreenWidth, 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:232.f/255.f green:232.f/255.f blue:232.f/255.f alpha:1.f];
        [headerView addSubview:lineView];
        [lineView release];
    }
    return headerView;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == myNeighborTableView) {
        return [self.groupArray count];
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == myNeighborTableView) {
        if (section == didselect) {
            return [self.cellArray count];
        } else {
            return 0;
        }
    }else {
        return searchResults.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        UIImage *iconImage = [UIImage imageNamed:@"default_head.png"];
//        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, iconImage.size.width, iconImage.size.height)];
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 6, 38, 38)];
        iconImageView.image = iconImage;
        iconImageView.tag = 99997;
        iconImageView.layer.cornerRadius = 18.8f; //25.0f;
        iconImageView.layer.masksToBounds = YES;
        [cell addSubview:iconImageView];
        [iconImageView release];
        
//        性别图片
        UIImage *sexImage = [UIImage imageNamed:@"icon_female.png"];
        UIImageView *sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(iconImageView.frame.size.width+iconImageView.frame.origin.x+12, iconImageView.frame.origin.y+4, sexImage.size.width, sexImage.size.height)];
        sexImageView.image = sexImage;
        sexImageView.tag = 99998;
        [cell addSubview:sexImageView];
        [sexImageView release];
        
        //    title
        UILabel *nameLabel = [[UILabel alloc ]  initWithFrame:
                              CGRectMake(sexImageView.frame.size.width+sexImageView.frame.origin.x+3, iconImageView.frame.origin.y, 180, 20)];
        nameLabel.textColor=RGB(51, 51, 51);
        nameLabel.tag = 99999;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font=[UIFont systemFontOfSize:15];
        [cell addSubview:nameLabel];
        [nameLabel release];
        
        //    个性签名
        UILabel *signLabel = [[UILabel alloc ] initWithFrame:
                              CGRectMake(iconImageView.frame.size.width+iconImageView.frame.origin.x+12, nameLabel.frame.size.height+nameLabel.frame.origin.y+5, 180, 20)];
        signLabel.textColor = RGB(100, 100, 100);
        signLabel.backgroundColor = [UIColor clearColor];
        signLabel.tag = 100000;
        signLabel.font = [UIFont systemFontOfSize:13];
        [cell addSubview:signLabel];
        [signLabel release];
    }
    UIImageView *iconImageViewTag = (UIImageView *)[cell viewWithTag:99997];
    UIImageView *sexImageViewTag = (UIImageView *)[cell viewWithTag:99998];
    UILabel *nameLabelTag = (UILabel *)[cell viewWithTag:99999];
    UILabel *signLabelTag = (UILabel *)[cell viewWithTag:100000];

    NeighboorHoodFriendList *infromationModel;
    if (tableView == myNeighborTableView) {
        infromationModel = [self.cellArray objectAtIndex:indexPath.row];
    } else {
        infromationModel = [self.searchResults objectAtIndex:indexPath.row];
    }
    nameLabelTag.text = infromationModel.nicknameString;
    if([infromationModel.genderString isEqualToString:@"1"]){
        sexImageViewTag.image = [UIImage imageNamed:@"icon_male1.png"];
    }else{
        sexImageViewTag.image = [UIImage imageNamed:@"icon_female1.png"];
    }
    if ([infromationModel.signatureString isEqualToString:@""]||[infromationModel.signatureString isEqualToString:nil]||[infromationModel.signatureString length] == 0) {
        signLabelTag.text = infromationModel.signatureString;
    }else{
        signLabelTag.text = @"";
    }
    [iconImageViewTag setImageWithURL:[NSURL URLWithString:infromationModel.avatarString] placeholderImage:[UIImage imageNamed:@"default_head.png"]];
    return cell;
}

#pragma mark - UITableViewDelegate
// 选中row执行的操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NeighboorHoodFriendList *infromationModel;
    if (tableView == myNeighborTableView) {
        infromationModel = [self.cellArray objectAtIndex:indexPath.row];
    }else{
        infromationModel = [self.searchResults objectAtIndex:indexPath.row];
    }
//    [lastViewC enterChatIngVc:infromationModel];
}

// 设置row的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == myNeighborTableView) {
        if (indexPath.section == didselect) {
            return 50.f;
        }
        return 0;
    }else{
        return 50.f;
    }
}

// 设置header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == myNeighborTableView) {
        return BackViewHeaderViewH;
    }else{
        return 0;
    }
}

// header 视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == myNeighborTableView) {
        return [self createHeaderView:section];
    }else{
        return nil;
    }
}

- (void)buttonSetSelected:(UIButton *)sender
{
    if (sender.selected) {
        sender.selected = NO;
        [sender setBackgroundColor:[UIColor clearColor]];
    } else {
        sender.selected = YES;
        [sender setBackgroundColor:[UIColor clearColor]];
    }
}
// 插入操作
- (void)insertCell:(UIButton *)sender
{
    if (selectSection != sender.tag) {
        [self buttonSetSelected:sender];
        selectSection = sender.tag;
        if (selectSection != oldSection && oldSection != BackViewDataNum) {
            NSRange range = NSMakeRange(oldSection, 1);
            NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
            [myNeighborTableView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
        }
        oldSection = selectSection;
    }
    DataBaseManager *dbManager = [DataBaseManager shareDBManeger];
    GroupUserListModel *model = [self.groupArray objectAtIndex:sender.tag];
    self.cellArray = [dbManager selectNeighboorHoodFriendList:model.groupIdString];
    insertCount = self.cellArray.count;
    endselect = sender.tag;
    self.bselectImageV = [sender.subviews lastObject];
    
    if (didselect == endselect) {
        [self didSelectCellRowFirstDo:NO nextDo:NO];
    } else{
        [self didSelectCellRowFirstDo:NO nextDo:YES];
    }
}

// 选中header
- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    [myNeighborTableView beginUpdates];
    ifOpen = firstDoInsert;
    if (!ifOpen) {
        didselect = BackViewDataNum;
        if (self.oldArr.count != 0) {
            ifInsert = NO;
            [UIView animateWithDuration:0.1 animations:^{
                self.fselectImageV.image = [UIImage imageNamed:@"icon_front_store1.png"];
            }];
            deleteCount = 0;
            [myNeighborTableView deleteRowsAtIndexPaths:self.oldArr withRowAnimation:UITableViewRowAnimationNone];
            self.oldArr = nil;
        }
    } else {
        didselect = endselect;
        NSInteger sum = deleteCount == 0 ? insertCount : deleteCount;
        NSMutableArray *rowArray = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger i = 0; i < sum; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:didselect];
            [rowArray addObject:indexPath];
        }
        if (rowArray.count != 0) {
            ifInsert = YES;
            [UIView animateWithDuration:0.1 animations:^{
                self.bselectImageV.image = [UIImage imageNamed:@"icon_down_store1.png"];
            }];
            self.fselectImageV = self.bselectImageV;
            deleteCount = insertCount;
            [myNeighborTableView insertRowsAtIndexPaths:rowArray withRowAnimation:UITableViewRowAnimationNone];
            self.oldArr = rowArray;
        }
    }
    
    [myNeighborTableView endUpdates];
    
    if (nextDoInsert) {
        [self didSelectCellRowFirstDo:YES nextDo:NO];
        return;
    }
    
    if (ifInsert) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:didselect];
        [myNeighborTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}
#pragma UISearchDisplayDelegate
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)hsearchBar
//{
//    hsearchBar.showsCancelButton = YES;
//    for(id cc in [hsearchBar subviews])
//    {
//        if([cc isKindOfClass:[UIButton class]])
//        {
//            UIButton *btn = (UIButton *)cc;
//            [btn setTitle:@"取消" forState:UIControlStateNormal];
//        }
//    }
//}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    searchResults = [[NSMutableArray alloc]init];
    for (int i = 0; i<[self.listArray count]; i++) {
        NeighboorHoodFriendList *infromationModel = [self.listArray objectAtIndex:i];
        NSRange foundObj=[infromationModel.nicknameString rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if(foundObj.length>0) {
            [self.searchResults addObject:infromationModel];
        }
    }
    [myNeighborTableView reloadData];
}
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    self.searchResults = self.listArray;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    self.searchResults = nil;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return YES;
}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    cell.frame = CGRectMake(-320, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
//    [UIView animateWithDuration:0.7 animations:^{
//        cell.frame = CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
//    } completion:^(BOOL finished) {
//        ;
//    }];
//}
@end
