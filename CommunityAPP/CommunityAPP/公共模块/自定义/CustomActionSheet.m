//
//  CustomActionSheet.m
//  WOW
//
//  Created by jiayi on 13-3-25.
//  Copyright (c) 2013年 贾 朝阳. All rights reserved.
//

#import "CustomActionSheet.h"
#import "Global.h"

@implementation CustomActionSheet
@synthesize rButton, shareTitle, shareImage, shareURL;
-(void)dealloc
{
    if ( rButton )    SAFE_RELEASE(rButton);
    if ( shareTitle ) SAFE_RELEASE(shareTitle);
    if ( shareImage ) SAFE_RELEASE(shareImage);
    if ( shareURL )   SAFE_RELEASE(shareURL);
    
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
