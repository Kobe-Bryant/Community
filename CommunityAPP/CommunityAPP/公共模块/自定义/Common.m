//
//  Common.m
//  WoNiuKeke
//
//  Created by Vincent. on 13-10-31.
//  Copyright (c) 2013年 Vincent. All rights reserved.
//

#import "Common.h"
#import <QuartzCore/QuartzCore.h>
#import <CommonCrypto/CommonDigest.h>
#import "CTMBase64.h"
#import "pinyin.h"

@implementation Common

+ (CGRect) getViewFrameInApp:(UIView *)view {
    CGRect appRect = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    return appRect;
}

+ (CGRect) getAppFrame {
    return [[UIScreen mainScreen] applicationFrame];
}

+ (CGRect) getAppFrameByOrientation {
    UIInterfaceOrientation orientation = [self statusBarOrientation];
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    if (orientation == UIInterfaceOrientationLandscapeLeft | orientation == UIInterfaceOrientationLandscapeRight) {
        return CGRectMake(rect.origin.x, rect.origin.y, rect.size.height, rect.size.width);
    }
    else {
        return rect;
    }
}

+ (NSInteger) getStatusBarHeight {
    CGRect statusBarRect = [[UIApplication sharedApplication] statusBarFrame];
    return statusBarRect.size.height < statusBarRect.size.width ? statusBarRect.size.height : statusBarRect.size.width;
}

+ (BOOL) isPad {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (BOOL) isRetinaDisplay
{
    static float scale = 0.0f;
    if (0.0f == scale)
    {
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0))
        {
            scale = 2.0;
            return YES;
        }
        else
        {
            scale = 1.0;
            return NO;
        }
    }
    return scale > 1.0;
}

+ (UIDeviceOrientation) currentOrientation {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    return orientation;
}

+ (UIInterfaceOrientation) statusBarOrientation {
    return [[UIApplication sharedApplication] statusBarOrientation];
}

+ (NSString *) getStoryboardName
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        return @"MainStoryboard";
    }
    else
    {
        return @"MainStoryboard";
    }
    
}

+ (UIStoryboard *) getStoryboardInstance {
    NSString *storyboardName = [self getStoryboardName];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    return storyboard;
}

+ (NSString *) getStoryboardNameForUniversalApp {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return @"MainStoryboard_iPhone";
    }
    else {
        return @"MainStoryboard_iPad";
    }
}

+ (UIStoryboard *) getStoryboardInstanceForUniversalApp {
    NSString *storyboardName = [self getStoryboardNameForUniversalApp];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    return storyboard;
}

+ (UIViewController *) getViewControllerByIndentifier:(NSString *)indentifier {
    UIStoryboard *storyBoard = [self getStoryboardInstance];
    UIViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:indentifier];
    return viewController;
}

+ (UIImageView *) createImageViewByRect:(CGRect)rect Color:(UIColor *)color {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setBackgroundColor:color];
    [imageView setFrame:rect];
    [imageView release]; //add vincent 内存释放
    return imageView;
}

+ (NSString *) getBase64FromFile:(NSString *)filePath {
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSString *base64String = [CTMBase64 stringByEncodingData:fileData];
    return base64String;
}

+ (void) setExtraCellLineHidden:(UITableView *)tabView
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tabView setTableFooterView:view];
    [view release];//add vincent 内存释放
}

+ (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    [dateFormatter release];//add vincent 内存释放
    return destDate;
}

+ (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    [dateFormatter release];//add vincent 内存释放
    return destDateString;
}

+ (NSString *) localstringFromDate:(NSDate *)date Formatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    [dateFormatter release];//add vincent 内存释放
    return destDateString;
}

+ (void) saveStringForKey:(NSString *)aKey Value:(NSString *)aValue
{
    NSUserDefaults *userStore = [NSUserDefaults standardUserDefaults];
    [userStore setObject:aValue forKey:aKey];
}

+ (void) saveBoolForKey:(NSString *)aKey Value:(BOOL)aValue {
    NSUserDefaults *userStore = [NSUserDefaults standardUserDefaults];
    [userStore setBool:aValue forKey:aKey];
}

+ (void) saveIntegerForKey:(NSString *)aKey Value:(NSInteger)aValue {
    NSUserDefaults *userStore = [NSUserDefaults standardUserDefaults];
    [userStore setObject:[NSNumber numberWithInteger:aValue] forKey:aKey];
}

+ (NSString *) loadKeyValue:(NSString *)aKey
{
    NSUserDefaults *userStore = [NSUserDefaults standardUserDefaults];
    NSString *aValue = [userStore stringForKey:aKey];
    if (aValue == nil) {
        aValue = @"";
    }
    return aValue;
}

+ (NSString *) MD5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *) Trim:(NSString *)target
{
    NSString *tmp = [target stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return tmp;
}

//利用时间戳来准确计算某个时间点具现在的时间差，可以参考 CocoaChina 会员 “” 分享的下面这段代码
+ (NSString *) intervalSinceNow: (NSString *) theDate
{
    if ([theDate isEqualToString:@""]) {
        return @"";
    }
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    [date release];//add vincent 内存释放
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString = @"";
    
    NSTimeInterval cha = now-late;
    
    if (cha/3600 < 1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length - 7];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        
    }
    if (cha/3600 > 1 && cha/86400 < 1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length - 7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length - 7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
        
    }
    
    return timeString;
}

+ (void) showMessage: (NSString *)aTitle showInfo: (NSString *)aMsg
        WithDelegate: (id) aDelegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:aTitle message:aMsg delegate:aDelegate cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ];
    [alert show];
    [alert release];
}

+ (void) showMessage: (NSString *)aTitle showInfo: (NSString *)aMsg
        WithDelegate: (id) aDelegate Tag:(NSInteger)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:aTitle message:aMsg delegate:aDelegate cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ];
    [alert setTag:tag];
    [alert show];
    [alert release];
}

+ (void) showMultiMessage:(NSArray *)aryMessage Title:(NSString *)title Delegate:(id)delegate {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    for (NSString *btnTitle in aryMessage) {
        [alert addButtonWithTitle:btnTitle];
    }
    [alert show];
    [alert release];
}

+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg ShowTime:(CGFloat)showtime {
    MBProgressHUD *hudView;
    if ([self isPad]) {
        CGRect rect = superView.bounds;
        rect.origin.x = rect.size.width / 2 - HUD_VIEW_WIDTH / 2;
        rect.origin.y = rect.size.height / 2 - HUD_VIEW_HEIGHT / 2;
        rect.size.width = HUD_VIEW_WIDTH;
        rect.size.height = HUD_VIEW_HEIGHT;
        hudView = [[MBProgressHUD alloc] initWithFrame:rect];
        hudView.userInteractionEnabled = NO;
        [superView addSubview:hudView];
    }else {
        hudView = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    }
    
    hudView.delegate = sender;
    
    hudView.mode = MBProgressHUDModeText;
    hudView.labelText = msg;
    hudView.margin = 10.f;
    //hudView.yOffset = 150.f;
    
    [hudView show:YES];
    [hudView hide:YES afterDelay:showtime];
    return hudView;
}

+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg ShowTime:(CGFloat)showtime LeftOffset:(NSInteger)leftOffset {
    MBProgressHUD *hudView;
    if ([self isPad]) {
        CGRect rect = superView.bounds;
        rect.origin.x = rect.size.width / 2 - HUD_VIEW_WIDTH / 2 - leftOffset;
        rect.origin.y = rect.size.height / 2 - HUD_VIEW_HEIGHT / 2;
        rect.size.width = HUD_VIEW_WIDTH;
        rect.size.height = HUD_VIEW_HEIGHT;
        hudView = [[MBProgressHUD alloc] initWithFrame:rect];
        hudView.userInteractionEnabled = NO;
        [superView addSubview:hudView];
    }else {
        hudView = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    }
    
    hudView.delegate = sender;
    
    hudView.mode = MBProgressHUDModeText;
    hudView.labelText = msg;
    hudView.margin = 10.f;
    //hudView.yOffset = 150.f;
    
    [hudView show:YES];
    [hudView hide:YES afterDelay:showtime];
    return hudView;
}

+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg {
    MBProgressHUD *hudView;
    if ([self isPad]) {
        CGRect rect = superView.bounds;
        rect.origin.x = rect.size.width / 2 - HUD_VIEW_WIDTH / 2;
        rect.origin.y = rect.size.height / 2 - HUD_VIEW_HEIGHT / 2;
        rect.size.width = HUD_VIEW_WIDTH;
        rect.size.height = HUD_VIEW_HEIGHT;
        hudView = [[MBProgressHUD alloc] initWithFrame:rect];
        hudView.userInteractionEnabled = NO;
        [superView addSubview:hudView];
    }else {
        CGRect rect = superView.bounds;
        rect.origin.x = rect.size.width / 2 - HUD_VIEW_WIDTH / 2;
        rect.origin.y = rect.size.height / 2 - HUD_VIEW_HEIGHT / 2;
        rect.size.width = HUD_VIEW_WIDTH;
        rect.size.height = HUD_VIEW_HEIGHT;
        hudView = [[MBProgressHUD alloc] initWithFrame:rect];
        hudView.userInteractionEnabled = NO;
        [superView addSubview:hudView];
        //hudView = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    }
    
    hudView.delegate = sender;
    
    hudView.mode = MBProgressHUDModeIndeterminate;
    hudView.labelText = msg;
    hudView.margin = 10.f;
    //hudView.yOffset = 150.f;
    
    [hudView show:YES];
    return hudView;
}

+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg VisibleRect:(CGRect)vRect {
    MBProgressHUD *hudView;
    if ([self isPad]) {
        hudView = [[MBProgressHUD alloc] initWithFrame:vRect];
        [superView addSubview:hudView];
    }else {
        hudView = [[MBProgressHUD alloc] initWithFrame:vRect];
        [superView addSubview:hudView];
    }
    hudView.delegate = sender;
    
    hudView.mode = MBProgressHUDModeIndeterminate;
    hudView.labelText = msg;
    hudView.margin = 10.f;
    //hudView.yOffset = 150.f;
    
    [hudView show:YES];
    NSLog(@"%@", NSStringFromCGRect(hudView.frame));
    return hudView;
}

+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg LeftOffset:(NSInteger)leftOffset {
    MBProgressHUD *hudView;
    if ([self isPad]) {
        CGRect rect = superView.bounds;
        rect.origin.x = rect.size.width / 2 - 50 - leftOffset;
        rect.origin.y = rect.size.height / 2 - 50;
        rect.size.width = 100;
        rect.size.height = 100;
        hudView = [[MBProgressHUD alloc] initWithFrame:rect];
        hudView.userInteractionEnabled = NO;
        [superView addSubview:hudView];
    }else {
        //hudView = [MBProgressHUD showHUDAddedTo:superView animated:YES];
        CGRect rect = superView.bounds;
        rect.origin.x = rect.size.width / 2 - 50;
        rect.origin.y = rect.size.height / 2 - 50;
        rect.size.width = 100;
        rect.size.height = 100;
        hudView = [[MBProgressHUD alloc] initWithFrame:rect];
        hudView.userInteractionEnabled = NO;
        [superView addSubview:hudView];
    }
    
    hudView.delegate = sender;
    
    hudView.mode = MBProgressHUDModeIndeterminate;
    hudView.labelText = msg;
    hudView.margin = 10.f;
    //hudView.yOffset = 150.f;
    
    [hudView show:YES];
    return hudView;
}

+ (MBProgressHUD *) showMBProgressHudHint:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg ShowTime:(CGFloat)showtime {
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    hudView.delegate = sender;
    
    hudView.mode = MBProgressHUDModeText;
    hudView.labelText = msg;
    hudView.margin = 10.f;
    //hudView.yOffset = 150.f;
    
    [hudView hide:YES afterDelay:showtime];
    return hudView;
}

+(void)resignKeyBoardInView:(UIView *)pv
{
    for(UIView *v in pv.subviews)
    {
        if([v.subviews count] > 0)
        {
            [self resignKeyBoardInView:v];
        }
        
        
        if ([v isKindOfClass:[UITextView class]] || [v isKindOfClass:[UITextField class]])
        {
            [v resignFirstResponder];
        }
    }
}

+(NSString *)priceRemoveZero:(CGFloat)f
{
    NSString *str = [NSString stringWithFormat:@"%.2f", f];
    str = [str stringByReplacingOccurrencesOfString:@".00" withString:@".0"];
    str = [str stringByReplacingOccurrencesOfString:@".0" withString:@""];
    //NSRange range = [str rangeOfString:@".0"];
    return str;
    
}

+(void)showView:(UIView *)sview toView:(UIView *)cview withSuperView:(UIView *)superView withDirection:(NSInteger)direction
{
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.5;
    //    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionPush;
    if (direction == FROMLEFT) {
        animation.subtype = kCATransitionFromLeft;
    } else {
        animation.subtype = kCATransitionFromRight;
    }
    NSInteger sindex = [[superView subviews] indexOfObject:sview];
    NSInteger cindex = [[superView subviews] indexOfObject:cview];
    [superView exchangeSubviewAtIndex:sindex withSubviewAtIndex:cindex];
    
    [[superView layer] addAnimation:animation forKey:@"animation"];
}

//取搜索历史记录
+ (NSArray *) getSearchHistoryByKey:(NSString *)aKey
{
    NSUserDefaults *userStore = [NSUserDefaults standardUserDefaults];
    if ([userStore arrayForKey:aKey] != nil) {
        return [userStore arrayForKey:aKey];
    }
    return nil;
}

//增加搜索历史记录
+ (void) addSearchHistory:(NSString *)aValue historyKey:(NSString *)hsitoryKey
{
    if ([aValue isEqualToString:@""]) {
        return ;
    }
    NSUserDefaults *userStore = [NSUserDefaults standardUserDefaults];
    if ([userStore arrayForKey:hsitoryKey] != nil) {
        NSArray *old = [userStore stringArrayForKey:hsitoryKey];
        
        for (NSString *sKey in old) {
            if ([sKey isEqualToString:aValue]) {
                return;
            }
        }
        NSMutableArray *new = [[NSMutableArray alloc] init];
        [new addObject:aValue];
        
        for (id obj in old) {
            if ([new count] < 20) {
                [new addObject:obj];
                
            }
            else {
                break;
            }
        }
        
        [userStore setObject:new forKey:hsitoryKey];
    }
    else {
        NSArray *new = [[NSArray alloc] initWithObjects:aValue, nil];
        [userStore setObject:new forKey:hsitoryKey];
        [new release];//add vincent 内存释放
    }
}

//清空搜索历史记录
+ (void) clearSearchHistoryByKey:(NSString *)historyKey{
    NSArray *new = [[NSArray alloc] init];
    NSUserDefaults *userStore = [NSUserDefaults standardUserDefaults];
    [userStore setObject:new forKey:historyKey];
    [new release];//add vincent 内存释放
}

+ (BOOL) callPhone:(NSString *)phoneNumber {
    NSString *phone = [NSString stringWithFormat:@"telprompt:%@", phoneNumber];
    BOOL isSuccess = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
    if (isSuccess) {
        [self addUserOperateLog:2007 Remark:@"拨打电话"];
    }
    return  isSuccess;
}

+ (BOOL) openURL:(NSString *)url {
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (BOOL) fileIsExists:(NSString *)filePath {
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}


+ (void) scrollToLastCell:(UITableView *)tabView Section:(NSInteger)section Row:(NSInteger)row ScrollPosition:(UITableViewScrollPosition)position {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [tabView scrollToRowAtIndexPath:indexPath atScrollPosition:position animated:NO];
}

+ (NSString *) getSpecialFormatDateTime:(NSString *)date {
    NSString *today = [self localstringFromDate:[NSDate date] Formatter:@"yyyy-MM-dd"];
    NSString *msgTime;
    NSDate *fmtDate = [Common dateFromString:date];
    if ([date hasPrefix:today]) {
        msgTime = [Common localstringFromDate:fmtDate Formatter:@"HH:mm"];
    } else {
        msgTime = [Common localstringFromDate:fmtDate Formatter:@"MM-dd"];
    }
    return msgTime;
}

+ (CGSize) getScaleImageSize:(UIImage *)image MaxWidth:(NSInteger)maxWidth MaxHeight:(NSInteger)maxHeight {
    CGFloat width = 0;
    CGFloat height = 0;
    if (image.size.height > maxHeight && image.size.width > maxWidth) {
        if (image.size.width > image.size.height) {
            width = maxWidth;
            height = width * (image.size.height / image.size.width);
        } else {
            height = maxHeight;
            width = height * (image.size.width / image.size.height);
        }
    }
    else if (image.size.width > maxWidth) {
        width = maxWidth;
        height = width * (image.size.height / image.size.width);
    }
    else if (image.size.height > maxHeight) {
        height = maxHeight;
        width = height * (image.size.width / image.size.height);
    }
    else {
        width = image.size.width;
        height = image.size.height;
    }
    return CGSizeMake(width, height);
}

+ (NSString *) imageToBase64String:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSString *imageString = [CTMBase64 stringByEncodingData:imageData];
    return imageString;
}

+ (void) showMessage:(NSString *)aTitle ShowInfo:(NSString *)aMsg WithDelegate:(id)sender ShowCancelButton:(BOOL)showCancelButton Tag:(NSInteger)tag {
    UIAlertView *alert;
    if (showCancelButton) {
        alert = [[UIAlertView alloc] initWithTitle:aTitle message:aMsg delegate:sender cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil ];
    } else {
        alert = [[UIAlertView alloc] initWithTitle:aTitle message:aMsg delegate:sender cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ];
    }
    [alert setTag:tag];
    [alert show];
}

+ (BOOL) isValidatePriceRegularExpression:(NSString *)strDestination {
    NSString *strExpression = @"[0-9]\\d{0,9}(\\.\\d{1,2})?|0\\.[1-9]\\d?|0\\.0[1-9]";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strExpression];
    return [predicate evaluateWithObject:strDestination];
}

+ (NSString *) getPinYin:(NSString *)chineseString {
    NSString *pinYin = @"";
    if(![chineseString isEqualToString:@""])
    {
        for(int j = 0; j < chineseString.length; j++){
            NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString characterAtIndex:j])]uppercaseString];
            pinYin = [pinYin stringByAppendingString:singlePinyinLetter];
        }
    }
    return pinYin;
}

+ (void) addUserOperateLog:(NSInteger)functionCode Remark:(NSString *)remark {
    
}

@end
