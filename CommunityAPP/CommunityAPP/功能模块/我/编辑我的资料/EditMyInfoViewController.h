//
//  EditMyInfoViewController.h
//  CommunityAPP
//
//  Created by Stone on 14-4-3.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditMyInfoViewController : UIViewController
{
    UIImageView *navImageView;
    UITableView *myTableView;
    UIImageView *imgView;//放大图片
    
    UITextField *tfNikeName;
    //UITextField *priceField;
    //UITextField *tfDescription;
    UITextView  *tvDescription;
}


@property (nonatomic, retain) NSMutableDictionary *personalInfo;

@end
