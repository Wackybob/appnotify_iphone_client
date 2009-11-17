//
// AppNotify Sample Application
// Copyright (c) Select Start Studios, 2009
// All rights reserved.
//
// Licensed under the BSD Simplified License
//

#import "AppNotifySampleViewController.h"
#import "AppNotifySampleAppDelegate.h"
#import "ASIFormDataRequest.h"
#import "SendNotificationViewController.h";

@implementation AppNotifySampleViewController

@synthesize appDelegate;
@synthesize tokenDisplay;
@synthesize nameDisplay;
@synthesize registerButton;
@synthesize sendNotificationButton;

- (IBAction) sendNotification:(id)sender
{	
	// get the view that's currently showing
	UIView *currentView = self.view;
	// get the the underlying UIWindow, or the view containing the current view view
	UIView *theWindow = [currentView superview];
	
	UIView *newView = appDelegate.sendNotifyViewController.view;
	
	// remove the current view and replace with myView1
	[currentView removeFromSuperview];
	[theWindow addSubview:newView];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:theWindow cache:YES];
	[currentView removeFromSuperview];
	[theWindow addSubview:newView];
	[UIView commitAnimations];
}

- (IBAction) registerName:(id) sender
{
	appDelegate.deviceName = nameDisplay.text;
	
	[appDelegate registerDevice:self];
}

- (void)successMethod:(ASIHTTPRequest *) request
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	// Save device name in user defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setValue: appDelegate.deviceName forKey: kDefaultDevName];
	
	UIAlertView *success = [[UIAlertView alloc] initWithTitle: 
								@"Success" message: @"Name registered with AppNotify"
													 delegate: self
											cancelButtonTitle: @"Ok"
											otherButtonTitles: nil];
	
	[success show];
	[success release];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	NSString *model = [[UIDevice currentDevice] model];
	if ([model compare: @"iPhone Simulator"] == NSOrderedSame) {
		[nameDisplay setEnabled:FALSE];
		[registerButton setEnabled:FALSE];
		[sendNotificationButton setEnabled:FALSE];
		
		UIAlertView *someError = [[UIAlertView alloc] initWithTitle: 
								  @"Simulator not supported" message: @"Push notifications are not supported in the simulator"
														   delegate: self
												  cancelButtonTitle: @"Ok"
												  otherButtonTitles: nil];
		[someError show];
		[someError release];		
	}
}

- (BOOL)textFieldShouldReturn:(id)sender
{
	[sender resignFirstResponder];
	return YES;
}

- (void)dealloc
{
	[nameDisplay release];
	[tokenDisplay release];
    [super dealloc];
}

@end
