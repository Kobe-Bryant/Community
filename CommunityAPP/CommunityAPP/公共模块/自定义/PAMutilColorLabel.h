//
//  PAMutilColorLabel.h
//  GetNSRange
//
//  Created by Sgs on 14-4-20.
//  Copyright (c) 2014年 Sgs. All rights reserved.
//
//  功能描述：在一个label中将指定的字符设置成需要的颜色
//

#import <UIKit/UIKit.h>

@interface PAMutilColorLabel : UILabel

@property (nonatomic, retain) NSString *fullContentText;
@property (nonatomic, retain) NSString *findContentText;
@property (nonatomic, retain) UIColor *contentColor;
@property (nonatomic, retain) UIColor *defaultColor;

/* text:默认显示的字符窜 colorText:需要设置颜色的字符串 color:需要设置的颜色 dColor:默认颜色 */
- (void) setMutilColorText:(NSString *)text ColorText:(NSString *)colorText Color:(UIColor *)color DefaultColor:(UIColor *)dColor;

@end
