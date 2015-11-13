//
//  AddressListModel.h
//  CommunityAPP
//
//  Created by yunlai on 14-4-30.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressListModel : NSObject
@property(nonatomic,retain)NSString *idString;
@property(nonatomic,retain)NSString *consigneeString;
@property(nonatomic,retain)NSString *phoneNumberString;
@property(nonatomic,retain)NSString *zipCodeString;
@property(nonatomic,retain)NSString *provinceIdString;
@property(nonatomic,retain)NSString *cityIdString;
@property(nonatomic,retain)NSString *addressString;
@property(nonatomic,retain)NSString *fullAddressString;
@property(nonatomic,retain)NSString *isDefaultString;
@property(nonatomic,retain)NSString *areaIdString;

@end
