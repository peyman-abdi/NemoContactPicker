//
//  ContactCell.h
//  Pods
//
//  Created by peyman abdi on 11/9/15.
//
//

#import <UIKit/UIKit.h>
#import "NemoCoreTableCell.h"

@interface NCPContactCellData : NemoCoreTableCellData
@property (nonatomic, copy) NSDictionary*	Person;
@property (nonatomic) BOOL	Picked;
-(instancetype) initWithPerson:(NSDictionary*)person withSelector:(SEL)callback onObject:(id)object;
@end

@interface NCPContactCell : NemoCoreTableCell
@property (weak, nonatomic) IBOutlet UILabel *Title;
@end
