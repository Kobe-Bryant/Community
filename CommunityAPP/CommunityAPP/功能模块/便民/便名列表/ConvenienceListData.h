//
//  ConvenienceListData.h
//  CommunityAPP
//
//  Created by yunlai on 14-4-8.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConvenienceListData : NSObject
@property(nonatomic,retain)NSString *businessIdString;
@property(nonatomic,retain)NSString *nameString;
@property(nonatomic,retain)NSString *addressString;
@property(nonatomic,retain)NSString *telephoneString;
@property(nonatomic,retain)NSString *cityString;
@property(nonatomic,retain)NSArray *categoriesArray;
@property(nonatomic,retain)NSString *latitudeString;
@property(nonatomic,retain)NSString *longitudeString;
@property(nonatomic,retain)NSString *avg_ratingString;
@property(nonatomic,retain)NSString *distanceString;
@property(nonatomic,retain)NSString *s_photo_urlString;
@property(nonatomic,retain)NSArray *regionsArray;
@property(nonatomic,retain)NSString *business_urlString;
@end
