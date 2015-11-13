//
//  AddPhoneViewController.h
//  CommunityAPP
//
//  Created by yunlai on 14-3-5.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  PhoneBookViewController;
@interface AddPhoneViewController : UIViewController<UITextFieldDelegate>
{
    UITextField *nameField;
    UITextField *numField;
    //UITextField *describeField;
    UITextView  *tvDescribe;
}

@property (nonatomic, retain) PhoneBookViewController *prviewController;

@end
