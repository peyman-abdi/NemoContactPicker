//
//  ContactCell.m
//  Pods
//
//  Created by peyman abdi on 11/9/15.
//
//

#import "NCPContactCell.h"

@implementation NCPContactCellData
-(instancetype) initWithPerson:(NSDictionary*)person withSelector:(SEL)callback onObject:(id)object {
	self = [super initWithIdentifier:@"ContactCell" nSelector:callback onObject:object];
	if (self) {
		self.Person = person;
	}
	return self;
}
@end

@implementation NCPContactCell

- (void)awakeFromNib {
	UIView* background = [[UIView alloc] init];
	[background setBackgroundColor:[UIColor lightGrayColor]];
	self.selectedBackgroundView = background;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) UpdateTableCellFromDataSource {
	NCPContactCellData* dataSource = (NCPContactCellData*)self.DataSource;
	[self.Title setAttributedText:[dataSource.Person objectForKey:@"contact"]];

	if (dataSource.Picked) {
		[self setBackgroundColor:[UIColor lightGrayColor]];
	} else {
		[self setBackgroundColor:[UIColor whiteColor]];
	}
}

@end
