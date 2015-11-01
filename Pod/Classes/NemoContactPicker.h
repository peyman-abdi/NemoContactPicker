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

typedef NS_OPTIONS(NSUInteger, ContactFilters) {
	ContactFilterFirstname	= 1 << 0,
	ContactFilterLastname	= 1 << 1,
	ContactFilterFullname	= 1 << 2,
	ContactFilterAvatar		= 1 << 3,
	ContactFilterPhoneNumbers	= 1 << 4,
	ContactFilterEmails			= 1 << 5,
	
	ContactFilterComplete = 0xFF
};

@protocol NemoContactPickerDelegate <NSObject>
@optional

-(void)	onContactPicked:(NSDictionary*)contact;
-(void) onContactsPicked:(NSArray*)contacts;
-(void) onContactPickerClosed;
-(void)	onContactPickerHasNoAccess;

@end

@interface NemoContactPicker : UITableViewController

@property (nonatomic, retain) NSMutableArray*	Contacts;
@property (nonatomic) int	ContactsDataFilters;							// default: complete
@property (nonatomic, weak) id<NemoContactPickerDelegate>	delegate;
@property (nonatomic) BOOL	ShowHelperMessagesOnAccessDenied;			// default: true
@property (nonatomic) BOOL	ShowHelperButtonOnAccessDenied;				// default: true
@property (nonatomic) BOOL	ShowSearchBar;								// default: true

@property (nonatomic, copy) NSString*	AccessDeniedMessage;
@property (nonatomic, copy) NSString*	AccessDeniedButton;

-(instancetype) initWithStyle:(UITableViewStyle)style;

@end
