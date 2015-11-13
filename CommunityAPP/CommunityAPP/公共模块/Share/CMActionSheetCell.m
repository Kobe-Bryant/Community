//
//  CMActionSheetCell.m
//  CMActionSheet
//
//  Created by Stone on 14-4-20.
//  Copyright (c) 2014年 Stone. All rights reserved.
//

#import "CMActionSheetCell.h"

@implementation ShareItemModel

- (id)initWithIcon:(NSString *)imageName
             title:(NSString *)title
         shareType:(NSInteger)shareType{
    self = [super init];
    if (self) {
        self.iconName = imageName;
        self.title = title;
        self.shareType = shareType;
    }
    return self;
}



@end

#pragma mark - CMActionSheetCell
@interface CMActionSheetCell ()
@end

@implementation CMActionSheetCell

@synthesize iconView;
@synthesize titleLabel;

- (void)dealloc
{
    [iconView release];
    [titleLabel release];
    
    [super dealloc];
}

-(id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 70, 70)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.iconView = [[[UIImageView alloc] initWithFrame:CGRectMake(6.5, 0, 57, 57)] autorelease];
        [iconView setBackgroundColor:[UIColor clearColor]];
        [[iconView layer] setCornerRadius:8.0f];
        [[iconView layer] setMasksToBounds:YES];
        
        [self addSubview:iconView];
        
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 63, 70, 13)] autorelease];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:12]];
        [titleLabel setTextColor:[UIColor blackColor]];
        [titleLabel setText:@""];
        [self addSubview:titleLabel];
    }
    return self;
}


@end
