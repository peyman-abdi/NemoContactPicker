//
//  NemoContactPicker.m
//  Pods
//
//  Created by peyman abdi on 11/1/15.
//
//

#import <AddressBook/AddressBook.h>

#import "NemoContactPicker.h"
#import "SimpleTextCell.h"
#import "ButtonCell.h"

@interface NemoContactPicker ()
@property (nonatomic, retain) NSMutableArray*	Table;
@property (nonatomic, retain) NSMutableDictionary*	CellHeights;
@end

@implementation NemoContactPicker

-(instancetype) initWithStyle:(UITableViewStyle)style {
	self = [super initWithStyle:style];
	if (self) {
		_ShowHelperButtonOnAccessDenied = YES;
		_ShowHelperMessagesOnAccessDenied = YES;
		_ContactsDataFilters = ContactFilterComplete;
		_AccessDeniedMessage = @"This app requires access to your contacts to function properly. Please visit to the \"Privacy\" section in the iPhone Settings app.";
		_AccessDeniedButton = @"Open Settings";
	}
	return self;
}


- (void)viewDidLoad {
	self.Table = [NSMutableArray array];
	self.CellHeights = [NSMutableDictionary dictionary];
	
	ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
	
	if (status == kABAuthorizationStatusDenied || status == kABAuthorizationStatusRestricted) {
		[self addNoAccessTableCells];
	} else {
		
		CFErrorRef error = NULL;
		ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
		if (!addressBook) {
			NSLog(@"ABAddressBookCreateWithOptions error: %@", CFBridgingRelease(error));
			[self addNoAccessTableCells];
		} else {
			ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
				if (error) {
					NSLog(@"ABAddressBookRequestAccessWithCompletion error: %@", CFBridgingRelease(error));
					[self addNoAccessTableCells];
				} else {
					if (granted) {
						[self addAddressBookContacts:addressBook];
					} else {
						[self addNoAccessTableCells];
					}
					
					CFRelease(addressBook);
				}
			});
		}
	}
	
	[self RegisterIdentifier:@"ButtonCell"];
	[self RegisterIdentifier:@"SimpleTextCell"];
	
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}
#pragma mark - Helper methods
-(void) addAddressBookContacts:(ABAddressBookRef)addressBook {
	NSArray *allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
	NSInteger numberOfPeople = [allPeople count];
	
	for (NSInteger i = 0; i < numberOfPeople; i++) {
		ABRecordRef person = (__bridge ABRecordRef)allPeople[i];
		
		NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
		NSString *lastName  = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
		NSLog(@"Name:%@ %@", firstName, lastName);
		
		ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
		
		CFIndex numberOfPhoneNumbers = ABMultiValueGetCount(phoneNumbers);
		for (CFIndex i = 0; i < numberOfPhoneNumbers; i++) {
			NSString *phoneNumber = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumbers, i));
			NSLog(@"  phone:%@", phoneNumber);
		}
		
		CFRelease(phoneNumbers);
		
		NSLog(@"=============================================");
	}
}

-(void) addNoAccessTableCells {
	NSMutableArray* section = [NSMutableArray array];
	[section addObject:@""];
	[self.Table addObject:section];
	
	if (self.ShowHelperMessagesOnAccessDenied) {
		[section addObject:[[SimpleTextCellData alloc] initWithString:_AccessDeniedMessage]];
	}
}

-(void)	RegisterIdentifier:(NSString*)identifier
{
	NSBundle* bundle = [NSBundle bundleForClass:[ButtonCell class]];
	NSArray* nib = [bundle loadNibNamed:identifier owner:self options:nil];
	UIView *cellView = (UIView *)nib[0];
	float height = cellView.bounds.size.height;
	[self.CellHeights setObject:[NSNumber numberWithFloat:height] forKey:identifier];
	[self.tableView registerNib: [UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
}



#pragma mark - Table controller methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.Table.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger count = [[self.Table objectAtIndex:section] count];
	return count > 0 ? count - 1: 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NemoCoreTableCellData* data = [[self.Table objectAtIndex:indexPath.section] objectAtIndex:indexPath.row + 1];
	NemoCoreTableCell* cell = (NemoCoreTableCell*)[tableView dequeueReusableCellWithIdentifier:data.CellIdentifier forIndexPath:indexPath];
	
	[cell SetDataSource:data];
	[cell UpdateTableCellFromDataSource];
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[self.Table objectAtIndex:0] objectAtIndex:0];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NemoCoreTableCellData* data = [[self.Table objectAtIndex:indexPath.section] objectAtIndex:indexPath.row + 1];
	if (data.CellHeight > 0) {
		return data.CellHeight;
	} else {
		return [[self.CellHeights objectForKey:data.CellIdentifier] floatValue];
	}
}

@end
