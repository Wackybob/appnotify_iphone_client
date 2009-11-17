//
// AppNotify Sample Application
// Copyright (c) Select Start Studios, 2009
// All rights reserved.
//
// Licensed under the BSD Simplified License
//

#import <UIKit/UIKit.h>
#import "AppNotifySampleAppDelegate.h"

@interface AppNotifySampleViewController : UIViewController {
	AppNotifySampleAppDelegate *appDelegate;
	
	IBOutlet UILabel *tokenDisplay;
	IBOutlet UITextField *nameDisplay;
	IBOutlet UIButton *registerButton;
	IBOutlet UIButton *sendNotificationButton;
}

@property (nonatomic, retain) AppNotifySampleAppDelegate *appDelegate;
@property (nonatomic, retain) IBOutlet UILabel *tokenDisplay;
@property (nonatomic, retain) IBOutlet UITextField *nameDisplay;
@property (nonatomic, retain) IBOutlet UIButton *registerButton;
@property (nonatomic, retain) IBOutlet UIButton *sendNotificationButton;

- (IBAction) sendNotification:(id) sender;
- (IBAction) registerName:(id) sender;

@end

