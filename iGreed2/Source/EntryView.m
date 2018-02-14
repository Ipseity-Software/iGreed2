//
//  ViewController.m
//  iGreed2
//
//  Created by phyrrus9 on 2/9/18.
//  Copyright © 2018 Ipseity. All rights reserved.
//

#import "EntryView.h"
#import "util.h"

@interface EntryView ()
@property (strong, nonatomic) IBOutlet UIView *view_self;

@end

@implementation EntryView
UIColor *bgcolor;
extern enum gl_device gUIDeviceType;

- (void)viewDidLoad
{
	bgcolor = [[UIColor alloc] initWithRed:0.384 green:0.298 blue:1.000 alpha:1.000]; // #624CFF
	[[self view_self] setBackgroundColor:bgcolor]; // iPhone X fix
	[super viewDidLoad];
}
- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }
- (IBAction)button_StartGame_upin:(id)sender
{
	if (gUIDeviceType == kDEV_X) [[self view_self] setBackgroundColor:[UIColor whiteColor]]; // iPhone X fix
	[self performSegueWithIdentifier:@"startGame" sender:self];
}
- (IBAction)button_HighScores_upin:(id)sender
{
	if (gUIDeviceType == kDEV_X) [[self view_self] setBackgroundColor:[UIColor whiteColor]]; // iPhone X fix
	[self performSegueWithIdentifier:@"showScores" sender:self];
}
- (IBAction)button_Options_upin:(id)sender
{
	[self performSegueWithIdentifier:@"showOptions" sender:self];
}

@end
