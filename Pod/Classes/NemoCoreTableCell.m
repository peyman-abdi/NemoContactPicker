//
//  NemoCoreTableCell.m
//  Pods
//
//  Created by peyman abdi on 11/1/15.
//
//

#import "NemoCoreTableCell.h"

@implementation NemoCoreTableCellData
-(instancetype) initWithIdentifier:(NSString *)identifier nSelector:(SEL)callback onObject:(id)object {
	self = [super init];
	if (self) {
		self.CallbackMethod = callback;
		self.CallbackObject = object;
		self.CellHeight = -1;
		self.CellIdentifier = identifier;
	}
	return self;
}
@end

@implementation NemoCoreTableCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

-(void) UpdateTableCellFromDataSource {}
-(void) SetDataSource:(NemoCoreTableCellData *)dataSource {
	self.DataSource = dataSource;
	self.DataSource.SourceCell = self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
-(void) PerformCallbackObjectSelector {
	if (self.DataSource.CallbackObject != nil &&
		[self.DataSource.CallbackObject respondsToSelector:self.DataSource.CallbackMethod]) {
		[self.DataSource.CallbackObject performSelector:self.DataSource.CallbackMethod withObject:self];
	}
}
#pragma clang diagnostic pop

@end
