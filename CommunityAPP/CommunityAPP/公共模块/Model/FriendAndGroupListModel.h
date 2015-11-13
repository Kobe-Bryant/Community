//
//  FriendAndGroupListModel.h
//  XMPPIOS
//
//  Created by yunlai on 14-5-12.
//  Copyright (c) 2014年 Dawn_wdf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendUserInformationModel.h"

@interface FriendAndGroupListModel : NSObject
@property(nonatomic,retain)NSString *jidString;
@property(nonatomic,retain)NSString *nameString;
@property(nonatomic,retain)NSString *groupString;
@property(nonatomic,retain)FriendUserInformationModel *userInformation;
@end
