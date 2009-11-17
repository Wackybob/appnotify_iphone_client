//
// AppNotify Sample Application
// Copyright (c) Select Start Studios, 2009
// All rights reserved.
//
// Licensed under the BSD Simplified License
//

#import "AppNotifySampleAppDelegate.h"
#import "AppNotifySampleViewController.h"
#import "SendNotificationViewController.h"
#import "SelectSoundViewController.h"
#import "NSData+Base64.h"
#import "ASIHTTPRequest.h"
#import "AppNotifyProxy.h"
#import <AudioToolbox/AudioServices.h>

@implementation AppNotifySampleAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize sendNotifyViewController;
@synthesize selectSoundViewController;
@synthesize deviceToken;
@synthesize deviceName;

- (void)dealloc {	
	[deviceToken release];
	[deviceName release];
	[selectSoundViewController release];
	[sendNotifyViewController release];
    [viewController release];
    [window release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{   
	//Register for notifications
	[[UIApplication sharedApplication]
	 registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
										 UIRemoteNotificationTypeSound |
										 UIRemoteNotificationTypeAlert)];
    
	viewController.appDelegate = self;
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	sendNotifyViewController = [[SendNotificationViewController alloc] initWithNibName: @"SendNotificationViewController" bundle: nil];
	sendNotifyViewController.view.frame = viewController.view.frame;
	sendNotifyViewController.appDelegate = self;
	
	selectSoundViewController = [[SelectSoundViewController alloc] initWithNibName: @"SelectSoundViewController" bundle: nil];
	selectSoundViewController.view.frame = viewController.view.frame;
	selectSoundViewController.sendNotifyViewController = sendNotifyViewController;
	selectSoundViewController.appDelegate = self;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)_deviceToken
{
	// IMPORTANT: Store the device token so that we can send this to AppNotify
	self.deviceToken = [_deviceToken base64EncodedString];
	
	// Update View with the current token
	[[viewController tokenDisplay] setText: self.deviceToken];
	
	// Get device name from NSUserDefaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	self.deviceName = [userDefaults stringForKey: kDefaultDevName];
	[[viewController nameDisplay] setText: self.deviceName];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error
{
	NSLog(@"Failed to register with error: %@", error);
}

- (void)successMethod:(ASIHTTPRequest *) request
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	// Save device name in user defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setValue: self.deviceName forKey: kDefaultDevName];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	NSLog(@"Remote notification: %@",[userInfo description]);
	NSLog(@"%@", [userInfo objectForKey: @"aps"]);
	NSString* message = [[userInfo objectForKey: @"aps"] objectForKey: @"alert"];
	NSString* sound = [[userInfo objectForKey: @"aps"] objectForKey: @"sound"];
	
	//play the sound if it was present
	if (sound != nil) {
		[self startPlayback:sound];
	}
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Remote Notification" message:message delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	NSError *error = [request error];
	UIAlertView *someError = [[UIAlertView alloc] initWithTitle: 
							  @"Network error" message: @"Error registering with server"
													   delegate: self
											  cancelButtonTitle: @"Ok"
											  otherButtonTitles: nil];
	[someError show];
	[someError release];
	NSLog(@"ERROR: NSError query result: %@", error);
}

- (void)startPlayback:(NSString *)soundFile
{
	NSString* resourcePath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], soundFile];
	NSURL *filePath = [NSURL fileURLWithPath:resourcePath isDirectory:NO];
	NSLog(@"Path to play: %@", resourcePath);
	
	//declare a system sound id
	SystemSoundID soundID;
		
	//Use audio sevices to create the sound
	AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
		
	//Use audio services to play the sound
	AudioServicesPlaySystemSound(soundID);
}

-(void)registerDevice:(id)sender
{
	[[AppNotifyProxy instance] registerDevice:sender deviceToken:self.deviceToken deviceName:self.deviceName];
}

- (void) sendPush:(id)sender deviceName:(NSString*)sendDeviceName message:(NSString*)message badgeNumber:(NSInteger*)badgeNumber soundName:(NSString*)soundName
{
	[[AppNotifyProxy instance] sendPush:sender deviceName:sendDeviceName message:message badgeNumber:badgeNumber soundName:soundName];
}

@end
