//
//  ScoreDetailsView.m
//  iGreed2
//
//  Created by Ethan Laur on 2/17/18.
//  Copyright © 2018 Ipseity. All rights reserved.
//

#import "ScoreDetailsView.h"

@interface ScoreDetailsView ()
@property (weak, nonatomic) IBOutlet UILabel *l_name;
@property (weak, nonatomic) IBOutlet UILabel *l_date;
@property (weak, nonatomic) IBOutlet UILabel *l_level;
@property (weak, nonatomic) IBOutlet UILabel *l_percent;
@property (weak, nonatomic) IBOutlet UILabel *l_score;
@property (weak, nonatomic) IBOutlet UILabel *l_seed;
@property (weak, nonatomic) IBOutlet UILabel *l_difficulty;
@property (weak, nonatomic) IBOutlet UILabel *l_total_cleared;
@property (weak, nonatomic) IBOutlet UILabel *l_sq_cleared;
@property (weak, nonatomic) IBOutlet UILabel *l_avg_time;
@property (weak, nonatomic) IBOutlet UILabel *l_avg_percent;
@property (weak, nonatomic) IBOutlet UILabel *l_cheat;
@end

@implementation ScoreDetailsView

- (void)viewDidLoad
{
	struct tm lt;
	char dateString[32];
	static const char *format = "%b %d %Y";
	localtime_r(&_score.date, &lt);
	strftime(dateString, sizeof(dateString), format, &lt);
	[[self l_name] setText:[[NSString alloc] initWithUTF8String:(char *)[self score].name]];
	[[self l_date] setText:[[NSString alloc] initWithUTF8String:(char *)dateString]];
	[[self l_level] setText:[[NSString alloc] initWithFormat:@"%u", [self score].level]];
	[[self l_percent] setText:[[NSString alloc] initWithFormat:@"%u", [self score].percent]];
	[[self l_score] setText:[[NSString alloc] initWithFormat:@"%u", [self score].score]];
	[[self l_seed] setText:[[NSString alloc] initWithFormat:@"%u", [self score].seed]];
	[[self l_difficulty] setText:[[NSString alloc] initWithUTF8String:[self score].difficulty == 0 ? [self score].difficulty == 1 ? "Normal" : "Easy" : "Hard"]];
	[[self l_total_cleared] setText:[[NSString alloc] initWithFormat:@"%llu", [self score].squares_value]];
	[[self l_sq_cleared] setText:[[NSString alloc] initWithFormat:@"%u", [self score].squares_cleared]];
	[[self l_avg_time] setText:[[NSString alloc] initWithFormat:@"%.1lf %s", [self score].average_time/60.0, "min"]];
	[[self l_avg_percent] setText:[[NSString alloc] initWithFormat:@"%u%%", [self score].average_percent]];
	[[self l_cheat] setText:[[NSString alloc] initWithUTF8String:[self score].cheat_on ? "YES" : "no"]];
	[super viewDidLoad];
}
- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }
- (IBAction)button_return_upin:(id)sender { [self performSegueWithIdentifier:@"returnToScores" sender:self]; }

@end
