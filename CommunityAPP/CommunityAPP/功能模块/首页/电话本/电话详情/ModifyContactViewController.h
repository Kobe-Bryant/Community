//
//  ModifyContactViewController.h
//  CommunityAPP
//
//  Created by Stone on 14-3-26.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactModel;


typedef NS_ENUM(NSInteger, ModifyContactType) {
    CONTACT_NAME            = 0,
    CONTACT_PHONENUM        = 1,
    CONTACT_DESCRIPTION     =2,
};


@interface ModifyContactViewController : UIViewController


@property (nonatomic, retain) ContactModel *contactModel;
@property (nonatomic, assign) ModifyContactType modifyType;


@end
