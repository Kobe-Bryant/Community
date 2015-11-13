//
//  CMActionSheet.m
//  CMActionSheet
//
//  Created by Stone on 14-4-20.
//  Copyright (c) 2014年 Stone. All rights reserved.
//

#import "CMActionSheet.h"
#import <QuartzCore/QuartzCore.h>
#import "CMActionSheetCell.h"
#define itemPerPage 6

#define kHeaderHeight 30
#define kBodyHeight 
#define kFooterHeight   85
#define ScreenWidth    320

@interface CMActionSheet()<UIScrollViewDelegate>
@property (nonatomic, retain)UIView *headView;
@property (nonatomic, retain)UIView *footView;
@property (nonatomic, retain)UIScrollView* scrollView;
@property (nonatomic, retain)UIPageControl* pageControl;
@property (nonatomic, retain)NSMutableArray* items;
@property (nonatomic, assign)id<CMActionSheetDelegate> IconDelegate;
@property (nonatomic, retain)UIView *coverView;
@property (nonatomic, retain)UIButton *cancelButton;

@property (nonatomic, retain) UIView *parentView;
@end


@implementation CMActionSheet
@synthesize headView;
@synthesize footView;
@synthesize scrollView;
@synthesize pageControl;
@synthesize items;
@synthesize IconDelegate;
@synthesize coverView;
@synthesize cancelButton;
@synthesize delegate = _delegate;
-(void)dealloc
{
     [super dealloc];
}


-(id)initwithIconSheetDelegate:(id<CMActionSheetDelegate>)delegate ItemCount:(int)cout
{
    int rowCount = 2;
    if (cout <=3) {
        rowCount = 1;
    } else if (cout <=6) {
        rowCount = 2;
    }
    self = [super init];
    if (self) {
        coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        coverView.backgroundColor = [UIColor colorWithRed:51.0f/255 green:51.0f/255 blue:51.0f/255 alpha:0.6f];
        coverView.hidden = YES;
        
        [self addSubview:self.headView];
        
        self.backgroundColor = [UIColor whiteColor];
        IconDelegate = delegate;
        self.scrollView = [[[UIScrollView alloc] initWithFrame:CGRectZero] autorelease];
        [scrollView setPagingEnabled:YES];
        [scrollView setBackgroundColor:[UIColor clearColor]];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setDelegate:self];
        [scrollView setScrollEnabled:YES];
        [scrollView setBounces:NO];
        
        [self addSubview:scrollView];
        
        [self addSubview:self.footView];
        
        self.items = [[[NSMutableArray alloc] initWithCapacity:cout] autorelease];
        
    }
    return self;
}

- (UIView*)footView{
    if (footView == nil) {
        footView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kFooterHeight)] autorelease];
        self.pageControl = [[[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 320, 20)] autorelease];
        [pageControl setNumberOfPages:0];
        [pageControl setCurrentPage:0];
        [pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
        pageControl.pageIndicatorTintColor = [UIColor colorWithRed:193./255. green:193./255. blue:193./255 alpha:1.0];
        pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:140./255. green:140./255. blue:140./255 alpha:1.0];
        [footView addSubview:pageControl];
        
        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(22, 23, 276, 40);
        [cancelButton setBackgroundColor:[UIColor colorWithRed:193./255. green:193./255. blue:193./255 alpha:1.0]];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:cancelButton];
    }
    
    return footView;
}

- (UIView*)headView{
    if (headView == nil) {
        headView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kHeaderHeight)] autorelease];
        
        UILabel *sharelabel = [[UILabel alloc]initWithFrame:CGRectMake(130.f, 10.f, 60.f, 20.f)];
        sharelabel.backgroundColor = [UIColor clearColor];
        sharelabel.textColor = [UIColor grayColor];
        sharelabel.font = [UIFont systemFontOfSize:12];
        sharelabel.text = @"分享到";
        sharelabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:sharelabel];
        [sharelabel release];
        
        
        //横线
        UIView *leftLine = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 18.0f, 120.0f, 1.f)];
        leftLine.backgroundColor = [UIColor colorWithRed:204.f/255.f green:204.f/255.f blue:204.f/255.f alpha:1.f];
        [headView addSubview:leftLine];
        [leftLine release];
        
        //横线
        UIView *rightLine = [[UIView alloc]initWithFrame:CGRectMake(200.0f, 18.0f, 130.0f, 1.f)];
        rightLine.backgroundColor = [UIColor colorWithRed:204.f/255.f green:204.f/255.f blue:204.f/255.f alpha:1.f];
        [headView addSubview:rightLine];
        [rightLine release];
    }
    
    return headView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)showInView:(UIView *)view
{
    self.parentView = view;
    [self reloadData];
    [view addSubview:coverView];
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0.0f, self.frame.origin.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
                         coverView.hidden = NO;
                     } completion:^(BOOL finished) {
                         
                     }];
}



- (void)reloadData
{
    for (CMActionSheetCell* cell in items) {
        [cell removeFromSuperview];
        [items removeObject:cell];
    }

    
    int count = [IconDelegate numberOfItemsInActionSheet];
    
    if (count <= 0) {
        return;
    }
    
    int rowCount = 2;
    
    if (count <= 3) {
        [scrollView setFrame:CGRectMake(0, kHeaderHeight, 320, 105)];
        rowCount = 1;
    } else {
        [scrollView setFrame:CGRectMake(0, kHeaderHeight, 320, 210)];
        rowCount = 2;
    }
    [scrollView setContentSize:CGSizeMake(320*(count/itemPerPage+1), scrollView.frame.size.height)];
    [pageControl setNumberOfPages:count/itemPerPage+1];
    [pageControl setCurrentPage:0];
    
    CGFloat height = kHeaderHeight+CGRectGetHeight(scrollView.frame)+kFooterHeight;
    CGFloat originY = CGRectGetHeight(self.parentView.frame);
    self.frame = CGRectMake(0, originY, self.parentView.frame.size.width,height);
    self.footView.frame = CGRectMake(0, CGRectGetMaxY(scrollView.frame), self.bounds.size.width, kFooterHeight);
    
    for (int i = 0; i< count; i++) {
        CMActionSheetCell* cell = [IconDelegate cellForActionAtIndex:i];
        int PageNo = i/itemPerPage;
        //        NSLog(@"page %d",PageNo);
        int index  = i%itemPerPage;
        
        if (itemPerPage == 6) {
            
            int row = index/3;
            int column = index%3;
            
            
            float centerY = (1+row*2)*self.scrollView.frame.size.height/(2*rowCount);
            float centerX = (1+column*2)*self.scrollView.frame.size.width/6;
            
            //            NSLog(@"%f %f",centerX+320*PageNo,centerY);
            
            [cell setCenter:CGPointMake(centerX+320*PageNo, centerY)];
            [self.scrollView addSubview:cell];
            
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionForItem:)];
            [cell addGestureRecognizer:tap];
            [tap release];
            
            //            [cell.iconView addTarget:self action:@selector(actionForItem:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        [items addObject:cell];
    }
    
}

- (void)actionForItem:(UITapGestureRecognizer*)recongizer
{
    CMActionSheetCell* cell = (CMActionSheetCell*)[recongizer view];
    [IconDelegate DidTapOnItemAtIndex:cell.shareType];

    [self dismiss];
}

- (void)cancel:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(dismissCancle)]) {
        [self.delegate dismissCancle];
    }
    [self dismiss];
}
- (void)dismiss{
    
    
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0.0f, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
                         coverView.hidden = YES;
                     }
                     completion:^(BOOL finished) {
                         [coverView removeFromSuperview];
                         [self removeFromSuperview];
                         _delegate = nil;
                     }];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
- (void)changePage:(id)sender {
    int page = pageControl.currentPage;
    [scrollView setContentOffset:CGPointMake(320 * page, 0)];
}
#pragma mark -
#pragma scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = scrollView.contentOffset.x /320;
    pageControl.currentPage = page;
}




@end
