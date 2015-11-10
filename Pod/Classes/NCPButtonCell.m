//
//  ButtonCell.m
//  Pods
//
//  Created by peyman abdi on 11/1/15.
//
//

#import "NCPButtonCell.h"

@implementation NCPButtonCellData
-(instancetype) initWithTitle:(NSString *)title withSelector:(SEL)callback onObject:(id)object {
	self = [super initWithIdentifier:@"NCPButtonCell" nSelector:callback onObject:object];
	if (self) {
		self.Title = title;
	}
	return self;
}
@end

@implementation NCPButtonCell

- (void)awakeFromNib {
}

-(void) setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

- (IBAction)onButtonTouchUpInside:(UIButton *)sender {
	[self PerformCallbackObjectSelector];
}

-(void) UpdateTableCellFromDataSource {
	NCPButtonCellData* dataSource = (NCPButtonCellData*)self.DataSource;
	[self.Button setTitle:dataSource.Title forState:UIControlStateNormal];
	[self.Button setTitle:dataSource.Title forState:UIControlStateDisabled];
	[self.Button setTitle:dataSource.Title forState:UIControlStateSelected];
	[self.Button setTitle:dataSource.Title forState:UIControlStateHighlighted];
}

@end
