//
//  GameViewViewController.m
//  iGreed2
//
//  Created by phyrrus9 on 2/9/18.
//  Copyright © 2018 Ipseity. All rights reserved.
//

#import "../Include/GameView.h" // this might need to be changed
#include "../Include/coord_list.h"

NSUInteger XSIZE;
NSUInteger YSIZE;

@interface GameView ()
@property (weak, nonatomic) IBOutlet UITextView *textView_gameBoard;
@property (weak, nonatomic) IBOutlet UIButton *button_moveW;
@property (weak, nonatomic) IBOutlet UIButton *button_moveA;
@property (weak, nonatomic) IBOutlet UIButton *button_moveS;
@property (weak, nonatomic) IBOutlet UIButton *button_moveD;
@property (weak, nonatomic) IBOutlet UIButton *button_moveWA;
@property (weak, nonatomic) IBOutlet UIButton *button_moveWD;
@property (weak, nonatomic) IBOutlet UIButton *button_moveSA;
@property (weak, nonatomic) IBOutlet UIButton *button_moveSD;
@property (weak, nonatomic) IBOutlet UIButton *button_levelUp;
@property (weak, nonatomic) IBOutlet UIButton *button_restart;
@property (weak, nonatomic) IBOutlet UIButton *button_endGame;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment_possibleMoves;
@property (weak, nonatomic) IBOutlet UILabel *label_score;
@property (weak, nonatomic) IBOutlet UILabel *label_points;
@property (weak, nonatomic) IBOutlet UILabel *label_level;
@end

@implementation GameView

char **map;
NSUInteger player_x, player_y;
NSUInteger player_level, player_level_removed, player_level_cleared, player_points;
BOOL highlightPaths = NO;
BOOL gameOver = NO;
BOOL Level_Reset = YES; // this gets set to normal state during viewDidLoad->userRestart

- (void)viewDidLoad
{
	[super viewDidLoad];
	[[self textView_gameBoard] setBackgroundColor:[UIColor blackColor]];
	[self userRestart:nil];
	[self display];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}
- (void)display
{
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
	NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
	NSUInteger x, y;
	paragraphStyle.alignment = NSTextAlignmentCenter;
	for (y = 0; y < YSIZE; ++y)
	{
		for (x = 0; x < XSIZE; ++x)
		{
			if (x == player_x && y == player_y)
				[string appendAttributedString: [[NSAttributedString alloc] initWithString:@"#" attributes:@{NSParagraphStyleAttributeName:paragraphStyle}]];
			else if (map[x][y] != 0)
				[string appendAttributedString: [[NSAttributedString alloc] initWithString:[[NSString alloc] initWithFormat:@"%d", map[x][y]] attributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:[UIColor whiteColor]}]];
			else
				[string appendAttributedString: [[NSAttributedString alloc] initWithString:@"+" attributes:@{NSParagraphStyleAttributeName:paragraphStyle}]];
		}
		[string appendAttributedString: [[NSAttributedString alloc] initWithString:@"\n" attributes:@{NSParagraphStyleAttributeName:paragraphStyle}]];
	}
	string = [self highlightCharacter:string atX:player_x atY:player_y withColor:[UIColor blueColor]];
	string = [self highlightGridNumbers:string];
	if (highlightPaths) string = [self highlightPossibleMoves:string fromX:player_x fromY:player_y withColor:[UIColor grayColor]];
	[string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Courier" size:12.5] range:(NSRange){0, [string length]}];
	[[self label_score] setText:[[NSString alloc] initWithFormat:@"%.2f%%", [self score]]];
	[[self label_points] setText:[[NSString alloc] initWithFormat:@"%lu", (unsigned long)player_points]];
	[[self label_level] setText:[[NSString alloc] initWithFormat:@"lvl %lu", (unsigned long)player_level + 1]];
	if ([self score] > WINPERCENT) [[self button_levelUp] setHidden:NO]; // player can level up
	else if (gameOver) [self disableGame];
	[[self textView_gameBoard] setAttributedText:string];
}
- (NSMutableAttributedString *)highlightCharacter:(NSMutableAttributedString *)string atX:(NSUInteger)x atY:(NSUInteger)y withColor:(UIColor *)color
{
	NSUInteger offset = y * XSIZE + x + y;
	if (offset > [string length]) return string;
	NSRange range = [[string mutableString] rangeOfComposedCharacterSequenceAtIndex: offset];
	[string addAttribute:NSForegroundColorAttributeName value:color range:range];
	return string;
}
- (NSMutableAttributedString *)highlightBackground:(NSMutableAttributedString *)string atX:(NSUInteger)x atY:(NSUInteger)y withColor:(UIColor *)color
{
	NSUInteger offset = y * XSIZE + x + y;
	if (offset > [string length]) return string;
	NSRange range = [[string mutableString] rangeOfComposedCharacterSequenceAtIndex: offset];
	[string addAttribute:NSBackgroundColorAttributeName value:color range:range];
	return string;
}
- (NSMutableAttributedString *)highlightGridNumbers:(NSMutableAttributedString *)string
{
	NSUInteger x, y;
	UIColor *c1 = [[UIColor alloc] initWithRed:0.01 green:0.52 blue:0.09 alpha:1]; //038617	3	134	23
	UIColor *c2 = [[UIColor alloc] initWithRed:0.79 green:0.87 blue:0.26 alpha:1]; //cbf442	203	224	66
	UIColor *c3 = [[UIColor alloc] initWithRed:1.00 green:1.00 blue:0.00 alpha:1]; //ffff00	255	255	0
	UIColor *c4 = [[UIColor alloc] initWithRed:0.95 green:0.63 blue:0.00 alpha:1]; //f2a100	242	161	0
	UIColor *c5 = [[UIColor alloc] initWithRed:0.89 green:0.19 blue:0.15 alpha:1]; //e53027	229	48	39
	for (y = 0; y < YSIZE; y++)
	{
		for (x = 0; x < XSIZE; x++)
		{
				if (map[x][y] > 0 && map[x][y] <= 4)	[self highlightCharacter:string atX:x atY:y withColor:c1];
			else if (map[x][y] == 5 || map[x][y] == 6)	[self highlightCharacter:string atX:x atY:y withColor:c2];
			else if (map[x][y] == 7)					[self highlightCharacter:string atX:x atY:y withColor:c3];
			else if (map[x][y] == 8)					[self highlightCharacter:string atX:x atY:y withColor:c4];
			else if (map[x][y] == 9)					[self highlightCharacter:string atX:x atY:y withColor:c5];
		}
	}
	return string;
}
- (NSMutableAttributedString *)highlightPossibleMoves:(NSMutableAttributedString *)string fromX:(NSUInteger)x fromY:(NSUInteger)y withColor:(UIColor *)color
{
	struct clist_node *list = NULL;
	BOOL foundMove = NO;
	if ((list = [self trackMoveInDirection:kDIR_W fromX:x fromY:y]) != NULL) foundMove = YES;			// up
	string = [self highlightString:string withCoordinateList:list];
	clist_free(list);
	if ((list = [self trackMoveInDirection:kDIR_A fromX:x fromY:y]) != NULL) foundMove = YES;			// left
	string = [self highlightString:string withCoordinateList:list];
	clist_free(list);
	if ((list = [self trackMoveInDirection:kDIR_S fromX:x fromY:y]) != NULL) foundMove = YES;			// down
	string = [self highlightString:string withCoordinateList:list];
	clist_free(list);
	if ((list = [self trackMoveInDirection:kDIR_D fromX:x fromY:y]) != NULL) foundMove = YES;			// right
	string = [self highlightString:string withCoordinateList:list];
	clist_free(list);
	if ((list = [self trackMoveInDirection:kDIR_W | kDIR_A fromX:x fromY:y]) != NULL) foundMove = YES;	// up left
	string = [self highlightString:string withCoordinateList:list];
	clist_free(list);
	if ((list = [self trackMoveInDirection:kDIR_W | kDIR_D fromX:x fromY:y]) != NULL) foundMove = YES;	// up right
	string = [self highlightString:string withCoordinateList:list];
	clist_free(list);
	if ((list = [self trackMoveInDirection:kDIR_S | kDIR_A fromX:x fromY:y]) != NULL) foundMove = YES;	// down left
	string = [self highlightString:string withCoordinateList:list];
	clist_free(list);
	if ((list = [self trackMoveInDirection:kDIR_S | kDIR_D fromX:x fromY:y]) != NULL) foundMove = YES;	// down right
	string = [self highlightString:string withCoordinateList:list];
	clist_free(list);
	if (!foundMove && [self score] <= WINPERCENT) gameOver = YES; // no moves left (including a level up)
	return string;
}
- (NSMutableAttributedString *)highlightString:(NSMutableAttributedString *)string withCoordinateList:(struct clist_node *)list
{
	if (list != NULL)
	{
		string = [self highlightBackground:string atX:(NSUInteger)list->coord_x atY:(NSUInteger)list->coord_y withColor:[UIColor grayColor]];
		string = [self highlightCharacter:string atX:(NSUInteger)list->coord_x atY:(NSUInteger)list->coord_y withColor:[UIColor whiteColor]];
		string = [self highlightString:string withCoordinateList:list->next];
	}
	return string;
}
- (BOOL)canMoveInDirection:(NSUInteger)direction fromX:(NSUInteger)x fromY:(NSUInteger)y
{
	NSUInteger l_x = x, l_y = y, l_val, p_x = x, p_y = y, p_i;
	NSInteger slope_x, slope_y;
	if (direction & kDIR_W) --l_y; // up
	if (direction & kDIR_S) ++l_y; // down
	if (direction & kDIR_A) --l_x; // left
	if (direction & kDIR_D) ++l_x; // right
	if (l_x >= XSIZE || l_y >= YSIZE) return NO; // check for edge
	l_val = map[l_x][l_y];
	if (!l_val) return NO; // space immediately to left is empty
	slope_x = l_x - x; slope_y = l_y - y; // get move slope (to be added to p_*
	for (p_i = 0, p_x += slope_x, p_y += slope_y; p_i < l_val; ++p_i, p_x += slope_x, p_y += slope_y) // see if possible
		if (p_x >= XSIZE /* bounds check */ || p_y >= YSIZE /* bounds check */ || map[p_x][p_y] == 0 /* empty check */) return NO;
	return YES;
}
- (struct clist_node *)trackMoveInDirection:(NSUInteger)direction fromX:(NSUInteger)x fromY:(NSUInteger)y
{
	NSUInteger l_x = x, l_y = y, l_val, p_x = x, p_y = y, p_i;
	NSInteger slope_x, slope_y;
	struct clist_node *steps = NULL;
	if (direction & kDIR_W) --l_y; // up
	if (direction & kDIR_S) ++l_y; // down
	if (direction & kDIR_A) --l_x; // left
	if (direction & kDIR_D) ++l_x; // right
	if (l_x >= XSIZE || l_y >= YSIZE) return nil; // check for edge
	l_val = map[l_x][l_y];
	if (!l_val) return nil; // space immediately to left is empty
	slope_x = l_x - x; slope_y = l_y - y; // get move slope (to be added to p_*
	for (p_i = 0, p_x += slope_x, p_y += slope_y; p_i < l_val; ++p_i, p_x += slope_x, p_y += slope_y) // see if possible
	{
		if (p_x >= XSIZE /* bounds check */ || p_y >= YSIZE /* bounds check */ || map[p_x][p_y] == 0 /* empty space check */)
		{
			clist_free(steps);
			return nil;
		}
		clist_insert(&steps, p_x, p_y);
	}
	return steps;
}
- (void)moveInDirection:(NSUInteger)direction
{
	NSUInteger p_x = player_x, p_y = player_y, p_i, l_val, moves_made = 0;
	NSInteger slope_x = 0, slope_y = 0;
	if (direction & kDIR_W) --slope_y; // up
	if (direction & kDIR_S) ++slope_y; // down
	if (direction & kDIR_A) --slope_x; // left
	if (direction & kDIR_D) ++slope_x; // right
	l_val = map[player_x + slope_x][player_y + slope_y];
	for (p_i = 0, p_x += slope_x, p_y += slope_y; p_i < l_val; ++p_i, p_x += slope_x, p_y += slope_y) // move loop
	{
		map[p_x][p_y] = 0; // clear gridpoint
		player_x += slope_x; player_y += slope_y; // move player
		++player_level_cleared;
		++moves_made;
	}
	if (moves_made > 1)	player_points += moves_made;				 // standard points
	if (moves_made > 5)	player_points += [self score];	 		 // moderate bonus for 5,6,7
	if (moves_made > 7)	player_points += [self score] * player_level; // huge bonus for 8 & 9 items
}
- (void)levelUpMap
{
	NSUInteger i, rm_x, rm_y, removeItems = rand() % player_level * 2 + 1;
	for (i = 0; i < removeItems; ++i)
	{
		do { rm_x = rand() % XSIZE; rm_y = rand() % YSIZE; }
		while (rm_x == player_x && rm_y == player_y);
		map[rm_x][rm_y] = 0;
		++player_level_removed;
	}
}
- (void)generateMap
{
	NSUInteger x, y, i_level;
	srand((unsigned int)time(0));
	for (x = 0; x < XSIZE; ++x)
		for (y = 0; y < YSIZE; ++y)
			map[x][y] = rand() % 9 + 1;
	player_level_removed = 0;
	player_level_cleared = 0;
	player_x = rand() % XSIZE;
	player_y = rand() % YSIZE;
	map[player_x][player_y] = 0;
	for (i_level = 0; i_level < player_level; ++i_level) [self levelUpMap];
}
- (float)score { return ((float)player_level_cleared / (float)(XSIZE * YSIZE - player_level_removed)) * 100.0; }
- (void)disableGame
{
	[[self button_levelUp] setTitle:@"X" forState:UIControlStateNormal];
	[[self button_levelUp] setBackgroundColor:[UIColor redColor]];
	[[self button_moveA]   setEnabled:NO];
	[[self button_moveS]   setEnabled:NO];
	[[self button_moveD]   setEnabled:NO];
	[[self button_moveW]   setEnabled:NO];
	[[self button_moveWA]  setEnabled:NO];
	[[self button_moveWD]  setEnabled:NO];
	[[self button_moveSA]  setEnabled:NO];
	[[self button_moveSD]  setEnabled:NO];
	[[self button_levelUp] setHidden: NO];
	[[self button_levelUp] setEnabled:YES]; // use this button to add to high scores
}
- (void)enableGame
{
	[[self button_levelUp] setTitle:@"+" forState:UIControlStateNormal];
	[[self button_levelUp] setBackgroundColor:[UIColor greenColor]];
	[[self button_levelUp] setHidden: YES];
	[[self button_levelUp] setEnabled:YES];
	[[self button_moveA]   setEnabled:YES];
	[[self button_moveS]   setEnabled:YES];
	[[self button_moveD]   setEnabled:YES];
	[[self button_moveW]   setEnabled:YES];
	[[self button_moveWA]  setEnabled:YES];
	[[self button_moveWD]  setEnabled:YES];
	[[self button_moveSA]  setEnabled:YES];
	[[self button_moveSD]  setEnabled:YES];
}
- (IBAction)userMove:(id)sender
{
	[[self button_endGame] setBackgroundColor:[UIColor whiteColor]];
	if (Level_Reset)
	{
		Level_Reset = NO;
		[[self button_levelUp] setBackgroundColor:[UIColor greenColor]];
		[[self button_restart] setBackgroundColor:[UIColor whiteColor]];
		[[self button_endGame] setBackgroundColor:[UIColor whiteColor]];
	}
	if ([self canMoveInDirection:[sender tag] fromX:player_x fromY:player_y])
		[self moveInDirection:[sender tag]];
	[self display];
}
- (IBAction)userRestart:(id)sender
{
	if (!Level_Reset) [[self button_restart] setBackgroundColor:[UIColor redColor]];
	if (Level_Reset)
	{
		gameOver = NO;
		Level_Reset = NO;
		highlightPaths = NO;
		player_level = 0;
		player_points = 0;
		[[self segment_possibleMoves] setSelectedSegmentIndex:0];
		[[self button_restart] setBackgroundColor:[UIColor whiteColor]];
		[self enableGame];
		[self generateMap];
		[self display];
	}
	else Level_Reset = YES;
}
- (IBAction)userEndGame:(id)sender
{
	[[self button_endGame] setBackgroundColor:[UIColor redColor]];
	if (Level_Reset) [self performSegueWithIdentifier:@"endGame" sender:self];
	else Level_Reset = YES;
}
- (IBAction)userCheat:(id)sender
{
	if ([sender selectedSegmentIndex] == 0) highlightPaths = NO;
	else								highlightPaths = YES;
	[self display];
}
- (IBAction)userLevelUp:(id)sender
{
	if (!gameOver) // next level
	{
		[[self button_levelUp] setBackgroundColor:[UIColor blueColor]];
		if (Level_Reset)
		{
			++player_level;
			[self generateMap];
			[self enableGame];
			[self display];
			Level_Reset = NO;
		}
		else Level_Reset = YES;
	}
	else [self enterScore]; // high scores
}
- (void)enterScore
{
	FILE *fp __block;
	NSString *score = [[NSString alloc] initWithFormat:@"LVL %lu/%.2f%%/%lupt", (unsigned long)player_level + 1, [self score], (unsigned long)player_points];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *scoresFile = [documentsDirectory stringByAppendingPathComponent:@"/scores.txt"];
	UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Game Over!"
									message: score preferredStyle:UIAlertControllerStyleAlert];
	[alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
	{
		textField.placeholder = @"name";
		textField.textColor = [UIColor blueColor];
		textField.clearButtonMode = UITextFieldViewModeWhileEditing;
		textField.borderStyle = UITextBorderStyleRoundedRect;
	}];
	[alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
	{
		NSArray * textfields = alertController.textFields;
		UITextField * namefield = textfields[0];
		if (!([[namefield text] length] < 1 || [[namefield text] length] > 15))
		{
			if ((fp = fopen([scoresFile UTF8String], "a")) != NULL)
			{
				fprintf(fp, "%s\n%lu/%.2f/%lu\n", [[namefield text] UTF8String],
					   (unsigned long)player_level + 1, [self score], (unsigned long)player_points);
				fflush(fp);
				fclose(fp);
				[self userRestart:nil];
				[self performSegueWithIdentifier:@"showScores" sender:self]; // show scores screen
				return;
			}
		}
		printf("ERROR!\n");
	}]];
	[self presentViewController:alertController animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
