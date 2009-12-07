//
// AppNotify Sample Application
// Copyright (c) Select Start Studios, 2009
// All rights reserved.
//
// Licensed under the BSD Simplified License
//

#import "AppNotifyProxy.h"
#import "ASIHTTPRequest.h"
#import "AppNotifySampleAppDelegate.h"

#define kPost @"POST"
#define kContentType @"Content-Type"
#define kApplicationJson @"application/json"

@implementation AppNotifyProxy

@synthesize operationQueue;

+ (AppNotifyProxy *)instance
{
	static AppNotifyProxy *instance;

	@synchronized(self) {
		if(!instance) {
			instance = [[AppNotifyProxy alloc] init];
		}
	}
	
	return instance;
}

-(id)init
{
	self = [super init];
	
	if (self) {
		operationQueue = [[NSOperationQueue alloc] init];
	}
	
	return self;
}

- (void)dealloc
{
	[operationQueue release];
    [super dealloc];
}

- (void)registerDevice:(id)sender deviceToken:(NSString*)deviceToken deviceName:(NSString*)deviceName
{
	// Use ASIHttpRequest to simplify calling the webservice
	NSString *urlString = [NSString stringWithFormat:@"%@%@", kANServer, @"/register/"];
	NSURL *url = [NSURL URLWithString:  urlString];
	ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
	request.requestMethod = kPost;
	
	// Send along our device alias as the JSON encoded request body.
	// It is important to remember to set the Content-Type to application/json
	if(deviceToken != nil && [deviceToken length] > 0) {
		[request addRequestHeader: kContentType value: kApplicationJson];
		[request appendPostData:[[NSString stringWithFormat:@"{\"token\":\"%@\", \"name\":\"%@\"}", deviceToken, deviceName]
								 dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	// Authenticate to the server, it's not necessary to present the credentials before the challenge
	// however it can be done for convenience
	request.shouldPresentCredentialsBeforeChallenge = YES;
	request.username = kApplicationId;
	request.password = kApplicationSecret;
	
	// Request to be informed once the request finishes
	[request setDelegate:sender];
	[request setDidFinishSelector: @selector(successMethod:)];
	[request setDidFailSelector: @selector(requestWentWrong:)];
	[operationQueue addOperation:request];	
}

- (void)sendPush:(id)sender deviceName:(NSString*)deviceName message:(NSString*)message badgeNumber:(NSInteger*)badgeNumber soundName:(NSString*)soundName
{
	// Use ASIHttpRequest to simplify calling the webservice
	NSString *urlString = [NSString stringWithFormat:@"%@%@", kANServer, @"/push/"];
	NSURL *url = [NSURL URLWithString:  urlString];
	ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
	request.requestMethod = kPost;
	
	// Send along our device alias as the JSON encoded request body
	// It is important to remember to set the Content-Type to application/json	
	if(deviceName != nil && [deviceName length] > 0) {
		[request addRequestHeader: kContentType value: kApplicationJson];
		
		// Generate the JSON request data
		NSString *requestDataReqFields = [NSString stringWithFormat:@"\"names\":[\"%@\"], \"alert\":\"%@\", \"badge\":\"%@\"", deviceName, message, badgeNumber];
		
		NSString *requestData;
		if (soundName == nil || [soundName isEqualToString:@"No sound selected.wav"]) {
			requestData = [NSString stringWithFormat:@"{%@}", requestDataReqFields];
		} else {
			requestData = [NSString stringWithFormat:@"{%@, \"sound\":\"%@\"}", requestDataReqFields, soundName];
		}
		[request appendPostData:[requestData dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	// Authenticate to the server
	request.shouldPresentCredentialsBeforeChallenge = YES;
	request.username = kApplicationId;
	request.password = kApplicationSecret;
	
	[request setDelegate:sender];
	[request setDidFinishSelector: @selector(successMethod:)];
	[request setDidFailSelector: @selector(requestWentWrong:)];
	[operationQueue addOperation:request];		
}

@end
