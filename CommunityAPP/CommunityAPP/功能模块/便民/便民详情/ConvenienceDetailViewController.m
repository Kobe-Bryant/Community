//
//  ConvenienceDetailViewController.m
//  CommunityAPP
//
//  Created by yunlai on 14-4-3.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "ConvenienceDetailViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "MakePhoneCall.h"
#import "CusAnnotationView.h"
#import "UIViewController+NavigationBar.h"
#import "ConvenienceBusinessWebViewController.h"
#import "MobClick.h"

@interface ConvenienceDetailViewController ()

@end

@implementation ConvenienceDetailViewController
@synthesize listData;
@synthesize maMapView;

-(void)dealloc{
    [detailTableView release]; detailTableView = nil;
    [maMapView setDelegate:nil];
    [maMapView release]; maMapView = nil;
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
    [MobClick beginLogPageView:@"ConvenienceDetailPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ConvenienceDetailPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:RGB(244, 244, 244)];
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:listData.nameString];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    imageArray = [[NSArray alloc ]initWithObjects:@"bg_convenience_myselfNext.png",@"bg_convenience_business.png", nil];
    
    integer = 0;
    
    [self initMapView];
    [self initTableView];
    
    //    大众点评的logo
    UIImage *apiImage = [UIImage imageNamed:@"bg_dpApi_logo.png"];
    UIImageView *apiImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-apiImage.size.width-10, MainHeight-10-apiImage.size.height, apiImage.size.width, apiImage.size.height)];
    [apiImageView setImage:apiImage];
    [self.view addSubview:apiImageView];
    [self.view insertSubview:apiImageView aboveSubview:detailTableView];
    [apiImageView release];
}


- (void)initMapView
{
    maMapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 300)];
    maMapView.delegate = self;
    [maMapView setMapType:MAMapTypeStandard];
    [self.view addSubview:maMapView];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    MAPointAnnotation *red = [[MAPointAnnotation alloc] init];
    red.coordinate = CLLocationCoordinate2DMake([[userDefault objectForKey:GlobalCommunityLatitude] floatValue], [[userDefault objectForKey:GlobalCommunityLongitude] floatValue]);
    red.title      = [[userDefault objectForKey:GlobalCommunityAddress] objectForKey:@"address"];
    [maMapView addAnnotation:red];
    [red release]; //add vincent 内存释放
    
    MAPointAnnotation *green = [[MAPointAnnotation alloc] init];
    green.coordinate = CLLocationCoordinate2DMake([listData.latitudeString floatValue], [listData.longitudeString floatValue]);
    green.title      = listData.nameString;
    [maMapView addAnnotation:green];
    [green release]; //add vincent 内存释放
    
    [maMapView setCenterCoordinate:green.coordinate animated:YES];
    [maMapView setZoomLevel:15];
    
}

-(void)initTableView{
     // change by devin
    NSInteger stateBarHeight;
    if (IOS6_OR_LATER) {
        stateBarHeight = 0;
    }else{
        stateBarHeight = 20;
    }
    detailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 300-NavigationBarHeight-stateBarHeight, ScreenWidth, 155) style:UITableViewStylePlain];
    if (!isIPhone5) {
        detailTableView.frame = CGRectMake(0, 300-NavigationBarHeight-stateBarHeight , ScreenWidth,155);
    }
    detailTableView.backgroundColor = [UIColor clearColor];
    detailTableView.scrollEnabled = NO;
    detailTableView.delegate = self;
    detailTableView.dataSource = self;
    detailTableView.tableHeaderView = [[[UIView alloc]initWithFrame:CGRectZero]autorelease];
    [self.view addSubview:detailTableView];
    
    UIView *footView = [[UIView alloc] init];
    detailTableView.tableFooterView = footView;
    [footView release];
}

//导航栏左按钮
-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
            annotationView = [[CusAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout               = YES;
        annotationView.draggable                    = YES;
        annotationView.portrait                     = [UIImage imageNamed:[imageArray objectAtIndex:integer]];
        integer++;
        return annotationView;
    }
    
    return nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma UITableViewDelegate
#pragma mark UITableViewDataSource implementation
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify = @"ConvenienceListViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:
                 UITableViewCellStyleSubtitle reuseIdentifier:identify] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = RGB(51, 51, 51);
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    NSInteger row = [indexPath row];
    switch (row) {
        case 0:
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.imageView.image = [UIImage imageNamed:@"bg_convenience_addressImage.png"];
            cell.textLabel.text = [NSString stringWithFormat:@"地址：%@",listData.addressString];
            cell.textLabel.numberOfLines = 2;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            break;
        case 1:
        {
            if ([listData.telephoneString length]==0) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = [NSString stringWithFormat:@"电话：%@",@"暂无"];
            }else{
                cell.textLabel.text = [NSString stringWithFormat:@"电话：%@",listData.telephoneString];
            }
            cell.imageView.image = [UIImage imageNamed:@"bg_convenience_telImage.png"];
        }
            break;
        case 2:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            int grade = [listData.avg_ratingString intValue];
            UIImage *starImage = [UIImage imageNamed:@"bg_convenience_normalStar.png"];
            for (int i=0; i<5; i++) {
                UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(22*i+30, (cell.frame.size.height-starImage.size.height)/2, starImage.size.width, starImage.size.height)];
                if (i<=(grade-1)) {
                    [starImageView setImage:[UIImage imageNamed:@"bg_convenience_highStar.png"]];
                }else{
                    [starImageView setImage:[UIImage imageNamed:@"bg_convenience_normalStar.png"]];
                }
                [cell addSubview:starImageView];
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark UITableViewDelegate implementation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        if ([listData.telephoneString length]!=0) {
            UIActionSheet* mySheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString stringWithFormat:@"拨打电话：%@",listData.telephoneString] otherButtonTitles:nil, nil];
            [mySheet showInView:[UIApplication sharedApplication].keyWindow];
            [mySheet release];
        }
    }else if(indexPath.row == 2){
        ConvenienceBusinessWebViewController *webViewController = [[ConvenienceBusinessWebViewController alloc] init];
        webViewController.businessString = listData.business_urlString;
        [self.navigationController pushViewController:webViewController animated:YES];
        [webViewController release];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int result;
    if (indexPath.row == 0) {
        result = 65;
    }else{
        result = 45;
    }
    return result;
}
//选择照相，或者照片库
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0) {
        NSString *msg;
        
        BOOL call_ok = [self makeCall:listData.telephoneString];
        if (call_ok) {
            
        }else{
            msg=@"设备不支持电话功能";
            [self alertWithFistButton:@"确定" SencodButton:nil Message:msg];
        }
    }
}

- (BOOL) makeCall:(NSString *)phoneNumber
{
    if (phoneNumber==nil ||[phoneNumber isEqualToString:@""])
    {
        return NO;
    }
    BOOL call_ok = false;
    NSString *numberAfterClear = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", numberAfterClear]];
    NSLog(@"make call, URL=%@", phoneNumberURL);
    
    call_ok = [[UIApplication sharedApplication] canOpenURL:phoneNumberURL];
    if (call_ok) {
        if ( !_phoneCallWebView ) {
            _phoneCallWebView = [[UIWebView alloc]initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来 效果跟方法二一样 但是这个方法是合法的
        }
        [_phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneNumberURL]];
        [self.view addSubview:_phoneCallWebView];
    }
    
    return call_ok;
}
@end
