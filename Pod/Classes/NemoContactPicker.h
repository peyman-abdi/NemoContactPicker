//
//  NemoContactPicker.h
//  Pods
//
//  Created by peyman abdi on 11/1/15.
//
//

#import <UIKit/UIKit.h>

#define NCPKeyFirstname		@"firstname"
#define NCPKeyLastname		@"lastname"
#define NCPKeyAvatar		@"avatar"
#define NCPKeyPhoneNumbers	@"phones"
#define NCPKeyEmails		@"emails"
#define NCPKeyFullname		@"fullname"

typedef NS_OPTIONS(NSUInteger, ContactFilters) {
	ContactFilterFirstname	= 1 << 0,
	ContactFilterLastname	= 1 << 1,
	ContactFilterFullname	= 1 << 2,
	ContactFilterAvatar		= 1 << 3,
	ContactFilterPhoneNumbers	= 1 << 4,
	ContactFilterEmails			= 1 << 5,
	
	ContactFilterComplete = 0xFF
};

@class NemoContactPicker;

@protocol NemoContactPickerDelegate <NSObject>
@optional
-(void)	onContactPicker:(NemoContactPicker*)picker selected:(NSDictionary*)contact;
-(void)	onContactPicker:(NemoContactPicker*)picker diselected:(NSDictionary*)contact;
-(void) onContactPicker:(NemoContactPicker *)picker selectedPhoneForContact:(NSDictionary*)contact;
-(void) onContactPickerDoneButtonPressed:(NemoContactPicker*)picker;
-(void) onContactPickerHasNoAccessToContacts:(NemoContactPicker*)picker;
@end

@interface NemoContactPicker : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate, UIActionSheetDelegate>

@property (nonatomic, retain) NSArray*			Contacts;
@property (nonatomic, retain) NSMutableArray*	SelectedContacts;

@property (nonatomic) int	ContactsDataFilters;							// default: complete
@property (nonatomic, weak) id<NemoContactPickerDelegate>	delegate;
@property (nonatomic) BOOL	ShowHelperMessagesOnAccessDenied;			// default: true
@property (nonatomic) BOOL	ShowHelperButtonOnAccessDenied;				// default: true
@property (nonatomic) BOOL	ShowSearchBar;								// default: true

@property (nonatomic, copy) NSString*	AccessDeniedMessageString;
@property (nonatomic, copy) NSString*	AccessDeniedButtonString;
@property (nonatomic, copy) NSString*	DoneButtonString;
@property (nonatomic, copy) NSString*	CancelButtonString;
@property (nonatomic, copy) NSString*	PickNumberMessageString;

-(instancetype) initWithStyle:(UITableViewStyle)style;

-(void) PrompetNumberPickerForContact:(NSDictionary*)contact;

@end
