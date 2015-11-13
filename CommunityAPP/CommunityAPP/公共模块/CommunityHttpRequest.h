//
//  CommunityHttpRequest.h
//  CommunityAPP
//
//  Created by Stone on 14-3-10.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunityHttpRequest : NSObject

/**
[""] *	@brief	
[""] *
[""] *	@return	网络请求的实例对象
[""] */
+ (id)shareInstance;

- (void)cancelDelegate:(id)delegate;            //取消委托

+ (void)showProcessView:(NSString *)msg;       //加载菊花

+ (void)hideProcessView;                       //取消菊花


/**
[""] *	@brief	个人信息的请求接口
[""] *
[""] *	@param 	delegate 	调用接口的委托对象
[""] *	@param 	dictionary 	请求接口的参数
[""] *
[""] *	@return	无
[""] */
- (void)requestPersonalInfodelegate:(id)delegate parameters:(NSString *)parameters; //请求个人信息

- (void)requestCommunityInfo:(id)delegate parmeters:(NSString *)parameters;//小区介绍 add by devin

-(void)requestNotice:(id)delegate parameters:(NSString *)parameters;//通知 add by devin

-(void)requestLiveEncyclopedia:(id)delegate parameters:(NSString *)parameters; //生活百科列表 add by devin

-(void)requestDetailLiveEncyclopedia:(id)delegate parameters:(NSString *)parameters; //生活百科详情 add by devin

- (void)requestAddress:(id)delegate parameters:(NSString *)parameters;//add by vincent 2014.3.11

- (void)requestContactTypes:(id)delegate parameters:(NSString *)parameters;     //请求电话类型 add by stone -2014.03.11

- (void)requestContacts:(id)delegate parameters:(NSString *)parameters;         //请求电话本   add by stone -2014.03.11

- (void)requestBillList:(id)delegate parameters:(NSString *)parameters; //请求我的账单 add by vincent -2013.03.12

- (void)addContact:(id)delegate parameters:(NSString *)parameters;      //添加电话记录   add by Stone -2014.03.13

- (void)editContact:(id)delegate parameters:(NSString *)parameters;     //修改联系人     add by Stone -2014.03.13

- (void)deleteContact:(id)delegate parameters:(NSString *)parameters;   //删除联系人     add by Stone -2014.03.13

- (void)requestAuctionInfo:(id)delegate parameters:(NSString *)parameters;  //请求拍卖商品的详情 add by Stone  -2014.03.20

- (void)requestAuctionList:(id)delegate parameters:(NSString *)parameters;  //请求拍卖商品列表 add by Stone  -2014.03.20

- (void)requestAuctionAdd:(id)delegate parameters:(NSString *)parameters;  //请求添加拍卖商品 add by Stone  -2014.03.20

- (void)requestCarPoolAdd:(id)delegate parameters:(NSString *)parameters;//请求拼车上下班的数据列表 add vincent 2014.3.21 
- (void)requestCarPoolDetailAdd:(id)delegate parameters:(NSString *)parameters;//请求拼车上下班的数据列表 add vincent 2014.3.21

- (void)requestComments:(id)delegate parameters:(NSString *)parameters;     //请求评论的数据列表         add by Stone 2014.03.24

- (void)requestRegisterMsgcode:(id)delegate parameters:(NSString *)parameters;//add vincent 短信验证码 2014.03.24
- (void)requestVerificationAction:(id)delegate parameters:(NSString *)parameters;//add vincent 验证验证码 2014.03.24

- (void)requestModifyPassword:(id)delegate parameters:(NSString *)parameters;//修改密码 add by devin 2014.03.24

- (void)requestLogin:(id)delegate parameters:(NSString *)parameters;            //add by Stone 2014.03.24

- (void)requestRegisterOneStep:(id)delegate parameters:(NSString *)parameters;  //add vincent 注册第一步 2014.03.24

-(void)requestSeekPasswordTestStep:(id)delegate parameters:(NSString *)parameters;//add by devin 找回密码获取验证码 2014.04.2

-(void)requestSeekPasswordOneStep:(id)delegate parameters:(NSString *)parameters; //add by devin 找回密码第一步

-(void)requestSeekPasswordTwoStep:(id)delegate parameters:(NSString *)parameters; //add by devin 找回密码第二步

-(void)requestSeekPasswordThreeStep:(id)delegate parameters:(NSString *)parameters; //add by devin 找回密码第三步

-(void)requestGetInvite:(id)delegate parameters:(NSString *)parameters; //add by devin 获取邀请码

-(void)requestInviteHistory:(id)delegate parameters:(NSString *)parameters; //add by devin 邀请码历史记录

-(void)requestAddComment:(id)delegate parameters:(NSString *)parameters; //add by devin 添加评论 4.8

-(void)requestAddLove:(id)delegate parameters:(NSString *)parameters; //add by devin 添加点赞

-(void)requestDeleLove:(id)delegate parameters:(NSString *)parameters; //add by devin 取消点赞

-(void)requestDelegateComment:(id)delegate parameters:(NSString *)parameters; //add by devin 删除评论

-(void)requestAddCollect:(id)delegate parameters:(NSString *)parameters; //add by devin 添加收藏

-(void)requestCancelCollect:(id)delegate parameters:(NSString *)parameters; //add by devin 取消收藏

- (void)requestModifyMyInfo:(id)delegate parameters:(NSString *)parameters; //add by Stone 请求修改个人资料

//我
-(void)requestMyComment:(id)delegate parameters:(NSString *)parameters; //add by devin 查询我的评论

-(void)requestVersionUpdate:(id)delegate parameters:(NSString *)parameters; //add by vincent

-(void)requestMyCollection:(id)delegate parameters:(NSString *)parameters; //add by devin 查询我的收藏

-(void)requestMyPublish:(id)delegate parameters:(NSString *)parameters; //add by devin 查询我的发布

-(void)requestDelegateMyPublish:(id)delegate parameters:(NSString *)parameters; //add by devin  删除我的发布

-(void)requestHomeAd:(id)delegate parameters:(NSString *)parameters; //add by devin  首页广告

-(void)requestMarquee:(id)delegate parameters:(NSString *)parameters; //add by Stone 首页跑马灯

-(void)requestSignIn:(id)delegate parameters:(NSString *)parameters;//add by vincent 签到

-(void)requestLotteryRrecode:(id)delegate parameters:(NSString *)parameters;//add by vincent  获奖记录列表
//获奖记录 LOTTERY_PRODUCT

-(void)requestLotteryProduct:(id)delegate parameters:(NSString *)parameters;//add bu vincent 奖品详情

//收货地址列表和详情
-(void)requestAddressInfo:(id)delegate parameters:(NSString *)parameters;//add bu vincent 奖品详情

//编辑地址
-(void)requestAddressEdit:(id)delegate parameters:(NSString *)parameters; //add bu vincent

//删除收货地址
-(void)requestDeleteAddress:(id)delegate parameters:(NSString *)parameters; //add bu vincent

//请求区域地址
-(void)requestDataLocation:(id)delegate parameters:(NSString *)parameters;//add bu vincent

/**
 *  百度云服务的数据上报
 *
 *  @param delegate   请求的委托对象
 *  @param parameters 数据上报参数
 */
- (void)requestSubscribe:(id)delegate parmaeters:(NSString *)parameters;

- (void)requestPointChange:(id)delegate parameters:(NSString *)parameters;

//请求邻居分组列表 add vincent
- (void)requestGroupList:(id)delegate parameters:(NSString *)parameters;
//请求邻居列表
- (void)requestFriendNeighborhoodList:(id)delegate parameters:(NSString *)parameters;

- (void)requestNoticeSetting:(id)delegate parameters:(NSString *)parameters;

- (void)requestSettingPush:(id)delegate parameters:(NSString *)parameters;

@end
