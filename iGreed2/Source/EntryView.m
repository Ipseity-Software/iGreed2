//
//  ViewController.m
//  iGreed2
//
//  Created by phyrrus9 on 2/9/18.
//  Copyright © 2018 Ipseity. All rights reserved.
//

#import "EntryView.h"

@interface EntryView ()

@end

@implementation EntryView

- (void)viewDidLoad
{
	[super viewDidLoad];
}


- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (IBAction)button_StartGame_upin:(id)sender
{
	[self performSegueWithIdentifier:@"startGame" sender:self];
}
- (IBAction)button_HighScores_upin:(id)sender
{
	[self performSegueWithIdentifier:@"showScores" sender:self];
}
- (IBAction)button_Options_upin:(id)sender
{
	[self performSegueWithIdentifier:@"showOptions" sender:self];
}

@end
