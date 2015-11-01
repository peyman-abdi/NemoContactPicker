//
//  SimpleTextCell.m
//  Pods
//
//  Created by peyman abdi on 11/1/15.
//
//

#import "SimpleTextCell.h"

@implementation SimpleTextCellData
-(instancetype) initWithString:(NSString *)string {
	self = [super initWithIdentifier:@"SimpleTextCell" nSelector:nil onObject:nil];
	if (self) {
		self.String = string;
		NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14]};
		CGRect rect = [self.String boundingRectWithSize:CGSizeMake(280, CGFLOAT_MAX)
												options:NSStringDrawingUsesLineFragmentOrigin
											 attributes:attributes
												context:nil];
		self.CellHeight = rect.size.height + 20 + rect.origin.y;
	}
	return self;
}
@end

@implementation SimpleTextCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

-(void) UpdateTableCellFromDataSource {
	SimpleTextCellData* dataSource = (SimpleTextCellData*)self.DataSource;
	[self.TextView setText:dataSource.String];
}

@end

