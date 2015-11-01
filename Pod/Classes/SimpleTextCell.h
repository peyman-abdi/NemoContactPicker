//
//  SimpleTextCell.h
//  Pods
//
//  Created by peyman abdi on 11/1/15.
//
//

#import <UIKit/UIKit.h>
#import "NemoCoreTableCell.h"

@interface SimpleTextCellData : NemoCoreTableCellData
@property (nonatomic, copy) NSString*	String;
-(instancetype) initWithString:(NSString*)string;
@end

@interface SimpleTextCell : NemoCoreTableCell
@property (unsafe_unretained, nonatomic) IBOutlet UITextView *TextView;
@end
