//
//  ButtonCell.h
//  Pods
//
//  Created by peyman abdi on 11/1/15.
//
//

#import <UIKit/UIKit.h>
#import "NemoCoreTableCell.h"

@interface ButtonCellData : NemoCoreTableCellData
@property (nonatomic, copy) NSString*	Title;
-(instancetype) initWithTitle:(NSString*)title withSelector:(SEL)callback onObject:(id)object;
@end

@interface ButtonCell : NemoCoreTableCell
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *Button;
@end
