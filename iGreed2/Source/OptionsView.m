//
//  OptionsView.m
//  iGreed2
//
//  Created by phyrrus9 on 2/12/18.
//  Copyright © 2018 Ipseity. All rights reserved.
//

#import "OptionsView.h"

@interface OptionsView ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment_difficulty;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment_move1;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment_move2;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment_move3;
@property (weak, nonatomic) IBOutlet UISlider *slider_moves;
@property (weak, nonatomic) IBOutlet UILabel *label_moves;
@property (weak, nonatomic) IBOutlet UITextField *textField_levelSeed;
@property (weak, nonatomic) IBOutlet UIButton *button_save;

@end

@implementation OptionsView
struct preference prefs;
+ (struct preference)loadPrefs
{
	struct preference prefs;
	FILE *fp;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *prefsFile = [documentsDirectory stringByAppendingPathComponent:@"/prefs.bin"];
	prefs.moves = 1;
	prefs.difficulty = kDIF_NORM;
	prefs.move1 = kCOL_GRY;
	prefs.move2 = kCOL_BLU;
	prefs.move3 = kCOL_RED;
	prefs.seed = 0; // random
	if ((fp = fopen([prefsFile UTF8String], "rb")) != NULL)
	{ fread(&prefs, sizeof(struct preference), 1, fp); fclose(fp); }
	else printf("No options file, using defaults\n");
	return prefs;
}
- (IBAction)updateUI:(id)sender
{
	switch (prefs.difficulty)
	{
		case kDIF_EASY:
			[[self segment_difficulty] setSelectedSegmentIndex:0];
			break;
		case kDIF_NORM:
			[[self segment_difficulty] setSelectedSegmentIndex:1];
			break;
		case kDIF_HARD:
			[[self segment_difficulty] setSelectedSegmentIndex:2];
			break;
	}
	switch (prefs.move1)
	{
		case kCOL_GRY:
			[[self segment_move1] setSelectedSegmentIndex:0];
			break;
		case kCOL_RED:
			[[self segment_move1] setSelectedSegmentIndex:1];
			break;
		case kCOL_BLU:
			[[self segment_move1] setSelectedSegmentIndex:2];
			break;
	}
	switch (prefs.move2)
	{
		case kCOL_GRY:
			[[self segment_move2] setSelectedSegmentIndex:0];
			break;
		case kCOL_RED:
			[[self segment_move2] setSelectedSegmentIndex:1];
			break;
		case kCOL_BLU:
			[[self segment_move2] setSelectedSegmentIndex:2];
			break;
	}
	switch (prefs.move3)
	{
		case kCOL_GRY:
			[[self segment_move3] setSelectedSegmentIndex:0];
			break;
		case kCOL_RED:
			[[self segment_move3] setSelectedSegmentIndex:1];
			break;
		case kCOL_BLU:
			[[self segment_move3] setSelectedSegmentIndex:2];
			break;
	}
	if (prefs.seed == 0)
		[[self textField_levelSeed] setText:@""];
	else
		[[self textField_levelSeed] setText:[[NSString alloc] initWithFormat:@"%u", prefs.seed]];
	[[self button_save] setHidden:NO];
	[[self slider_moves] setValue:prefs.moves];
	[[self label_moves] setText:[[NSString alloc] initWithFormat:@"%u", prefs.moves]];
	[[self textField_levelSeed] resignFirstResponder];
}
- (void)viewDidLoad
{
	prefs = [OptionsView loadPrefs];
	[[self segment_move1] setEnabled:NO]; // broken
	[[self segment_move2] setEnabled:NO]; // broken
	[[self segment_move3] setEnabled:NO]; // broken
	[[self slider_moves ] setEnabled:NO]; // broken
	[self updateUI:nil];
	[[self button_save] setHidden:YES];
	[super viewDidLoad];
}
- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}
- (IBAction)segment_difficulty_change:(id)sender
{
	prefs.difficulty = [sender selectedSegmentIndex];
}
- (IBAction)segment_move1_change:(id)sender
{
	prefs.move1 = [sender selectedSegmentIndex];
}
- (IBAction)segment_move2_change:(id)sender
{
	prefs.move2 = [sender selectedSegmentIndex];
}
- (IBAction)segment_move3_change:(id)sender
{
	prefs.move3 = [sender selectedSegmentIndex];
}
- (IBAction)slider_moves_change:(id)sender
{
	prefs.moves = [(UISlider *)sender value];
}
- (IBAction)textField_levelSeed_edit:(id)sender
{
	if (!strcmp([[[self textField_levelSeed] text] UTF8String], "")) prefs.seed = 0;
	else prefs.seed = [[[self textField_levelSeed] text] intValue];
}

- (IBAction)button_save_upin:(id)sender
{
	FILE *fp;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *prefsFile = [documentsDirectory stringByAppendingPathComponent:@"/prefs.bin"];
	if (!strcmp([[[self textField_levelSeed] text] UTF8String], "")) prefs.seed = 0;
	else prefs.seed = [[[self textField_levelSeed] text] intValue];
	if ((fp = fopen([prefsFile UTF8String], "wb")) != NULL)
	{
		fwrite(&prefs, sizeof(struct preference), 1, fp);
		fclose(fp);
		[[self button_save] setHidden:YES];
	}
	else printf("ERROR, could not write preferences\n");
}
- (IBAction)button_return_upin:(id)sender
{
	[self performSegueWithIdentifier:@"backToEntry" sender:self];
}


@end
