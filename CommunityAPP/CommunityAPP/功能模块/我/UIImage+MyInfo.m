//
//  UIImage+MyInfo.m
//  CommunityAPP
//
//  Created by Stone on 14-4-9.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "UIImage+MyInfo.h"
#import<objc/runtime.h>

static void *kUrlStr = (void *)@"kUrlStr";
static void *kPhotoComeFrom = (void *)@"kPhotoComeFrom";

@implementation UIImage (MyInfo)

- (NSString *)urlStr{
    return objc_getAssociatedObject(self, kUrlStr);
}

- (void)setUrlStr:(NSString *)urlStr{
    objc_setAssociatedObject(self, kUrlStr, urlStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YLPhotoComeFrom)photoComeFrom{
    return [objc_getAssociatedObject(self, kPhotoComeFrom) integerValue];
}

- (void)setPhotoComeFrom:(YLPhotoComeFrom)photoComeFrom{
    NSNumber *number = [[NSNumber alloc] initWithInteger:photoComeFrom];
    objc_setAssociatedObject(self, kPhotoComeFrom, number, OBJC_ASSOCIATION_COPY);
}

@end
