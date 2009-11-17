//
// AppNotify Sample Application
// Copyright (c) Select Start Studios, 2009
// All rights reserved.
//
// Licensed under the BSD Simplified License
//

#import <UIKit/UIKit.h>
#import "AppNotifySampleAppDelegate.h"
#import "SendingViewController.h"

@interface SendNotificationViewController : UIViewController {
	AppNotifySampleAppDelegate *appDelegate;
	SendingViewController *sendingViewController;

	IBOutlet UITextField *deviceName;
	IBOutlet UITextField *message;
	IBOutlet UILabel *selectedSound;
}

@property (nonatomic, retain) AppNotifySampleAppDelegate *appDelegate;
@property (nonatomic, retain) IBOutlet UITextField *deviceName;
@property (nonatomic, retain) IBOutlet UITextField *message;
@property (nonatomic, retain) IBOutlet UILabel *selectedSound;

- (IBAction) selectSound:(id)sender;
- (void) setSound:(NSString*)sound;
- (IBAction) send:(id)sender;
- (IBAction) back:(id)sender;

@end
