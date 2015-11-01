//
//  ButtonCell.m
//  Pods
//
//  Created by peyman abdi on 11/1/15.
//
//

#import "ButtonCell.h"

@implementation ButtonCellData
-(instancetype) initWithTitle:(NSString *)title withSelector:(SEL)callback onObject:(id)object {
	self = [super initWithIdentifier:@"ButtonCell" nSelector:callback onObject:object];
	if (self) {
		self.Title = title;
	}
	return self;
}
@end

@implementation ButtonCell

- (void)awakeFromNib {
}

-(void) setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

- (IBAction)onButtonTouchUpInside:(UIButton *)sender {
	[self PerformCallbackObjectSelector];
}

-(void) UpdateTableCellFromDataSource {
	ButtonCellData* dataSource = (ButtonCellData*)self.DataSource;
	[self.Button setTitle:dataSource.Title forState:UIControlStateNormal];
	[self.Button setTitle:dataSource.Title forState:UIControlStateDisabled];
	[self.Button setTitle:dataSource.Title forState:UIControlStateSelected];
	[self.Button setTitle:dataSource.Title forState:UIControlStateHighlighted];
}

@end
