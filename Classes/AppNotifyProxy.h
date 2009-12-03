//
// AppNotify Sample Application
// Copyright (c) Select Start Studios, 2009
// All rights reserved.
//
// Licensed under the BSD Simplified License
//

#import <Foundation/Foundation.h>

// ***IMPORTANT***
// Application Id and Secret
// Your application id is generated for you by the AppNotify Administrative Console at http://admin.appnotify.com
// 
// You can find all of this information in your App Profile

#define kApplicationId @"aeab0920-b630-012c-504d-12313b022d84"
#define kApplicationSecret @"ltsj4yo3t9rlsbhvlnpry"

// ***IMPORTANT***
// This is the URL of the AppNotify server
// You have the option of either using HTTPS to secure your application id and secret, or use HTTP the less secure but
// much faster alternative.
//define kANServer @"https://api.appnotify.com"
#define kANServer @"http://api.appnotify.com"

@interface AppNotifyProxy : NSObject {
	NSOperationQueue *operationQueue;
}

@property (nonatomic, retain) NSOperationQueue *operationQueue;

// AppNotifyProxy is a singleton.
// Although alloc and init are accessible, use the instance unless absolutely necessary.
+ (AppNotifyProxy *)instance;

// /device/register
// @brief Register device is used to register a specific device + name with the server
// 
// registerDevice can be used to simply register a deviceToken (name and secret optional), to register a name to a deviceToken
// or to secure a name with a secret (not shown in this sample application, please refer to the documentation)
- (void)registerDevice:(id)sender deviceToken:(NSString*)deviceToken deviceName:(NSString*)deviceName;

// /push/
// @brief Push can be used to send push notifications to a specific device
// 
// /push/ is the basic unit of work for AppNotify.  In other words, it's what does all the heavy lifting; you can send
// push notifications to as many groups and devices you desire.  (Groups are not shown in this sample application)
- (void)sendPush:(id)sender deviceName:(NSString*)deviceName message:(NSString*)message badgeNumber:(NSInteger*)badgeNumber soundName:(NSString*)soundName;

@end
