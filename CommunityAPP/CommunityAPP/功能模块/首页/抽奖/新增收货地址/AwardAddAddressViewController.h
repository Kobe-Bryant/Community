//
//  AwardAddAddressViewController.h
//  CommunityAPP
//
//  Created by yunlai on 14-4-21.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityHttpRequest.h"
#import "AddressListModel.h"
#import "AppDelegate.h"

@class MBProgressHUD;

@interface AwardAddAddressViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>//UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate
{
    UIPickerView *areasPickView;
    UIToolbar *toolbarCancelDone;
    UIView *areasView ;
    UITextField *arearField;
    
//    NSMutableArray *provincesArray; //*citiesArray, *areasArray;
//    NSMutableArray *pArray,*cArray,*aArray;
    UITableView *recordTableView;
    
    NSString *arearString;
    
    MBProgressHUD *hudView;
    
    CommunityHttpRequest *request;
    
    AppDelegate *appDelegate;
}
@property(nonatomic,retain)AddressListModel *addressModel;
//@property(nonatomic,retain)NSString *arearString;

//@property(nonatomic,retain)NSMutableArray *provincesArray; 
@end
