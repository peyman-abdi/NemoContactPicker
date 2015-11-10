//
//  SimpleTextCell.m
//  Pods
//
//  Created by peyman abdi on 11/1/15.
//
//

#import "NCPSimpleTextCell.h"

@implementation NCPSimpleTextCellData
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

@implementation NCPSimpleTextCell

- (void)awakeFromNib {
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

-(void) UpdateTableCellFromDataSource {
	NCPSimpleTextCellData* dataSource = (NCPSimpleTextCellData*)self.DataSource;
	[self.TextView setText:dataSource.String];
}

@end

