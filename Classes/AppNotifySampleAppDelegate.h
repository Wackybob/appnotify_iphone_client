//
// AppNotify Sample Application
// Copyright (c) Select Start Studios, 2009
// All rights reserved.
//
// Licensed under the BSD Simplified License
//

#import <UIKit/UIKit.h>

#define kDefaultDevName @"AppNotifyDevName"

@class AppNotifySampleViewController;
@class SendNotificationViewController;
@class SelectSoundViewController;

@interface AppNotifySampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    AppNotifySampleViewController *viewController;
	SendNotificationViewController *sendNotifyViewController;
	SelectSoundViewController *selectSoundViewController;

	NSString *deviceToken;
	NSString *deviceName;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AppNotifySampleViewController *viewController;
@property (nonatomic, retain) IBOutlet SendNotificationViewController *sendNotifyViewController;
@property (nonatomic, retain) IBOutlet SelectSoundViewController *selectSoundViewController;
@property (nonatomic, retain) NSString *deviceToken;
@property (nonatomic, retain) NSString *deviceName;

- (void)startPlayback:(NSString *)soundFile;
- (void)registerDevice:(id)sender;
- (void)sendPush:(id)sender deviceName:(NSString*)deviceName message:(NSString*)message badgeNumber:(NSInteger*)badgeNumber soundName:(NSString*)soundName;

@end

