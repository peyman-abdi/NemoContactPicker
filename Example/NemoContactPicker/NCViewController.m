//
//  NCViewController.m
//  NemoContactPicker
//
//  Created by Peyman on 11/01/2015.
//  Copyright (c) 2015 Peyman. All rights reserved.
//

#import "NCViewController.h"

@interface NCViewController ()
@property (nonatomic) BOOL isSingleMode;
@property (nonatomic) BOOL isPhoneNumberMode;
@end

@implementation NCViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (IBAction)onOpenModal:(UIButton *)sender {
	self.isSingleMode = NO;
	NemoContactPicker* picker = [[NemoContactPicker alloc] initWithStyle:UITableViewStylePlain];

	picker.delegate = self;
	picker.ContactsDataFilters = ContactFilterAvatar | ContactFilterFullname | ContactFilterPhoneNumbers;
	picker.title = @"Contacts";

	UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:picker];
	[self presentViewController:nav animated:YES completion:nil];
}
- (IBAction)onOpenModalSingle:(id)sender {
	self.isSingleMode = YES;
	self.isPhoneNumberMode = NO;
	NemoContactPicker* picker = [[NemoContactPicker alloc] initWithStyle:UITableViewStylePlain];

	picker.delegate = self;
	picker.ContactsDataFilters = ContactFilterAvatar | ContactFilterFullname | ContactFilterPhoneNumbers;
	picker.title = @"Contacts";

	UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:picker];
	[self presentViewController:nav animated:YES completion:nil];
}
- (IBAction)onOpenModalSinglePhone:(id)sender {
	self.isSingleMode = YES;
	self.isPhoneNumberMode = YES;
	NemoContactPicker* picker = [[NemoContactPicker alloc] initWithStyle:UITableViewStylePlain];

	picker.delegate = self;
	picker.ContactsDataFilters = ContactFilterAvatar | ContactFilterFullname | ContactFilterPhoneNumbers;
	picker.title = @"Contacts";

	UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:picker];
	[self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Nemo Contact Picker delegate
-(void)	onContactPicker:(NemoContactPicker*)picker selected:(NSDictionary*)contact {
	NSLog(@"Selected: %@", contact);
	if (self.isSingleMode) {
		if (self.isPhoneNumberMode) {
			if ([[contact objectForKey:@"phones"] count] > 1) {
				[picker PrompetNumberPickerForContact:contact];
			} else {
				NSLog(@"contact already has 1 phone number only!");
				[picker.navigationController dismissViewControllerAnimated:YES completion:nil];
			}
		} else {
			[picker.navigationController dismissViewControllerAnimated:YES completion:nil];
		}
	}
}
-(void)	onContactPicker:(NemoContactPicker*)picker diselected:(NSDictionary*)contact {
	NSLog(@"Diselected: %@", contact);
}
-(void) onContactPickerDoneButtonPressed:(NemoContactPicker*)picker {
	[picker.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void) onContactPickerHasNoAccessToContacts:(NemoContactPicker*)picker {

}
-(void) onContactPicker:(NemoContactPicker *)picker selectedPhoneForContact:(NSDictionary *)contact {
	NSLog(@"Selected: %@", contact);
	[picker.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
