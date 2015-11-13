//
//  DetailPhoneNumViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-3-6.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactModel;
@class PhoneBookViewController;

@interface DetailPhoneNumViewController : UIViewController

@property (nonatomic, retain) PhoneBookViewController *prviewController;
@property (nonatomic, retain) ContactModel *contactModel;

@end
