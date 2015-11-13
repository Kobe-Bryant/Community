//
//  PAMutilColorLabel.m
//  GetNSRange
//
//  Created by Sgs on 14-4-20.
//  Copyright (c) 2014年 Sgs. All rights reserved.
//

#import "PAMutilColorLabel.h"
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

@implementation PAMutilColorLabel
@synthesize fullContentText;
@synthesize findContentText;
@synthesize contentColor;
@synthesize defaultColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setMutilColorText:(NSString *)text ColorText:(NSString *)colorText Color:(UIColor *)color DefaultColor:(UIColor *)dColor {
    fullContentText = text;
    findContentText = colorText;
    contentColor = color;
    defaultColor = dColor;
}

NSAttributedString* getAttributedString(NSString *text, NSString *findText, UIColor *color, UIColor *defaultColor) {
    NSString *testContent = text;//@"我的密码的格式的任务的的的的密码";
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSMutableArray *arySaveRange = [[NSMutableArray alloc] init];
    NSMutableArray *aryLastRanges = [[NSMutableArray alloc] init];
    
    NSString *findString = findText;
    NSInteger findLength = [findString length];
    
    while (true) {
        NSRange range = [testContent rangeOfString:findString];
        if (range.location == NSNotFound) {
            break;
        }
        else {
            testContent = [testContent substringWithRange:NSMakeRange(range.location + findLength, [testContent length] - range.location - findLength)];
            
        }
        
        NSValue *value = [NSValue valueWithRange:range];
        
        [arySaveRange addObject:value];
    }
    
    NSValue *value0;
    if ([arySaveRange count] > 0) {
        value0 = [arySaveRange objectAtIndex:0];
        [aryLastRanges addObject:value0];
    }
    
    for (int m = 1; m < [arySaveRange count]; m++) {
        NSValue *valueFirst = [arySaveRange objectAtIndex:m];
        NSRange rangeFirst = [valueFirst rangeValue];
        
        NSValue *valueTemp = [aryLastRanges objectAtIndex:m - 1];
        NSRange rangeTemp = [valueTemp rangeValue];
        
        NSRange rangeResult;
        rangeResult.location = rangeFirst.location + rangeTemp.location + findLength;
        rangeResult.length = [findString length];
        NSValue *valueResult = [NSValue valueWithRange:rangeResult];
        
        [aryLastRanges addObject:valueResult];
    }
    
    // 设置默认颜色
    [attriString addAttribute:(NSString *)kCTForegroundColorAttributeName
                        value:(id)defaultColor.CGColor
                        range:NSMakeRange(0, [text length])];
    
    for (int n = 0; n < [aryLastRanges count]; n++) {
        NSValue *valueRlt = [aryLastRanges objectAtIndex:n];
        NSRange rangeRlt = [valueRlt rangeValue];
        
        // 设置需要改变字体的颜色
        [attriString addAttribute:(NSString *)kCTForegroundColorAttributeName
                            value:(id)color.CGColor
                            range:rangeRlt];
       
        // 设置整个字符串字体的大小
        [attriString addAttribute:(NSString *)kCTFontAttributeName
                            value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)[UIFont systemFontOfSize:15.0f].fontName, 15.0f, NULL))
                            range:NSMakeRange(0, [text length])];
    }
    
    return attriString;

}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    NSAttributedString *attriString = getAttributedString(fullContentText, findContentText, contentColor, defaultColor);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(ctx, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, rect.size.height), 1.f, -1.f));
    //    CGContextTranslateCTM(ctx, 0, rect.size.height);
    //    CGContextScaleCTM(ctx, 1, -1);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attriString);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    CFRelease(framesetter);
    
    CTFrameDraw(frame, ctx);
    CFRelease(frame);
}

@end
