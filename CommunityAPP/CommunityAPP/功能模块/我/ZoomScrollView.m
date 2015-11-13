//
//  ZoomScrollView.m
//  CommunityAPP
//
//  Created by Stone on 14-4-11.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "ZoomScrollView.h"
#import "UIImage+MyInfo.h"
#import "UIImage+extra.h"
#import "UIImageView+MJWebCache.h"

@interface ZoomScrollView ()<UIScrollViewDelegate>

@end

@implementation ZoomScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.maximumZoomScale = 2.0;
        self.minimumZoomScale = 1.0;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.delegate = self;
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageView];
        
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_imageView release];
    }
    return self;
}

- (void)setMyInfoPhoto:(MyInfoPhoto *)myInfoPhoto{
    if (myInfoPhoto != _myInfoPhoto) {
        [_myInfoPhoto release];
        _myInfoPhoto = [myInfoPhoto retain];
    }
    
    [_imageView setImageWithURL:[NSURL URLWithString:_myInfoPhoto.strUrl]];

}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}


@end
