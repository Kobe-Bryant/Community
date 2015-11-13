//
//  Connection_Parser.h
//  PABank
//
//  Created by pingan_tiger on 11-4-22.
//  Copyright 2011 pingan. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol Connection_Parser_Delegate <NSObject>

- (void)callBackWithWithData:(NSDictionary*)callBackDictionary typeConnect:(NSString *)typeConnectString;
@end

@interface Connection_Parser : NSObject <NSXMLParserDelegate> {
    int tag;
	BOOL isExit;
	BOOL isConnect;
	
	int connectID;
	int urlType;
	NSString *urlString;
	NSString *bodyString;
	id<Connection_Parser_Delegate> callBackDelegate;
	
	NSTimer *connectTimer;//连接定时器,用来判断连接超时
	BOOL timerFired;
	
	//请求
	NSURLConnection *connect;
	NSMutableData *xmlData;
	
	//解析
	NSMutableDictionary *xmlDataSource;
	NSMutableString *keyString;
	
	NSMutableArray *dicNameArray;
	BOOL endStringElement;
}
@property (nonatomic, assign) int tag;
@property (nonatomic, assign) BOOL isExit;
@property (nonatomic, assign) BOOL isConnect;

@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) NSString *bodyString;

@property (nonatomic,retain) NSString *connectString;
@property (nonatomic,retain) NSString *typeConnect;

@property (nonatomic, retain) id<Connection_Parser_Delegate> callBackDelegate;

- (void)startConnect;	//开始connect
- (void)stop;			//停止connect

@property(nonatomic,retain) NSMutableString *keyString;
@property BOOL endStringElement;

- (id)initWithConnectString:(NSString *)environmentString
				URLString:(NSString *)urlTypeString
			 BodyString:(NSString*)bString 
			   CallBack:(id)cbDelegate
                typeConnect:(NSString *)typeConnectString;

- (void)callBackWithData:(NSDictionary*)callBackDictionary typeConnect:(NSString *)typeConnectString;

@end
