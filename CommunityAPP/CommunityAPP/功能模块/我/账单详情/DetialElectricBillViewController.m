//
//  DetialElectricBillViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-6.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "DetialElectricBillViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "NSObject+Time.h"
#import "UIViewController+NavigationBar.h"
#import "MobClick.h"

#define HideCell  [listBean.typeString integerValue]==2||[listBean.typeString integerValue]==3||[listBean.typeString integerValue]==4

@interface DetialElectricBillViewController ()


@end

@implementation DetialElectricBillViewController
@synthesize listBean;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    [listBean release]; listBean = nil;
    detialEleBillTableView.delegate = nil;
    [detialEleBillTableView release]; detialEleBillTableView = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DetialElectricBillPage"]; // 友盟统计
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DetialElectricBillPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:listBean.titleString];
    self.view.backgroundColor = RGB(244, 244, 244);
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];

	//uitableview列表
    detialEleBillTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, MainHeight) style:UITableViewStylePlain];
    detialEleBillTableView.scrollEnabled = NO;
    detialEleBillTableView.backgroundView = nil;
    detialEleBillTableView.backgroundColor = [UIColor clearColor];
    detialEleBillTableView.backgroundView.backgroundColor = RGB(244, 244, 244);
    detialEleBillTableView.delegate = self;
    detialEleBillTableView.dataSource = self;
    detialEleBillTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    [self.view addSubview:detialEleBillTableView];
    
}

#pragma mark --uitableviewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (HideCell){
        return 3;
    }else{
     return 2;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (HideCell) {
        if (section == 0) {
            return 3;
        }else if (section == 1){
            return 1;
        }else if (section == 2){
            return 1;
        }
       
    }else{
        if (section  == 0) {
            return 2;
        }else if (section == 1) {
            return 1;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (HideCell) {
        return 0;
    }else{
        if (section == 1) {
            if (listBean.descriptionString.length > 0) {
                CGSize size = [listBean.descriptionString sizeWithFont:[UIFont systemFontOfSize:17] forWidth:320 lineBreakMode:NSLineBreakByWordWrapping];
                CGFloat height = MAX(size.height*1.5, 40);
                return height;
            }
            
        }
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (HideCell) {
        return nil;
    }else{
        if (section == 1) {
            NSString *description = @"description";
            if (listBean.descriptionString.length > 0) {
                //CGSize size = [listBean.descriptionString sizeWithFont:[UIFont systemFontOfSize:17] forWidth:320 lineBreakMode:NSLineBreakByWordWrapping];
                //CGFloat height = MAX(size.height*1.5, 40);
                UITableViewHeaderFooterView *footView = [[[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:description] autorelease];
                footView.layer.borderWidth = 0.5f;
                footView.layer.borderColor = RGB(223, 223, 223).CGColor;
                footView.backgroundColor = [UIColor whiteColor];
                footView.backgroundView = [[[UIView alloc] initWithFrame:footView.bounds] autorelease];
                footView.backgroundView.backgroundColor = [UIColor whiteColor];
                footView.textLabel.textColor = RGB(51, 51, 51);
                footView.textLabel.font = [UIFont systemFontOfSize:15.0];
                footView.textLabel.text = listBean.descriptionString;
                return footView;
            }

        }
    }
    
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.textLabel.textColor = RGB(47, 47, 47);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
        cell.detailTextLabel.textColor = RGB(47, 47, 47);
        cell.backgroundView = [[[UIView alloc]initWithFrame:cell.bounds] autorelease];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case 0:
            if (row == 0) {
                cell.textLabel.text = @"应付总额（元）";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",listBean.amountString];
            }
            if (HideCell) {
                if (row ==1) {
                    //                账单类型(2 水费，3 电费，4 煤气费，5 其他) type
                    cell.textLabel.text = @"本期用量";
                    if ([listBean.typeString integerValue]==2) {
                        cell.textLabel.text = @"本期用量（吨）";
                    }
                    if ([listBean.typeString integerValue]==3) {
                        cell.textLabel.text = @"本期用量（度）";
                    }
                    if ([listBean.typeString integerValue]==4) {
                        cell.textLabel.text = @"本期用量（立方）";
                    }
                    cell.detailTextLabel.text =[NSString stringWithFormat:@"%@",listBean.countString];
                }
                if (row == 2) {
                    //转换时间格式
                    NSArray *startArray = [listBean.startTimeString componentsSeparatedByString:@" "];//[NSString formatterDate:listBean.startTimeString];
                    NSArray *endArray = [listBean.endTimeString componentsSeparatedByString:@" "];//[NSString formatterDate:listBean.endTimeString];
                    cell.textLabel.text = @"起止时间";
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@至%@",[startArray objectAtIndex:0],[endArray objectAtIndex:0]];
                }
            }else{
                if (row == 1) {
                    //转换时间格式
                    NSArray *startArray = [listBean.startTimeString componentsSeparatedByString:@" "];//[NSString formatterDate:listBean.startTimeString];
                    NSArray *endArray = [listBean.endTimeString componentsSeparatedByString:@" "];//[NSString formatterDate:listBean.endTimeString];
                    cell.textLabel.text = @"起止时间";
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@至%@",[startArray objectAtIndex:0],[endArray objectAtIndex:0]];
                }
            }

            break;
        case 1:
            if (row == 0) {
                cell.textLabel.text = @"本期费用";
                 cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",listBean.totalString];
            }
            if (row ==1) {
                cell.textLabel.text = @"本次读数";
                if ([listBean.typeString integerValue]==2) {
                    cell.textLabel.text = @"本次读数（吨）";
                }
                if ([listBean.typeString integerValue]==3) {
                    cell.textLabel.text = @"本次读数（度）";
                }
                if ([listBean.typeString integerValue]==4) {
                    cell.textLabel.text = @"本次读数（立方）";
                }
                 cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",listBean.readingsString];
            }
            if (row == 2) {
                cell.textLabel.text = @"单价";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",listBean.priceString];
            }
            break;
        case 2:
//            if (row == 0) {
//                cell.textLabel.text = @"上期欠费";
//                 cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",listBean.oldArrearsString];
//            }
            if (row ==0) {
                cell.textLabel.text = @"违约金";
                 cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",listBean.damagesString];
            }
         
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark -- uitableviewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0;
}

//设置headerView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //设置headerView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    headerView.layer.borderWidth = 0.5f;
    headerView.layer.borderColor = RGB(223, 223, 223).CGColor;
    UILabel *typeLab = [[UILabel alloc] initWithFrame:CGRectMake(15,15, 100, 20)];//标题
    typeLab.backgroundColor = [UIColor clearColor];
    typeLab.textColor = RGB(51, 51, 51);//设置headerLab的字体颜色
    typeLab.font = [UIFont systemFontOfSize:16.0];
    if (section == 0) {
        typeLab.text = @"概况";
    }
    if (section == 1) {
        typeLab.text = @"详情";
    }
    if (section == 2) {
        typeLab.text = @"费用";
    }
    [headerView addSubview:typeLab];
    [typeLab release];
    return headerView;
}




//导航栏左侧返回按钮
-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
