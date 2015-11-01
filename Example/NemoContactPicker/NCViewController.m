//
//  NCViewController.m
//  NemoContactPicker
//
//  Created by Peyman on 11/01/2015.
//  Copyright (c) 2015 Peyman. All rights reserved.
//

#import "NCViewController.h"
#import <NemoContactPicker/NemoContactPicker.h>

@interface NCViewController ()

@end

@implementation NCViewController

- (void)viewDidLoad
{
	
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)onOpenModal:(UIButton *)sender {
	
	NemoContactPicker* picker = [[NemoContactPicker alloc] initWithStyle:UITableViewStylePlain];
	[self presentViewController:picker animated:YES completion:nil];
	
}
@end
