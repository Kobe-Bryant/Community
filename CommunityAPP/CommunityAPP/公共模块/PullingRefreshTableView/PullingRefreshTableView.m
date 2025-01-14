//
//  PullingRefreshTableView.m
//  PullingTableView
//
//  Created by luo danal on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PullingRefreshTableView.h"
#import <QuartzCore/QuartzCore.h>
#import "Global.h"

#define kPROffsetY 60.f
#define kPRMargin 5.f
#define kPRLabelHeight 20.f
#define kPRLabelWidth 100.f
#define kPRArrowWidth 20.f  
#define kPRArrowHeight 40.f

#define HeaderStatusNormal        @"HeaderStatusNormal"
#define HeaderStatusPulling       @"HeaderStatusPulling"
#define HeaderStatusRelease       @"HeaderStatusRelease"
#define FooterStatusNormal        @"FooterStatusNormal"
#define FooterStatusPulling       @"FooterStatusPulling"
#define FooterStatusRelease       @"FooterStatusRelease"


#define RefreshLabelFont             [UIFont systemFontOfSize:14] 
#define RefreshLabelColor               [UIColor colorWithRed:68.0/255.0  green:49.0/255.0  blue:38.0/255.0  alpha:1.0] 
#define kPRBGColor [UIColor clearColor]

#define kPRAnimationDuration .18f

@interface LoadingView () 
- (void)updateRefreshDate :(NSDate *)date;
- (void)layouts;
@end

@implementation LoadingView
@synthesize atTop = _atTop;
@synthesize state = _state;
@synthesize loading = _loading;
@synthesize textDictionary = _textDictionary;

- (void)dealloc{
  if (_stateLabel) SAFE_RELEASE(_stateLabel);
  if (_dateLabel) SAFE_RELEASE(_dateLabel);
  if (_arrowView) SAFE_RELEASE(_arrowView);
  if (_activityView) SAFE_RELEASE(_activityView);
  if (_textDictionary) SAFE_RELEASE(_textDictionary);
  [super dealloc];
}

- (void)initDictionaryWithStringArray:(NSArray *)aArray{
  if (aArray.count >= 6) {
    if (_textDictionary) SAFE_RELEASE(_textDictionary);
    _textDictionary = [[NSMutableDictionary alloc] initWithObjects:aArray 
                                                           forKeys:[NSArray arrayWithObjects:
                                                                    HeaderStatusNormal,HeaderStatusPulling,HeaderStatusRelease,
                                                                    FooterStatusNormal,FooterStatusPulling,FooterStatusRelease, nil]];
  }
}

- (id)initWithFrame:(CGRect)frame atTop:(BOOL)top {
  self = [super initWithFrame:frame];
  
  [self initDictionaryWithStringArray:[NSArray arrayWithObjects: @"下拉刷新", @"释放刷新",@"正在刷新",@"加载更多",@"释放加载", @"正在加载", nil]];
  
  if (self) {
    self.atTop = top;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = kPRBGColor;
    self.backgroundColor = kPRBGColor;
    _stateLabel = [[UILabel alloc] init ];
    _stateLabel.font = RefreshLabelFont;
    _stateLabel.textColor = RefreshLabelColor;
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    _stateLabel.backgroundColor = kPRBGColor;
    _stateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _stateLabel.text = [_textDictionary objectForKey:HeaderStatusNormal];
    [self addSubview:_stateLabel];
    
    _dateLabel = [[UILabel alloc] init ];
    _dateLabel.font = RefreshLabelFont;
    _dateLabel.textColor = RefreshLabelColor	;
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.backgroundColor = kPRBGColor;
    _dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _dateLabel.text = @"最后更新";
    [self addSubview:_dateLabel];
    
    _arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20) ];
    
    _arrow = [CALayer layer];
    _arrow.frame = CGRectMake(0, 0, 20, 20);
    _arrow.contentsGravity = kCAGravityResizeAspect;
    
    _arrow.contents = (id)[UIImage imageWithCGImage:[UIImage imageNamed:@"blueArrow.png"].CGImage scale:1 orientation:UIImageOrientationDown].CGImage;
    
    [self.layer addSublayer:_arrow];
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:_activityView];
    
    [self layouts];
    
  }
  return self;
}

- (void)layouts {
  
  CGSize size = self.frame.size;
  CGRect stateFrame,dateFrame,arrowFrame;
  
  float x = 0,y,margin;
  //    x = 0;
  margin = (kPROffsetY - 2*kPRLabelHeight)/2;
  if (self.isAtTop) {
    y = size.height - margin - kPRLabelHeight;
    dateFrame = CGRectMake(0,y,size.width,kPRLabelHeight);
    
    y = y - kPRLabelHeight;
    stateFrame = CGRectMake(0, y, size.width, kPRLabelHeight);
    
    
    x = kPRMargin;
    y = size.height - margin - kPRArrowHeight;
    arrowFrame = CGRectMake(4*x, y, kPRArrowWidth, kPRArrowHeight);
    
    UIImage *arrow = [UIImage imageNamed:@"blueArrow"];
    _arrow.contents = (id)arrow.CGImage;
    
  } else {    //at bottom
    y = margin;
    stateFrame = CGRectMake(0, y, size.width, kPRLabelHeight );
    
    y = y + kPRLabelHeight;
    dateFrame = CGRectMake(0, y, size.width, kPRLabelHeight);
    
    x = kPRMargin;
    y = margin;
    arrowFrame = CGRectMake(4*x, y, kPRArrowWidth, kPRArrowHeight);
    
    UIImage *arrow = [UIImage imageNamed:@"blueArrowDown"];        
    _arrow.contents = (id)arrow.CGImage;
    _stateLabel.text = [_textDictionary objectForKey:FooterStatusNormal];
  }
  
  _stateLabel.frame = stateFrame;
  _dateLabel.frame = dateFrame;
  _arrowView.frame = arrowFrame;
  _activityView.center = _arrowView.center;
  _arrow.frame = arrowFrame;
  _arrow.transform = CATransform3DIdentity;
}

- (void)setState:(PRState)state animated:(BOOL)animated{
  float duration = animated ? kPRAnimationDuration : 0.f;
  if (_state != state) {
    _state = state;
    if (_state == kPRStateLoading) {    //Loading
      
      _arrow.hidden = YES;
      _activityView.hidden = NO;
      [_activityView startAnimating];
      
      _loading = YES;
      
      if (self.isAtTop) {
        _stateLabel.text = [_textDictionary objectForKey:HeaderStatusRelease];
      } else {
        _stateLabel.text = [_textDictionary objectForKey:FooterStatusRelease];
      }
      
    } else if (_state == kPRStatePulling && !_loading) {    //Scrolling
      
      _arrow.hidden = NO;
      _activityView.hidden = YES;
      [_activityView stopAnimating];
      
      [CATransaction begin];
      [CATransaction setAnimationDuration:duration];
      _arrow.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
      [CATransaction commit];
      
      if (self.isAtTop) {
        _stateLabel.text = [_textDictionary objectForKey:HeaderStatusPulling];
      } else {
        _stateLabel.text = [_textDictionary objectForKey:FooterStatusPulling];
      }
      
    } else if (_state == kPRStateNormal && !_loading){    //Reset
      _arrow.hidden = NO;
      _activityView.hidden = YES;
      [_activityView stopAnimating];
      
      [CATransaction begin];
      [CATransaction setAnimationDuration:duration];
      _arrow.transform = CATransform3DIdentity;
      [CATransaction commit];
      
      if (self.isAtTop) {
        _stateLabel.text = [_textDictionary objectForKey:HeaderStatusNormal];
      } else {
        _stateLabel.text = [_textDictionary objectForKey:FooterStatusNormal];
      }
    } else if (_state == kPRStateHitTheEnd) {
      if (!self.isAtTop) {    //footer
        _arrow.hidden = YES;
        _stateLabel.text = @"加载完成";
      }
    }
  }else{   
    if (_state == kPRStateNormal && !_loading) {
      _arrow.hidden = NO;
      _activityView.hidden = YES;
      [_activityView stopAnimating];
      [CATransaction begin];
      [CATransaction setAnimationDuration:duration];
      _arrow.transform = CATransform3DIdentity;
      [CATransaction commit];
    }
    //用于切换语言
    if(_state == kPRStateNormal && !_loading){    //Reset
      if (self.isAtTop) {
        _stateLabel.text = [_textDictionary objectForKey:HeaderStatusNormal];
      } else {
        _stateLabel.text = [_textDictionary objectForKey:FooterStatusNormal];
      }
    } else if (_state == kPRStateHitTheEnd) {
      if (!self.isAtTop) {    //footer
        _stateLabel.text = @"加载完成";
      }
    }
  }
}

- (void)setState:(PRState)state {
  [self setState:state animated:YES];
}

- (void)setLoading:(BOOL)loading {
  _loading = loading;
}

- (void)updateRefreshDate :(NSDate *)date{
  NSDateFormatter *df = [[NSDateFormatter alloc] init];
  
    df.dateFormat = @"yyyy-MM-dd HH:mm";
  
  NSString *dateString = [df stringFromDate:date];
  NSString *title = @"今天";
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                             fromDate:date toDate:[NSDate date] options:0];
  int year = [components year];
  int month = [components month];
  int day = [components day];
  if (year == 0 && month == 0 && day < 3) {
    if (day == 0) {
      title = @"今天";
    } else if (day == 1) {
      title = @"昨天";
    } else if (day == 2) {
      title = @"前天";
    }
    df.dateFormat = @"HH:mm";
    dateString = [NSString stringWithFormat:@"%@ %@",title,[df stringFromDate:date]];
  } 
  _dateLabel.text = [NSString stringWithFormat:@"%@: %@",@"最后更新",dateString];
  [df release];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface PullingRefreshTableView ()
- (void)scrollToNextPage;
@end

@implementation PullingRefreshTableView
@synthesize pullingDelegate = _pullingDelegate;
@synthesize autoScrollToNextPage;
@synthesize reachedTheEnd = _reachedTheEnd;
@synthesize pullingType = _pullingType;
@synthesize refreshing;
@synthesize page;

- (void)dealloc {
  [self removeObserver:self forKeyPath:@"contentSize"];
  if (_headerView) SAFE_RELEASE(_headerView);
  if (_footerView) SAFE_RELEASE(_footerView);
  if (_date) SAFE_RELEASE(_date);
  [super dealloc];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if(!self.dragging) {
		[[self nextResponder] touchesBegan:touches withEvent:event];
	}
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if(!self.dragging) {
		[[self nextResponder] touchesEnded:touches withEvent:event];
	}
	[super touchesEnded:touches withEvent:event];
}
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
  self = [super initWithFrame:frame style:style];
  if (self) {
    // Initialization code
    CGRect rect = CGRectMake(0, 0 - frame.size.height, frame.size.width, frame.size.height);
    _headerView = [[LoadingView alloc] initWithFrame:rect atTop:YES];
    _headerView.atTop = YES;
    [self addSubview:_headerView];
    
    rect = CGRectMake(0, frame.size.height, frame.size.width, frame.size.height);
    _footerView = [[LoadingView alloc] initWithFrame:rect atTop:NO];
    _footerView.atTop = NO;
    _date = [[NSDate date] retain];
    [_headerView updateRefreshDate:_date];
    [_footerView updateRefreshDate:_date];
    [self addSubview:_footerView];
    [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];    
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style pullingDelegate:(id<PullingRefreshTableViewDelegate>)aPullingDelegate {
  self = [self initWithFrame:frame style:style];
  if (self) {
      self.refreshing = NO;
    _isUseCostomText = NO;
    self.pullingDelegate = aPullingDelegate;
  }
  return self;
}

//- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style PullingType:(PullingType)pullingType{
//  self = [super initWithFrame:frame style:style];
//  if (self) {
//    // Initialization code
//    _date = [[NSDate date] retain];
//   
//  
//    if (pullingType!=footerOnly) {
//      CGRect rect = CGRectMake(0, 0 - frame.size.height, frame.size.width, frame.size.height);
//      _headerView = [[LoadingView alloc] initWithFrame:rect atTop:YES];
//      _headerView.atTop = YES;
//       [_headerView updateRefreshDate:_date];
//      [self addSubview:_headerView];
//    }
//    if (pullingType!=headerOnly) {
//      CGRect rect = CGRectMake(0, frame.size.height, frame.size.width, frame.size.height);
//      _footerView = [[LoadingView alloc] initWithFrame:rect atTop:NO];
//      _footerView.atTop = NO;
//        [_footerView updateRefreshDate:_date];
//      [self addSubview:_footerView];
//    }
//    [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
//  }
//  return self;
//}

- (void)setReachedTheEnd:(BOOL)reachedTheEnd{
  _reachedTheEnd = reachedTheEnd;
  if (_reachedTheEnd){
    _footerView.state = kPRStateHitTheEnd;
  } else {
    _footerView.state = kPRStateNormal;
  }
}

- (void)setPullingType:(PullingType)type{
  _pullingType = type;
  if (_pullingType == bothOfThem){
    if (_headerView.hidden == YES)_headerView.hidden = NO;
    if (_footerView.hidden == YES)_footerView.hidden = NO;
  }else if (_pullingType == headerOnly){
    if (_headerView.hidden == YES)_headerView.hidden = NO;
    if (_footerView.hidden == NO)_footerView.hidden = YES;
  }else if (_pullingType == footerOnly){
    if (_headerView.hidden == NO)_headerView.hidden = YES;
    if (_footerView.hidden == YES)_footerView.hidden = NO;
  }else if(_pullingType == noneOfThen){
    if (_headerView.hidden == NO)_headerView.hidden = YES;
    if (_footerView.hidden == NO)_footerView.hidden = YES;
  }
}

- (void)setRefreshTextWithStringArray:(NSArray *)aArray{
  _isUseCostomText = YES;
  [_headerView initDictionaryWithStringArray:aArray];
  [_footerView initDictionaryWithStringArray:aArray];
}

#pragma mark ---- 手势 ----
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [super touchesBegan:touches withEvent:event];
//    NSLog(@"---touchesBegan---");
//}

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//
//}

#pragma mark - Scroll methods

- (void)scrollToNextPage {
  float h = self.frame.size.height;
  float y = self.contentOffset.y + h;
  y = y > self.contentSize.height ? self.contentSize.height : y;
  self.contentOffset = CGPointMake(0, y);  
}

- (void)tableViewDidScroll:(UIScrollView *)scrollView {
  if (_headerView.state == kPRStateLoading || _footerView.state == kPRStateLoading) {
    return;
  }
  
  CGPoint offset = scrollView.contentOffset;
  CGSize size = scrollView.frame.size;
  CGSize contentSize = scrollView.contentSize;
  
  float yMargin = offset.y + size.height - contentSize.height;
  if (offset.y < -kPROffsetY) {   //header totally appeard
    _headerView.state = kPRStatePulling;
  } else if (offset.y > -kPROffsetY && offset.y < 0){ //header part appeared
    _headerView.state = kPRStateNormal;
    
  } else if ( yMargin > kPROffsetY){  //footer totally appeared
    if (_footerView.state != kPRStateHitTheEnd) {
      _footerView.state = kPRStatePulling;
    }
  } else if ( yMargin < kPROffsetY && yMargin > 0) {//footer part appeared
    if (_footerView.state != kPRStateHitTheEnd) {
      _footerView.state = kPRStateNormal;
    }
  }
}

- (void)tableViewDidEndDragging:(UIScrollView *)scrollView {
  if (_headerView.state == kPRStateLoading || _footerView.state == kPRStateLoading) {
    return;
  }
  if (_headerView.state == kPRStatePulling) {
    if (self.pullingType == footerOnly || self.pullingType == noneOfThen) {
      return;
    }
    _isFooterInAction = NO;
    _headerView.state = kPRStateLoading;
    
    [UIView animateWithDuration:kPRAnimationDuration animations:^{
      self.contentInset = UIEdgeInsetsMake(kPROffsetY, 0, 0, 0);
    }];
    if (_pullingDelegate && [_pullingDelegate respondsToSelector:@selector(pullingTableViewDidStartRefreshing:)]) {
      [_pullingDelegate pullingTableViewDidStartRefreshing:self];
    }
  } else if (_footerView.state == kPRStatePulling) {
    if (self.reachedTheEnd || self.pullingType == headerOnly || self.pullingType ==noneOfThen) {
      return;
    }
    _isFooterInAction = YES;
    _footerView.state = kPRStateLoading;
    [UIView animateWithDuration:kPRAnimationDuration animations:^{
      self.contentInset = UIEdgeInsetsMake(0, 0, kPROffsetY, 0);
    }];
    if (_pullingDelegate && [_pullingDelegate respondsToSelector:@selector(pullingTableViewDidStartLoading:)]) {
      [_pullingDelegate pullingTableViewDidStartLoading:self];
    }
  }
//  [self performSelector:@selector(tableViewDidFinishedLoading) withObject:nil afterDelay:5.0f];
}

- (void)tableViewDidFinishedLoading {
  [self tableViewDidFinishedLoadingWithMessage:nil];  
}

- (void)flashMessage:(NSString *)msg{
  __block CGRect rect = CGRectMake(0, self.contentOffset.y - 20, self.bounds.size.width, 20);
  
  if (_msgLabel == nil) {
    _msgLabel = [[UILabel alloc] init];
    _msgLabel.frame = rect;
    _msgLabel.font = [UIFont systemFontOfSize:14.f];
    _msgLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _msgLabel.backgroundColor = [UIColor orangeColor];
    _msgLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_msgLabel];    
  }
  _msgLabel.text = msg;
  rect.origin.y += 20;
  [UIView animateWithDuration:.4f animations:^{
    _msgLabel.frame = rect;
  } completion:^(BOOL finished){
    rect.origin.y -= 20;
    [UIView animateWithDuration:.4f delay:1.2f options:UIViewAnimationOptionCurveLinear animations:^{
      _msgLabel.frame = rect;
    } completion:^(BOOL finished){
      [_msgLabel removeFromSuperview];
      _msgLabel = nil;            
    }];
  }];
}

- (void)tableViewDidFinishedLoadingWithMessage:(NSString *)msg{
  if (_headerView.loading) {
    _headerView.loading = NO;
    [_headerView setState:kPRStateNormal animated:NO];
    if (_date) SAFE_RELEASE(_date);
    _date = [[NSDate date] retain];
    [_headerView updateRefreshDate:_date];
    [UIView animateWithDuration:kPRAnimationDuration*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
      self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } completion:^(BOOL bl){
      if (msg != nil && ![msg isEqualToString:@""]) {
        [self flashMessage:msg];
      }
    }];
  }
  else if (_footerView.loading) {
    _footerView.loading = NO;
    [_footerView setState:kPRStateNormal animated:NO];
    
    if (_date) SAFE_RELEASE(_date);
    _date = [[NSDate date] retain];
    [_footerView updateRefreshDate:_date];
    
    [UIView animateWithDuration:kPRAnimationDuration animations:^{
      self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } completion:^(BOOL bl){
      if (msg != nil && ![msg isEqualToString:@""]) {
        [self flashMessage:msg];
      }
    }];
  }
}

- (void)launchRefreshing {
  [self setContentOffset:CGPointMake(0,0) animated:NO];
  [UIView animateWithDuration:kPRAnimationDuration animations:^{
    self.contentOffset = CGPointMake(0, -kPROffsetY-1);
  } completion:^(BOOL bl){
    [self tableViewDidEndDragging:self];
  }];
}

#pragma mark - 

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  CGRect frame = _footerView.frame;
  CGSize contentSize = self.contentSize;
  frame.origin.y = contentSize.height < self.frame.size.height ? self.frame.size.height : contentSize.height;
  _footerView.frame = frame;
  if (self.autoScrollToNextPage && _isFooterInAction) {
    [self scrollToNextPage];
    _isFooterInAction = NO;
  } else if (_isFooterInAction) {
//    CGPoint offset = self.contentOffset;
//    offset.y += 44.f;
//    self.contentOffset = offset;
//     NSLog(@"----_isFooterInAction---offset-%f",offset.y);
  }
}

@end
