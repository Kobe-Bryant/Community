//
//  EndRegisterViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-3-19.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityHttpRequest.h"
#import "CTAssetsPickerController.h"
#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger, CMUserSex){
    CMUserMale = 0,
    CMUserFemale,
};

@interface EndRegisterViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITextField *nameField;
    UIImage *headerImg;
    UIButton *boyBtn; //男性Button
    UIButton *girlBtn; //女性
    UIButton *headerImageBtn;
    
    CommunityHttpRequest *httpRequest;
//    性别
    CMUserSex userSex;
    
    MBProgressHUD *hudView;
}
@property(nonatomic,retain)NSData *imageData;
@property(nonatomic,retain)NSString *phoneFieldString;
@property(nonatomic,retain)NSString *pwsString;
@property(nonatomic,retain)NSString *uuidString;
@end
