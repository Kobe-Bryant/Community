//
//  Connection_Parser.m
//  PABank
//
//  Created by pingan_tiger on 11-4-22.
//  Copyright 2011 pingan. All rights reserved.
//

#import "Connection_Parser.h"
#import "AppDelegate.h"
#import "Global.h"
#import "NSMutableDictionary_extra.h"
#import "NetController.h"
#import "NSObject_extra.h"

@implementation Connection_Parser

@synthesize tag;
@synthesize isExit;
@synthesize isConnect;
@synthesize connectString;
@synthesize bodyString;
@synthesize callBackDelegate;
@synthesize typeConnect;
@synthesize urlString;
@synthesize keyString;
@synthesize endStringElement;

- (id)initWithConnectString:(NSString *)environmentString
                  URLString:(NSString *)urlTypeString
                 BodyString:(NSString*)bString
                   CallBack:(id)cbDelegate
                typeConnect:(NSString *)typeConnectString
{
	if (self = [super init]) {
		self.isConnect = FALSE;
		self.connectString = environmentString;
        self.urlString = urlTypeString;
		self.bodyString = bString;
		self.callBackDelegate = cbDelegate;
        self.typeConnect = typeConnectString;
       [self startConnect];
	}
	return self;
}

#pragma mark 连接方法
- (void)startConnect {
    if (self.isConnect) return;
	self.isConnect = TRUE;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.connectString,self.urlString]];
    NSLog(@"startConnect url %@",url);
    
 	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:0];
    
    [request setHTTPBody:[self.bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPMethod:@"POST"];
    
    connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connect start];
    
    xmlData = [[NSMutableData alloc] init];
    connectTimer = [NSTimer scheduledTimerWithTimeInterval:46
                                                    target:self
                                                  selector:@selector(connectTimerFired)
                                                  userInfo:nil
                                                   repeats:NO];
    timerFired = FALSE;
}

- (void)stop {
    
	NSLog(@"请求停止");
	if (!timerFired) {
		timerFired = TRUE;
		[connectTimer invalidate];
	}
	if (!self.isExit)[connect cancel];
}

- (void)connectTimerFired {
	timerFired = TRUE;
	[self stop];
	
//    [self alertWithFistButton:nil SencodButton:@"确定" Message:@"当前网络超时，请稍候重试" ];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	if (!timerFired) {
		timerFired = TRUE;
		[connectTimer invalidate];
	}
    [self stop];
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[xmlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	if (!timerFired) {
		timerFired = TRUE;
		[connectTimer invalidate];
	}
	NSString *resultString = [[[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding] autorelease];
    if ([resultString hasSuffix:@"</html>"]) {
	
//        [self alertWithFistButton:nil SencodButton:@"确定" Message:@"当前数据不稳定，请稍候重试"];

		return;
	}
    
    xmlDataSource=[[NSMutableDictionary alloc] init];
	dicNameArray = [[NSMutableArray alloc] init];
	self.endStringElement = FALSE;
	keyString = [[NSMutableString alloc] init];
    
    NSXMLParser *parser=[[NSXMLParser alloc]initWithData:xmlData];
	[parser setDelegate:self];
	[parser parse];
	[parser release];
}
//begin
- (void)parserDidStartDocument:(NSXMLParser *)parser {
	
}
//middle
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	[self addNewDIc:[NSString stringWithString:elementName]];
	self.endStringElement = TRUE;
	[self.keyString setString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	[self.keyString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if (self.endStringElement) {
		if (![self.keyString isEqualToString:@"\n"]) {
			if ([self.keyString hasPrefix:@"\n"]) {
				[self.keyString setString:[self.keyString substringFromIndex:1]];
			}
			NSMutableDictionary *dic = [self getLastDic];
			[dic setObject:[NSString stringWithString:self.keyString] forKey:[dicNameArray objectAtIndex:[dicNameArray count]-1]];
		}
	}
	
	[self.keyString setString:@""];
	self.endStringElement = FALSE;
	[self removeLastDic];
}
- (void)parserDidEndDocument:(NSXMLParser *)parser {
//    NSString *errorCode = [[xmlDataSource objectForKey:@"Data"] objectForKey:@"errorCode"];
//    [self callBackWithConnectID:self.connectID WithData:xmlDataSource WithNetState:net_Parser_SUCCES];
    [self callBackWithData:xmlDataSource typeConnect:self.typeConnect];
}

-(void) addNewDIc:(NSString*) dicName {
	if ([dicNameArray count]>0) {
		NSMutableDictionary *dic = [self getDic];
		dicName = [self getListElement:dicName From:[dic allKeys]];
		
		[dic setObject:[[[NSMutableDictionary alloc] init] autorelease] forKey:dicName];
		[dicNameArray addObject:dicName];
	}
	else {
		[xmlDataSource setObject:[[[NSMutableDictionary alloc] init] autorelease] forKey:dicName];
		[dicNameArray addObject:dicName];
	}
}

- (NSString*)getListElement:(NSString*)elementName From:(NSArray*)array {
	NSString *temp = elementName;
	for (int i=0; i<100000; i++) {
		if ([array containsObject:elementName]) {
			elementName = [NSString stringWithFormat:@"%@%d", temp, i+1];
		}
		else {
			return elementName;
		}
	}
	return nil;
}

-(NSMutableDictionary*) getDic {
	NSMutableDictionary *dic=xmlDataSource;
	for (int i=0; i<[dicNameArray count]; i++) {
		dic=[dic objectForKey:(NSString*)[dicNameArray objectAtIndex:i]];
	}
	return dic;
}

- (NSMutableDictionary*)getLastDic {
	NSMutableDictionary *dic=xmlDataSource;
	for (int i=0; i<[dicNameArray count]-1; i++) {
		dic=[dic objectForKey:(NSString*)[dicNameArray objectAtIndex:i]];
	}
	return dic;
}

-(void) removeLastDic {
	if ([dicNameArray count]>0) {
		[dicNameArray removeLastObject];
	}
}

//回调
- (void)callBackWithData:(NSDictionary*)callBackDictionary typeConnect:(NSString *)typeConnectString{
    [self.callBackDelegate callBackWithWithData:callBackDictionary typeConnect:self.typeConnect];
}
- (void)dealloc {
	if (!timerFired) {
		[connectTimer invalidate];
	}
	timerFired = TRUE;
	
	[bodyString release];

	[xmlData release];
	[callBackDelegate release];
	[connect release];

	[super dealloc];
}

@end
