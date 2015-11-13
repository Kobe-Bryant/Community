//
//  CommunityIntroduceViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-5.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "CommunityIntroduceViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "CommunityHttpRequest.h"
#import "UIImageView+WebCache.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "DataBaseManager.h"
#import "UserModel.h"
#import "NSObject+Time.h"
#import "UIViewController+NavigationBar.h"
#import "CommunityIntroduceCell.h"
#import "MobClick.h"

@interface CommunityIntroduceViewController ()
{
   NSInteger labHeight;
}

@property (nonatomic, retain) CommunityHttpRequest *request;
@property (nonatomic, retain)NSDictionary *introduceInfo;
@property (nonatomic,retain) UIImageView *headImage;
@property (nonatomic,retain) NSString *nameStr;
@property (nonatomic,retain) NSString *adressStr;
@property (nonatomic,retain) NSString *timeStr;
@property (nonatomic,retain) NSString *developStr;
@property (nonatomic,retain) NSString *communityStr;
@property (nonatomic,retain) NSString *countStr;
@property (nonatomic,retain) NSString *stopStr;
@property (nonatomic,retain) NSString *greenStr;
@property (nonatomic,retain) NSString *volumeStr;

@property (nonatomic, retain) DataBaseManager *dbManager;
@property (nonatomic, retain) NSMutableArray *introduceArray;
@property (nonatomic, retain) NSMutableArray *imgArr;

@end

@implementation CommunityIntroduceViewController
@synthesize request = _request;
@synthesize introduceInfo = _introduceInfo;
@synthesize headImage = _headImage;
@synthesize nameStr = _nameStr;
@synthesize adressStr = _adressStr;
@synthesize timeStr = _timeStr;
@synthesize developStr = _developStr;
@synthesize communityStr = _communityStr;
@synthesize countStr = _countStr;
@synthesize stopStr = _stopStr;
@synthesize greenStr = _greenStr;
@synthesize volumeStr = _volumeStr;
@synthesize dbManager = _dbManager;
@synthesize imgArr = _imgArr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.introduceInfo = [NSMutableDictionary dictionary];
        _imgArr = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)dealloc
{
    [_request cancelDelegate:self];
    [contentScrollView release]; contentScrollView = nil;
    [introTableView release]; introTableView = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"CommunityIntroducePage"]; // 友盟统计
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"CommunityIntroducePage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    self.view.backgroundColor = RGB(244, 244, 244);
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"小区介绍"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    
    //构建tableview视图
    introTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, MainHeight) style:UITableViewStylePlain];
    introTableView.delegate = self;
    introTableView.dataSource = self;
    introTableView.backgroundView = nil;
    introTableView.backgroundColor = [UIColor clearColor];
    introTableView.backgroundView.backgroundColor = RGB(244, 244, 244);
    introTableView.tableHeaderView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 81)] autorelease];
    introTableView.tableFooterView = [[[UIView alloc]initWithFrame:CGRectZero] autorelease];
    [self.view addSubview:introTableView];
    
    //小区图片
    contentScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, -2.5, ScreenWidth, 80)] ;
    contentScrollView.pagingEnabled = YES;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.scrollsToTop = NO;
    [contentScrollView setBackgroundColor:[UIColor clearColor]];
    [introTableView.tableHeaderView addSubview:contentScrollView];
    
    //    add vincent 2014.3.12
    if ([self getCacheUrlString:GlobalCommubityDistrictIntroduced]) {
        _introduceInfo = [self getCacheDataDictionaryString:GlobalCommubityDistrictIntroduced];
        [self refreshintroduceInfo];
    }
    [self requestPersonalInfo];
}

-(void)requestPersonalInfo{
    // 网络请求
    if (_request == nil) {
        _request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    NSString *string = [NSString stringWithFormat:@"?updateTime=%@&userId=%@&communityId=%@&propertyId=%@",DEF_UPDATE_TIME,userModel.userId,userModel.communityId,userModel.propertyId];//参数
    [_request requestCommunityInfo:self parmeters:string];
}
#pragma mark -- uitableviewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 5;
            break;
            
        default:
            break;
    }
    return section;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    static NSString *identifier = @"Cell";
    CommunityIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[CommunityIntroduceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    switch (section) {
        case 0:
            if (row ==0) {
                //cell.textLabel.text = [NSString stringWithFormat:@"名称          %@",_nameStr];
                cell.lable1.text = @"名称";
                cell.lable2.text = _nameStr;
            }
            if (row == 1) {
                CGSize titleSize = [_adressStr sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(230, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                if (_adressStr.length<=16) {
                    labHeight = 18;
                }else{
                    labHeight = titleSize.height+1;
                }
                cell.lable2.frame = CGRectMake(94, 10, 230,labHeight);
                cell.lable1.text = @"地址";
                cell.lable2.text = _adressStr;
            }
            if (row == 2) {
                cell.lable1.text = @"竣工时间";
                cell.lable2.text = _timeStr;
            }
            break;
        case 1:
            if (row ==0) {
                CGSize titleSize = [_developStr sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(230, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                if (_developStr.length<=16) {
                    labHeight = 18;
                }else{
                    labHeight = titleSize.height+1;
                }
                cell.lable2.frame = CGRectMake(94, 10, 230, labHeight);
                cell.lable1.text = @"开发商";
                cell.lable2.text = _developStr;
            }
            break;
        case 2:
            if (row ==0) {
                CGSize titleSize = [_communityStr sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(230, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                if (_communityStr.length<=16) {
                    labHeight = 18;
                }else{
                    labHeight = titleSize.height+1;
                }
                cell.lable2.frame = CGRectMake(94, 10, 230, labHeight);
                cell.lable1.text = @"物业公司";
                cell.lable2.text = _communityStr;
            }
            if (row == 1) {
                cell.lable1.text = @"总户数";
                cell.lable2.text = _countStr;
            }
            if (row == 2) {
                cell.lable1.text = @"停车位";
                cell.lable2.text = _stopStr;
            }
            if (row == 3) {
                cell.lable1.text = @"绿化率";
                cell.lable2.text = _greenStr;
            }
            if (row == 4) {
                cell.lable1.text = @"容积率";
                cell.lable2.text = _volumeStr;
            }
            break;
            
        default:
            break;
      }
    return cell;
}


#pragma mark -- uitableviewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                return 40.0f;
            }else if(indexPath.row == 1){
                CGSize titleSize = [_adressStr sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(230, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            if (_adressStr.length<=16) {
                    return 40.0f;
                }else{
                    return titleSize.height + 21;
                   // return 56.0f;
                }
            }else{
                return 40.0f;
            }
            break;
        case 1:{
            CGSize titleSize = [_developStr sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(230, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            if (_developStr.length<=16) {
                return 40.0f;
            }else{
                return titleSize.height + 21;
            }}
            break;
        case 2:
            if (indexPath.row == 0) {
                CGSize titleSize = [_communityStr sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(230, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                if (_communityStr.length<=16) {
                    return 40.0f;
                }else{
                    return titleSize.height + 21;
                }

            }else{
                return 40.0f;
            }
            break;
            
        default:
            break;
    }

    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.0f;
    }
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *__view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 10.0f)];
    [__view setBackgroundColor:RGB(236, 236, 236)];
    return __view;
}



#pragma mark ------
-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    //NSLog(@"interface :%d status:%d",interface,status);
    if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
        [self.imgArr removeAllObjects];
        _introduceInfo = [data retain];
        
        [self refreshintroduceInfo];
        
        //        add
        [self saveCacheUrlString:GlobalCommubityDistrictIntroduced andNSDictionary:_introduceInfo];
    }else{
        NSLog(@"小区介绍获取失败");
    }
}
- (void)refreshintroduceInfo{
    if (_introduceInfo) {
        _nameStr = [_introduceInfo objectForKey:@"name"];
        _adressStr = [_introduceInfo objectForKey:@"address"];
        _timeStr = [_introduceInfo objectForKey:@"completeDate"];
        _developStr = [_introduceInfo objectForKey:@"developer"];
        _communityStr = [_introduceInfo objectForKey:@"propertyCompany"];
        _countStr = [_introduceInfo objectForKey:@"numberOfFamily"];
        _stopStr = [_introduceInfo objectForKey:@"numberOfParking"];
        _greenStr = [_introduceInfo objectForKey:@"rateOfGreen"];
        _volumeStr = [_introduceInfo objectForKey:@"rateOfVolume"];
        
        [_headImage setImageWithURL:[NSURL URLWithString:[_introduceInfo objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"0.png"]];
        
        NSString *images = [_introduceInfo objectForKey:@"imgs"];
        
        //小区图片
        NSArray *imgAarry = [images componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";"]];
        [self.imgArr addObjectsFromArray:imgAarry];
        
        //每次进来删除
        for (UIView *view in contentScrollView.subviews) {
            [view removeFromSuperview];
        }
        
        for (int i = 0; i<[self.imgArr count]; i++) {
            UIImage *defaultImage = [UIImage imageNamed:@"bg_sample_1.png"];
            CGRect imageframe;
            imageframe.origin.x = 5*(i+1)+defaultImage.size.width*i;
            imageframe.origin.y = 10;
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(4*(i+1)+75*i,6, 75, 75)];
            [imageView setImageWithURL:[NSURL URLWithString:[self.imgArr objectAtIndex:i]] placeholderImage:defaultImage];//网络请求图片
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [contentScrollView addSubview:imageView];
            [imageView release];
        }
        contentScrollView.contentSize = CGSizeMake([self.imgArr count]*80+5,80);
    }
    [introTableView reloadData];
}
//导航栏左边按钮
-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    NSString *images = [_introduceInfo objectForKey:@"imgs"];
    //小区图片
    NSArray *imageArry = [images componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";"]];
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:imageArry.count];
    for (int i = 0; i<self.imgArr.count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:[imageArry objectAtIndex:i]]; // 图片路径
        photo.srcImageView = contentScrollView.subviews[i]; // 来源于哪个UIImageView
        [photos addObject:photo];
        [photo release];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[[MJPhotoBrowser alloc] init] autorelease];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}


@end
