//
//  NemoCoreTableCell.h
//  Pods
//
//  Created by peyman abdi on 11/1/15.
//
//

#import <UIKit/UIKit.h>

@interface NemoContact : NSObject

@property (nonatomic, copy) NSString*	Firstname;
@property (nonatomic, copy) NSString*	Lastname;
@property (nonatomic, copy, getter=getFullname) NSString*	Fullname;
@property (nonatomic, copy) UIImage*	Avatar;
@property (nonatomic, retain) NSArray*	PhoneNumbers;
@property (nonatomic, retain) NSArray*	Emails;

@end

@class NemoCoreTableCell;

@interface NemoCoreTableCellData : NSObject

@property (nonatomic, copy) NSString* CellIdentifier;
@property (nonatomic, weak) id	CallbackObject;
@property (nonatomic) SEL	CallbackMethod;
@property (nonatomic, weak) NemoCoreTableCell*	SourceCell;
@property (nonatomic) float	CellHeight;

-(instancetype) initWithIdentifier:(NSString*)identifier nSelector:(SEL)callback onObject:(id)object;

@end

@interface NemoCoreTableCell : UITableViewCell

@property (nonatomic, retain, setter=setDataSource:) NemoCoreTableCellData*	DataSource;

-(void)	UpdateTableCellFromDataSource;
-(void) SetDataSource:(NemoCoreTableCellData*)dataSource;
-(void)	PerformCallbackObjectSelector;

@end
