//
//  NemoContactPicker.m
//  Pods
//
//  Created by peyman abdi on 11/1/15.
//
//

#import <AddressBook/AddressBook.h>

#import "NemoContactPicker.h"
#import "NCPSimpleTextCell.h"
#import "NCPButtonCell.h"
#import "NCPContactCell.h"

#define FILTER_DATA(key, value, filter) if ((self.ContactsDataFilters & filter)) { if (value) { [person_data setObject:value forKey:key]; } else { [person_data setObject:[NSNull null] forKey:key]; } }

@interface NemoContactPicker ()
@property (nonatomic, retain) NSMutableArray*	Table;
@property (nonatomic, retain) NSMutableArray*	SearchResultTable;
@property (nonatomic, retain) NSMutableDictionary*	CellHeights;
@property (nonatomic, readonly, retain) NSArray*	SectionIndexes;
@property (nonatomic, readonly, retain) NSDictionary*		IndexOfSection;
@property (nonatomic, retain) UISearchDisplayController*    SearchController;
@property (nonatomic, retain) UISearchBar*					SearchBar;
@property (nonatomic, copy) NSDictionary*	ActionSheetContact;
@end

@implementation NemoContactPicker

-(instancetype) initWithStyle:(UITableViewStyle)style {
	self = [super initWithStyle:style];
	if (self) {
		_ShowHelperButtonOnAccessDenied = YES;
		_ShowHelperMessagesOnAccessDenied = YES;
		_ContactsDataFilters = ContactFilterComplete;
		_ShowSearchBar = YES;
		_AccessDeniedMessageString = @"This app requires access to your contacts to function properly. Please visit to the \"Privacy\" section in the iPhone Settings app.";
		_AccessDeniedButtonString = @"Open Settings";
		_DoneButtonString = @"Done";
		_PickNumberMessageString = @"Please pick a number";
		_CancelButtonString = @"Cancel";
	}
	return self;
}

- (void)viewDidLoad {
	_SelectedContacts = [NSMutableArray array];
	_SectionIndexes = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#"];
	_Table = [NSMutableArray array];
	_SearchResultTable = [NSMutableArray array];
	_CellHeights = [NSMutableDictionary dictionary];
	
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
						[self addContactsFromList];
					} else {
						[self addNoAccessTableCells];
					}
					
					CFRelease(addressBook);
				}
			});
		}
	}

	if (self.ShowSearchBar) {
		self.SearchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
		[self.SearchBar sizeToFit];
		self.SearchBar.delegate = self;
		self.SearchBar.searchBarStyle = UISearchBarStyleMinimal;
		self.SearchBar.translucent = YES;
		self.SearchBar.barStyle = UIBarStyleBlackTranslucent;
		self.SearchBar.placeholder = @"";
		self.SearchController = [[UISearchDisplayController alloc] initWithSearchBar:self.SearchBar contentsController:self];
		self.SearchController.delegate = self;
		self.SearchController.searchResultsDataSource = self;
		self.SearchController.searchResultsDelegate = self;
		self.tableView.tableHeaderView = self.SearchBar;
	}

	if (self.DoneButtonString) {
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.DoneButtonString style:UIBarButtonItemStyleDone target:self action:@selector(onDoneSelectingContacts:)];
	}

	[self RegisterIdentifier:@"NCPButtonCell" withClass:[NCPButtonCell class]];
	[self RegisterIdentifier:@"NCPSimpleTextCell" withClass:[NCPSimpleTextCell class]];
	[self RegisterIdentifier:@"NCPContactCell" withClass:[NCPContactCell class]];

	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

-(void) PrompetNumberPickerForContact:(NSDictionary *)contact {
	NSArray* phone_numbers = [contact objectForKey:NCPKeyPhoneNumbers];
	if (phone_numbers) {
		UIActionSheet* picker = [[UIActionSheet alloc] initWithTitle:self.PickNumberMessageString delegate:self cancelButtonTitle:self.CancelButtonString destructiveButtonTitle:nil otherButtonTitles:nil];

		for (NSDictionary* phone in phone_numbers) {
			[picker addButtonWithTitle:[NSString stringWithFormat:@"%@: %@", [phone objectForKey:@"label"], [phone objectForKey:@"number"]]];
		}
		self.ActionSheetContact = contact;
		[picker showInView:self.view];
	}
}

-(void) onDoneSelectingContacts:(UIBarButtonItem*)sender {
	if (self.delegate && [self.delegate respondsToSelector:@selector(onContactPickerDoneButtonPressed:)]) {
		[self.delegate performSelector:@selector(onContactPickerDoneButtonPressed:) withObject:self];
	}
}

#pragma mark - action sheet deleage
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (self.delegate && [self.delegate respondsToSelector:@selector(onContactPicker:selectedPhoneForContact:)]) {
		NSMutableDictionary* contact = [NSMutableDictionary dictionaryWithDictionary:self.ActionSheetContact];
		[contact setObject:@(buttonIndex-1) forKey:@"selected"];
		[self.delegate performSelector:@selector(onContactPicker:selectedPhoneForContact:) withObject:self withObject:contact];
	}
}

#pragma mark - Helper methods
-(void) addAddressBookContacts:(ABAddressBookRef)addressBook {
	NSArray *allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
	NSInteger numberOfPeople = [allPeople count];
	NSMutableArray* people = [NSMutableArray array];

	int min_character = [@"A" characterAtIndex:0];
	int max_character = [@"Z" characterAtIndex:0];

	for (NSInteger i = 0; i < numberOfPeople; i++) {
		NSMutableDictionary* person_data = [NSMutableDictionary dictionary];

		ABRecordRef person = (__bridge ABRecordRef)allPeople[i];
		
		NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
		NSString *lastName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
		NSString *fullName = [NSString stringWithFormat:@"%@%@%@", (firstName)? firstName:@"", (firstName)? @" ":@"" ,(lastName)? lastName:@""];
		[person_data setObject:fullName forKey:@"search"];
		if (lastName && ![lastName isEqualToString:@""]) {
			NSString* section_value = [[lastName uppercaseString] substringWithRange:NSMakeRange(0, 1)];
			unichar character = [section_value characterAtIndex:0];
			if (character < min_character || character > max_character) {
				section_value = @"#";
			}
			[person_data setObject:section_value forKey:@"section"];

			NSMutableAttributedString* contact_name = [[NSMutableAttributedString alloc] initWithString:fullName];
			[contact_name beginEditing];
			[contact_name addAttribute:NSFontAttributeName
								 value:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]
								 range:NSMakeRange((firstName)? firstName.length+1:0, lastName.length)];
			[contact_name endEditing];
			[person_data setObject:contact_name forKey:@"contact"];
		} else if (firstName && ![firstName isEqualToString:@""]) {
			NSString* section_value = [[firstName uppercaseString] substringWithRange:NSMakeRange(0, 1)];
			unichar character = [section_value characterAtIndex:0];
			if (character < min_character || character > max_character) {
				section_value = @"#";
			}
			[person_data setObject:section_value forKey:@"section"];

			NSMutableAttributedString* contact_name = [[NSMutableAttributedString alloc] initWithString:fullName];
			[contact_name beginEditing];
			[contact_name addAttribute:NSFontAttributeName
								 value:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]
								 range:NSMakeRange(0, firstName.length)];
			[contact_name endEditing];
			[person_data setObject:contact_name forKey:@"contact"];
		} else {
			continue;
		}

		FILTER_DATA(NCPKeyFirstname, firstName, ContactFilterFirstname)
		FILTER_DATA(NCPKeyLastname, lastName, ContactFilterLastname)
		FILTER_DATA(NCPKeyFullname, fullName, ContactFilterFullname)

		if ((self.ContactsDataFilters & ContactFilterPhoneNumbers)) {
			NSMutableArray* phone_numbers = [NSMutableArray array];
			ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
			CFIndex numberOfPhoneNumbers = ABMultiValueGetCount(phoneNumbers);
			for (CFIndex i = 0; i < numberOfPhoneNumbers; i++) {
				NSString *phoneNumber = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumbers, i));
				NSString *phoneLabel = CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phoneNumbers, i));
				phoneLabel = [phoneLabel stringByReplacingOccurrencesOfString:@"_$!<" withString:@""];
				phoneLabel = [phoneLabel stringByReplacingOccurrencesOfString:@">!$_" withString:@""];

				if (phoneNumber) {
					[phone_numbers addObject:@{@"label": phoneLabel, @"number": phoneNumber}];
				}
			}
			[person_data setObject:phone_numbers forKey:NCPKeyPhoneNumbers];
			CFRelease(phoneNumbers);
		}

		if ((self.ContactsDataFilters & ContactFilterEmails)) {
			NSMutableArray* emails_address = [NSMutableArray array];
			ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
			CFIndex numberOfEmails = ABMultiValueGetCount(emails);
			for (CFIndex i = 0; i < numberOfEmails; i++) {
				NSString* email = CFBridgingRelease(ABMultiValueCopyValueAtIndex(emails, i));
				if (emails) {
					[emails_address addObject:email];
				}
			}
			[person_data setObject:emails_address forKey:NCPKeyEmails];
			CFRelease(emails);
		}

		if ((self.ContactsDataFilters & ContactFilterAvatar)) {
			if (ABPersonHasImageData(person)) {
				NSData *imgData = (__bridge NSData*)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatOriginalSize);
				UIImage* img = [UIImage imageWithData: imgData];
				if (img) {
					[person_data setObject:img forKey:NCPKeyAvatar];
				} else {
					[person_data setObject:[NSNull null] forKey:NCPKeyAvatar];
				}
			} else {
				[person_data setObject:[NSNull null] forKey:NCPKeyAvatar];
			}
		}

		[people addObject:person_data];
	}

	self.Contacts = [people sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		NSString* key_1 = [obj1 objectForKey:@"key"];
		NSString* key_2 = [obj2 objectForKey:@"key"];
		return [key_1 compare:key_2];
	}];
}

-(void) addContactsFromList {
	self.Table = [NSMutableArray array];
	NSMutableDictionary* sections = [NSMutableDictionary dictionary];

	for (NSDictionary* person in self.Contacts) {
		NSString* start = [person objectForKey:@"section"];
		if ([sections objectForKey:start]) {
			[[sections objectForKey:start] addObject:person];
		} else {
			NSMutableArray* section_array = [NSMutableArray array];
			[section_array addObject:person];
			[sections setObject:section_array forKey:start];
		}
	}

	NSArray* starts = [sections.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	NSMutableDictionary* section_indexer = [NSMutableDictionary dictionary];
	int indexer = 0;
	for (NSString* start in starts) {
		[section_indexer setObject:@(indexer++) forKey:start];
		NSMutableArray* section = [NSMutableArray array];
		[section addObject:start];
		NSArray* peoples = [sections objectForKey:start];
		for (NSDictionary* person in peoples) {
			[section addObject:[[NCPContactCellData alloc] initWithPerson:person withSelector:nil onObject:nil]];
		}
		[self.Table addObject:section];
	}
	_IndexOfSection = section_indexer;
}

-(void) addNoAccessTableCells {
	NSMutableArray* section = [NSMutableArray array];
	[section addObject:@""];
	[self.Table addObject:section];
	
	if (self.ShowHelperMessagesOnAccessDenied) {
		[section addObject:[[NCPSimpleTextCellData alloc] initWithString:_AccessDeniedMessageString]];
	}
	if (self.ShowHelperButtonOnAccessDenied && &UIApplicationOpenSettingsURLString != NULL) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
	}

	if (self.delegate && [self.delegate respondsToSelector:@selector(onContactPickerHasNoAccessToContacts:)]) {
		[self.delegate performSelector:@selector(onContactPickerHasNoAccessToContacts:) withObject:self];
	}
}

-(void)	RegisterIdentifier:(NSString*)identifier withClass:(Class)class
{
	NSBundle* bundle = [NSBundle bundleForClass:class];
	NSArray* nib = [bundle loadNibNamed:identifier owner:self options:nil];
	UIView *cellView = (UIView *)nib[0];
	float height = cellView.bounds.size.height;
	[self.CellHeights setObject:[NSNumber numberWithFloat:height] forKey:identifier];
	[self.tableView registerNib: [UINib nibWithNibName:identifier bundle:bundle] forCellReuseIdentifier:identifier];
	if (self.SearchController) {
		[self.SearchController.searchResultsTableView registerNib:[UINib nibWithNibName:identifier bundle:bundle] forCellReuseIdentifier:identifier];
	}
}

#pragma mark - Table controller methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return (self.SearchController && self.SearchController.searchResultsTableView == tableView)? self.SearchResultTable.count:self.Table.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger count = 0;
	if (self.SearchController && self.SearchController.searchResultsTableView == tableView) {
		count = [[self.SearchResultTable objectAtIndex:section] count];
	} else {
		count = [[self.Table objectAtIndex:section] count];
	}

	return count > 0 ? count - 1: 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSArray* table = (self.SearchController && self.SearchController.searchResultsTableView == tableView)? self.SearchResultTable:self.Table;
	NemoCoreTableCellData* data = [[table objectAtIndex:indexPath.section] objectAtIndex:indexPath.row + 1];
	NemoCoreTableCell* cell = (NemoCoreTableCell*)[tableView dequeueReusableCellWithIdentifier:data.CellIdentifier forIndexPath:indexPath];
	
	[cell SetDataSource:data];
	[cell UpdateTableCellFromDataSource];
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return (self.SearchController && self.SearchController.searchResultsTableView == tableView)?
				[[self.SearchResultTable objectAtIndex:section] objectAtIndex:0]:[[self.Table objectAtIndex:section] objectAtIndex:0];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSArray* table = (self.SearchController && self.SearchController.searchResultsTableView == tableView)? self.SearchResultTable:self.Table;
	NemoCoreTableCellData* data = [[table objectAtIndex:indexPath.section] objectAtIndex:indexPath.row + 1];
	if (data.CellHeight > 0) {
		return data.CellHeight;
	} else {
		return [[self.CellHeights objectForKey:data.CellIdentifier] floatValue];
	}
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	return (self.SearchController && self.SearchController.searchResultsTableView == tableView)? nil:self.SectionIndexes;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	return [[self.IndexOfSection objectForKey:title] intValue];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSArray* table = (self.SearchController && self.SearchController.searchResultsTableView == tableView)? self.SearchResultTable:self.Table;

	NemoCoreTableCellData* cell_data = [[table objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1];
	if ([cell_data isKindOfClass:[NCPContactCellData class]]) {
		NCPContactCellData* contact_cell = (NCPContactCellData*)cell_data;
		contact_cell.Picked = !contact_cell.Picked;

		if (contact_cell.Picked) {
			[self.SelectedContacts addObject:contact_cell.Person];

			if (self.delegate && [self.delegate respondsToSelector:@selector(onContactPicker:selected:)]) {
				[self.delegate performSelector:@selector(onContactPicker:selected:) withObject:self withObject:contact_cell.Person];
			}
		} else {
			[self.SelectedContacts removeObject:contact_cell.Person];

			if (self.delegate && [self.delegate respondsToSelector:@selector(onContactPicker:diselected:)]) {
				[self.delegate performSelector:@selector(onContactPicker:diselected:) withObject:self withObject:contact_cell.Person];
			}
		}

		if (contact_cell.SourceCell) {
			[contact_cell.SourceCell UpdateTableCellFromDataSource];
		}

		[tableView deselectRowAtIndexPath:indexPath animated:NO];
	}
}

#pragma mark - Search controller delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	NSPredicate* filter = [NSPredicate predicateWithFormat:@"search contains[cis] %@", searchText];
	NSArray* search_result = [self.Contacts filteredArrayUsingPredicate:filter];

	self.SearchResultTable = [NSMutableArray array];
	NSMutableArray* section = [NSMutableArray array];
	[section addObject:@""];
	for (NSDictionary* person in search_result) {
		[section addObject:[[NCPContactCellData alloc] initWithPerson:person withSelector:nil onObject:nil]];
	}
	[self.SearchResultTable addObject:section];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
}

@end
