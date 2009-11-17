//
// AppNotify Sample Application
// Copyright (c) Select Start Studios, 2009
// All rights reserved.
//
// Licensed under the BSD Simplified License
//

#import "SelectSoundViewController.h"
#import "SendNotificationViewController.h"

#define kNoSound @"No Sound"
#define kSound1 @"Telephone"
#define kSound2 @"WhistleFlute"
#define kSound3 @"Hammering"
#define kSound4 @"PillBottle"

@implementation SelectSoundViewController

@synthesize appDelegate;
@synthesize soundPicker;
@synthesize sendNotifyViewController;
@synthesize keyboardToolbar = _keyboardToolbar;

- (void)selectSound:(id)sender
{	
	if (selectedSound == kNoSound) {
		[sendNotifyViewController setSound:nil];
	} else {
		[sendNotifyViewController setSound:selectedSound];
	}
	
	UIView *theWindow = [self.view superview];
	UIView *soundController = appDelegate.selectSoundViewController.view;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationRepeatCount:1];
	
	//Pull it off of the screen
	soundController.alpha = 0.0;
	soundController.bounds = CGRectMake(0, -soundController.bounds.size.height, soundController.bounds.size.width, soundController.bounds.size.height);
	[theWindow addSubview:soundController];
	[UIView commitAnimations];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	soundArray = [[NSMutableArray alloc] init];
	[soundArray addObject:kNoSound];
	[soundArray addObject:kSound1];
	[soundArray addObject:kSound2];
	[soundArray addObject:kSound3];
	[soundArray addObject:kSound4];
	
	selectedSound = kNoSound;

	// set up the UIToolbar to hold the done button
	self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
	self.keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
	
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" 
																	  style:UIBarButtonItemStyleDone 
																	 target:self 
																	 action:@selector(selectSound)];
	
	NSArray *items = [[[NSArray alloc] initWithObjects: barButtonItem, nil] autorelease];
	[self.keyboardToolbar setItems:items];	
	[items release];	
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
	return [soundArray count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [soundArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	selectedSound = [soundArray objectAtIndex:row];
	NSLog(@"Selected Color: %@. Index of selected color: %i", selectedSound, row);
}

- (void)dealloc
{
	[appDelegate release];
	[sendNotifyViewController release];
	[soundPicker release];
	[soundArray release];
    [super dealloc];
}

@end
