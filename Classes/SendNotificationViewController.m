//
// AppNotify Sample Application
// Copyright (c) Select Start Studios, 2009
// All rights reserved.
//
// Licensed under the BSD Simplified License
//

#import "SendNotificationViewController.h"
#import "AppNotifySampleAppDelegate.h"
#import "ASIFormDataRequest.h"
#import "AppNotifySampleViewController.h"
#import "SelectSoundViewController.h"
#import "SendingViewController.h"

#define kNoSound @"No sound selected"


@implementation SendNotificationViewController

@synthesize appDelegate;
@synthesize deviceName;
@synthesize message;
@synthesize selectedSound;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	sendingViewController = [[SendingViewController alloc] initWithNibName: @"SendingView" bundle: nil];
	UIView *sendingView = sendingViewController.view;
	sendingView.frame = self.view.frame;
	sendingView.alpha = 0;
}

- (void)showSendingScreen
{
	UIView *sendingView = sendingViewController.view;
	[self.view addSubview:sendingView];	
	//display the sending view
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationRepeatCount:1];
	sendingView.alpha = 0.8;
	[UIView commitAnimations];
}

- (void)didFinishHiding
{
	[sendingViewController.view removeFromSuperview];
}

- (void)hideSendingScreen
{
	UIView *sendingView = sendingViewController.view;

	//display the sending view
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationRepeatCount:1];
	[UIView setAnimationDidStopSelector:@selector(didFinishHiding)];
	sendingView.alpha = 0.0;	
	[UIView commitAnimations];
}

- (IBAction) selectSound:(id)sender
{		
	UIView *theWindow = [self.view superview];
	UIView *soundController = appDelegate.selectSoundViewController.view;
	//Push the sound controller of the screen and make it invisible
	soundController.alpha = 0;
	soundController.bounds = CGRectMake(0, -soundController.bounds.size.height, soundController.bounds.size.width, soundController.bounds.size.height);
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationRepeatCount:1];
	
	//Now push it back onto the screen (with animation)
	soundController.alpha = 0.9;
	soundController.bounds = CGRectMake(0, 0, soundController.bounds.size.width, soundController.bounds.size.height);
	[theWindow addSubview:soundController];
	[UIView commitAnimations];
}

- (void) setSound:(NSString*)sound
{
	if (sound == nil) {
		[selectedSound setText:kNoSound];
	} else {
		[selectedSound setText:sound];
	}
}

- (IBAction) send:(id)sender
{
	[self showSendingScreen];
	// Display the network activity indicator
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	NSString *sound = nil;
	if (selectedSound.text != kNoSound) {
		sound = [NSString stringWithFormat:@"%@.wav", [selectedSound text]];
	}

	NSString *pushMsg = [[NSString alloc] initWithFormat:@"%@: %@", ((AppNotifySampleAppDelegate*)[UIApplication sharedApplication].delegate).deviceName,[message text], nil]; 
	
	[appDelegate sendPush:self deviceName:[deviceName text] message:pushMsg badgeNumber:nil soundName:sound];
	[pushMsg release];
}

- (IBAction) back:(id)sender
{
	// get the view that's currently showing
	UIView *currentView = self.view;
	// get the the underlying UIWindow, or the view containing the current view view
	UIView *theWindow = [currentView superview];
	
	UIView *newView = appDelegate.viewController.view;
	
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

- (void)successMethod:(ASIHTTPRequest *)request
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	[self hideSendingScreen];
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	[self hideSendingScreen];
	
	NSError *error = [request error];
	UIAlertView *someError = [[UIAlertView alloc] initWithTitle: 
							  @"Network error" message: @"Error sending push notification"
													   delegate: self
											  cancelButtonTitle: @"Ok"
											  otherButtonTitles: nil];
	[someError show];
	[someError release];
	NSLog(@"ERROR: NSError query result: %@", error);
}

- (BOOL)textFieldShouldReturn:(id)sender
{
	[sender resignFirstResponder];
	return YES;
}

- (void)dealloc
{
	[sendingViewController release];
	[appDelegate release];
	[selectedSound release];
	[message release];
	[deviceName release];
    [super dealloc];
}

@end
