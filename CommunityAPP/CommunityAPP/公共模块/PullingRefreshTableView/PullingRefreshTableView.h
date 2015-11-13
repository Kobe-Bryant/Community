//
//  PullingRefreshTableView.h
//  PullingTableView
//
//  Created by danal on 3/6/12.If you want use it,please leave my name here
//  Copyright (c) 2012 danal Luo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    leftSide,
    reghtSide,
}SlideSide;

typedef enum {
  kPRStateNormal = 0,
  kPRStatePulling = 1,
  kPRStateLoading = 2,
  kPRStateHitTheEnd = 3
} PRState;

typedef enum {
  bothOfThem = 0,    //下拉刷新，上拉加载更多
  headerOnly = 1,    //仅下拉刷新
  footerOnly = 2,    //仅上拉加载更多
  noneOfThen = 3     //都没有
} PullingType;

@interface LoadingView : UIView {
  UILabel *_stateLabel;
  UILabel *_dateLabel;
  UIImageView *_arrowView;
  UIActivityIndicatorView *_activityView;
  CALayer *_arrow;
  BOOL _loading;
  NSMutableDictionary *_textDictionary;
}
@property (nonatomic,getter = isLoading) BOOL loading;    
@property (nonatomic,getter = isAtTop) BOOL atTop;
@property (nonatomic) PRState state;
@property (nonatomic,retain) NSMutableDictionary *textDictionary;

- (id)initWithFrame:(CGRect)frame atTop:(BOOL)top;
- (void)initDictionaryWithStringArray:(NSArray *)aArray;
- (void)updateRefreshDate:(NSDate *)date;

@end

@protocol PullingRefreshTableViewDelegate;

@interface PullingRefreshTableView : UITableView{
    LoadingView *_headerView;
    LoadingView *_footerView;
    UILabel *_msgLabel;
    BOOL _loading;
    BOOL _isFooterInAction;
    BOOL _isUseCostomText;
    NSDate *_date;
}

@property (assign,nonatomic) id <PullingRefreshTableViewDelegate> pullingDelegate;
@property (nonatomic) BOOL autoScrollToNextPage;
@property (nonatomic) BOOL reachedTheEnd;
@property (nonatomic,setter = setPullingType:) PullingType pullingType;     //可以随时改变值,改变显示效果
@property (nonatomic) BOOL refreshing;
@property (assign,nonatomic) NSInteger page;


/*初始化*/
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style pullingDelegate:(id<PullingRefreshTableViewDelegate>)aPullingDelegate;
//- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style PullingType:(PullingType)pullingType;

/*设置显示文字，默认为:@"下拉刷新",@"释放刷新",@"正在刷新",@"上拉加载",@"释放加载",@"正在加载"*/
- (void)setRefreshTextWithStringArray:(NSArray *)aArray;

/*UIScrollView代理*/
- (void)tableViewDidScroll:(UIScrollView *)scrollView;
- (void)tableViewDidEndDragging:(UIScrollView *)scrollView;

/*得到数据后，退出正在刷新或加载界面*/
- (void)tableViewDidFinishedLoading;

- (void)tableViewDidFinishedLoadingWithMessage:(NSString *)msg;

/**/
- (void)launchRefreshing;

@end



@protocol PullingRefreshTableViewDelegate <NSObject>

@optional
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView;

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView;

- (void)gestureSlideSide:(SlideSide)side;

@end


