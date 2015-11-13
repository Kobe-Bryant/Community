//
//  FriendListDetailInfromation.h
//  CommunityAPP
//
//  Created by yunlai on 14-6-10.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>
//create table if not exists t_friend_list(friend_jid text,friend_name text,friend_subscription text,friend_group text,friend_from text,friend_given text,friend_residentid text,friend_fn text,friend_sex text,friend_nickname text,friend_binval text,friend_commmunity text,friend_address text,friend_home text,friend_extra text)
//        message_body text,message_fromjid text,message_tojid text,message_time text,message_text text
@interface FriendListDetailInfromation : NSObject
@property(nonatomic,retain)NSString *friendJidString;
@property(nonatomic,retain)NSString *friendNameString;
@property(nonatomic,retain)NSString *friendSubscriptionString;
@property(nonatomic,retain)NSString *friendGruopString;
@property(nonatomic,retain)NSString *friendFromString;
@property(nonatomic,retain)NSString *friendGivenString;
@property(nonatomic,retain)NSString *friendResidentidString;
@property(nonatomic,retain)NSString *friendFnString;
@property(nonatomic,retain)NSString *friendSexString;
@property(nonatomic,retain)NSString *friendNickNameString;
@property(nonatomic,retain)NSString *friendBinvalString;
@property(nonatomic,retain)NSString *friendCommunityString;
@property(nonatomic,retain)NSString *friendAddressString;
@property(nonatomic,retain)NSString *friendHomeString;
@property(nonatomic,retain)NSString *friendExtraString;

@property(nonatomic,retain)NSString *messageBodyString;
@property(nonatomic,retain)NSString *messageFromjidString;
@property(nonatomic,retain)NSString *messageTojidString;
@property(nonatomic,retain)NSString *messageTimeString;
@property(nonatomic,retain)NSString *messageTextString;
@end
