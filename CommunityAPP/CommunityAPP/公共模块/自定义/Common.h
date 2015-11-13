//
//  Common.h
//  WoNiuKeke
//
//  Created by Vincent. on 13-10-31.
//  Copyright (c) 2013年 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

//MBProgressHud
#define HUD_VIEW_WIDTH 200
#define HUD_VIEW_HEIGHT 100

//参数缓存时效
#define expire_param_time 3600 * 8
#define expire_photo_time -1
#define expire_tempparam_time 300
#define expire_halfhour_time 1800

#define page_size_default 16
#define page_size_default_ipad 15

//常用常量定义
#define iphone_keyboard_height 260.0f
#define mbprogresshudview_showtime 1.0f
#define failed_hint_showtime 1.5f
#define tabbar_item_voffset -3.0


//视图切换
#define FROMLEFT 0
#define FROMRIGHT 1

//日志输出
#define LOG_CONTENT_FORMAT @"Function:%s Msg:%@"

#ifdef DEBUG
#define DLog(...) NSLog(__VA_ARGS__)
#else
#define DLog(...)
#endif

#define GLog(...) NSLog(__VA_ARGS__)

#define FAIL_WAIT_TIME 2

#define Notification_AddGestureRecognizer @"AddGestureRecognizer"
#define Notification_RemoveGestureRecognizer @"RemoveGestureRecognizer"

@interface Common : NSObject

//get statusbar height
+ (NSInteger) getStatusBarHeight;
//获取应用内view的rect，x,y从0开始
+ (CGRect) getViewFrameInApp:(UIView *)view;
+ (CGRect) getAppFrame;
+ (CGRect) getAppFrameByOrientation;
//判断是否retina显示屏
+ (BOOL) isRetinaDisplay;
//判断是否iPad
+ (BOOL) isPad;
//获取当前设备方向
+ (UIDeviceOrientation) currentOrientation;
+ (UIInterfaceOrientation) statusBarOrientation;

+ (NSString *) getStoryboardName;
+ (UIStoryboard *) getStoryboardInstance;
+ (NSString *) getStoryboardNameForUniversalApp;
+ (UIStoryboard *) getStoryboardInstanceForUniversalApp;
+ (UIViewController *) getViewControllerByIndentifier:(NSString *)indentifier;
//创建分隔线ImageView
+ (UIImageView *) createImageViewByRect:(CGRect)rect Color:(UIColor *)color;
//Base64
+ (NSString *) getBase64FromFile:(NSString *)filePath;
//隐藏多余的行
+ (void) setExtraCellLineHidden:(UITableView *)tabView;
//日期与字符串格式转换
+ (NSDate *) dateFromString:(NSString *)dateString;
+ (NSString *) stringFromDate:(NSDate *)date;
+ (NSString *) localstringFromDate:(NSDate *)date Formatter:(NSString *)formatter;
//保存在本地
+ (void) saveStringForKey:(NSString *)aKey Value:(NSString *)aValue;
+ (void) saveBoolForKey:(NSString *)aKey Value:(BOOL)aValue;
+ (void) saveIntegerForKey:(NSString *)aKey Value:(NSInteger)aValue;
+ (NSString *) loadKeyValue:(NSString *)aKey;
//showmessage
+ (void) showMessage: (NSString *)aTitle showInfo: (NSString *)aMsg WithDelegate: (id) aDelegate;
+ (void) showMessage: (NSString *)aTitle showInfo: (NSString *)aMsg WithDelegate: (id) aDelegate Tag:(NSInteger)tag;
//显示多个内容进行选择
+ (void) showMultiMessage:(NSArray *)aryMessage Title:(NSString *)title Delegate:(id)delegate;

+ (NSString *) Trim:(NSString *)target;
+ (NSString *) MD5:(NSString *)str;
+ (NSString *) intervalSinceNow: (NSString *) theDate;

//关闭视图的键盘
+ (void) resignKeyBoardInView:(UIView *)pv;

//show HudView
+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg ShowTime:(CGFloat)showtime;
+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg ShowTime:(CGFloat)showtime LeftOffset:(NSInteger)leftOffset;
+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg;
+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg VisibleRect:(CGRect)vRect;
+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg LeftOffset:(NSInteger)leftOffset;
+ (MBProgressHUD *) showMBProgressHudHint:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg ShowTime:(CGFloat)showtime;
//去除浮点数的小数点后未尾的0
+(NSString *)priceRemoveZero:(CGFloat)f;

//视图切换
+(void)showView:(UIView *)sview toView:(UIView *)cview withSuperView:(UIView *)superView withDirection:(NSInteger)direction;

//取搜索历史记录
+ (NSArray *) getSearchHistoryByKey:(NSString *)aKey;
//增加搜索历史记录
+ (void) addSearchHistory:(NSString *)aValue historyKey:(NSString *)hsitoryKey;
//清空搜索历史记录
+ (void) clearSearchHistoryByKey:(NSString *)historyKey;
//添加用户操作日志到日志列表
+ (void) addUserOperateLog:(NSInteger)functionCode Remark:(NSString *)remark;
//拨打电话
+ (BOOL) callPhone:(NSString *)phoneNumber;
//打开url
+ (BOOL) openURL:(NSString *)url;

//判断文件是否存在
+ (BOOL) fileIsExists:(NSString *)filePath;

+ (void) scrollToLastCell:(UITableView *)tabView Section:(NSInteger)section Row:(NSInteger)row ScrollPosition:(UITableViewScrollPosition)position;

//当天返回时间，否则返回日期
+ (NSString *) getSpecialFormatDateTime:(NSString *)date;

//根据uimage获取相应比例的size
+ (CGSize) getScaleImageSize:(UIImage *)image MaxWidth:(NSInteger)maxWidth MaxHeight:(NSInteger)maxHeight;

//Base64编码 UIImage -> NSString
+ (NSString *) imageToBase64String:(UIImage *)image;

+ (void) showMessage:(NSString *)aTitle ShowInfo:(NSString *)aMsg WithDelegate:(id)sender ShowCancelButton:(BOOL)showCancelButton Tag:(NSInteger)tag ;

// 判断是否为价格
+ (BOOL) isValidatePriceRegularExpression:(NSString *)strExpression;

// 获取拼音
+ (NSString *) getPinYin:(NSString *)chineseString;
@end

//y
@protocol showMessageDelegate <NSObject>

- (void) showhudMessage:(NSString *)msg;
- (void) showhudMessageAndhide:(NSString *)msg;
- (void) hidehudinView;

@end
