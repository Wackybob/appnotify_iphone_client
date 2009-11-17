//
// AppNotify Sample Application
// Copyright (c) Select Start Studios, 2009
// All rights reserved.
//
// Licensed under the BSD Simplified License
//

#import <UIKit/UIKit.h>
#import "AppNotifySampleAppDelegate.h"

@class SendNotificationViewController;


@interface SelectSoundViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	AppNotifySampleAppDelegate *appDelegate;
	
	SendNotificationViewController *sendNotifyViewController;
	
	IBOutlet UIPickerView *soundPicker;
	NSMutableArray *soundArray;
	NSString *selectedSound;
	
	UIToolbar *_keyboardToolbar;
}

@property (nonatomic, retain) AppNotifySampleAppDelegate *appDelegate;
@property (nonatomic, retain) SendNotificationViewController *sendNotifyViewController;
@property (nonatomic, retain) IBOutlet UIPickerView *soundPicker;
@property (nonatomic, retain) UIToolbar *keyboardToolbar;

- (void) selectSound:(id)sender;

@end
