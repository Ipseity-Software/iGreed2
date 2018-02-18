//
//  Scores.h
//  iGreed2
//
//  Created by phyrrus9 on 2/10/18.
//  Copyright © 2018 Ipseity. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCORE_VERSION 1

struct score_entry_v1
{
	uint8_t	name[16];				// name of player
	time_t	date;				// UNIX timestamp of score
	uint8_t	level			: 7;	// level that game ended on
	uint8_t	percent			: 7;	// percentage cleared upon game ending
	uint16_t	score;				// player's score upon game ending
	uint16_t	seed;				// level seed used (either manual or random)
	uint8_t	difficulty		: 2;	// player's selected difficulty (see OptionsView.h)
	uint64_t	squares_value;			// total of values of all squares removed from board
	uint32_t	squares_cleared;		// total number of squares removed from board
	time_t	average_time;			// average time spent on each level
	uint8_t	average_percent	: 7;	// average percentage of all levels played
	uint8_t	cheat_on			: 1;	// did the player turn the cheat switch on during play
};

#define score_entry score_entry_v1

@interface ScoresView : UIViewController <UITableViewDelegate, UITableViewDataSource>
+ (const char *)scoreFile;
+ (void)writeScore:(struct score_entry *)score;
+ (NSUInteger)highestScore;
@end
