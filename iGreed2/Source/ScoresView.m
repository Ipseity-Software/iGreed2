//
//  Scores.m
//  iGreed2
//
//  Created by phyrrus9 on 2/10/18.
//  Copyright © 2018 Ipseity. All rights reserved.
//

#import "ScoresView.h"
#import "ScoreDetailsView.h"
#import "util.h"

@interface ScoresView ()
@property (weak, nonatomic) IBOutlet UITableView *table_scores;
@end

@implementation ScoresView
struct score_entry tableScores[25];
NSUInteger selectedScore, scoreCount;

void score_swap(struct score_entry *l, NSUInteger x, NSUInteger y)
{
	struct score_entry tmp;
	memcpy(&tmp, &l[x], sizeof(struct score_entry));
	memcpy(&l[x], &l[y], sizeof(struct score_entry));
	memcpy(&l[y], &tmp, sizeof(struct score_entry));
}
void score_sort(struct score_entry *l, NSUInteger size) { NSUInteger i, j; for (i = 0; i < size - 1 && size != 0; ++i) for (j = 0; j < size - i - 1; ++j) if (l[j].score < l[j + 1].score) score_swap(l, j, j + 1); /* simple bubble sort */ }
+ (const char *)scoreFile
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [[documentsDirectory stringByAppendingPathComponent:@"/scores.db"] UTF8String];
}
+ (void)writeScore:(struct score_entry *)score
{
	FILE *fp;
	NSUInteger version = 0;
	[ScoresView upgradeScoresFile]; // upgrade it so we don't wind up with corruption
	if (access([ScoresView scoreFile], F_OK) == -1) version = SCORE_VERSION;
	fp = fopen([ScoresView scoreFile], "a+b");
	if (version) fwrite(&version, sizeof(NSUInteger), 1, fp); // if this is the first score, write the version number first
	fwrite(score, sizeof(struct score_entry), 1, fp);
	fflush(fp);
	fclose(fp);
	printf("Score written\n");
}
+ (void)upgradeScoresFile
{
	FILE *fp;
	NSUInteger version;
	if ((fp = fopen([ScoresView scoreFile], "rb")) == NULL) return;
	fread(&version, sizeof(NSUInteger), 1, fp);
	// conversion would go here
}
+ (NSUInteger)highestScore
{
	NSUInteger highest;
	struct llist_node *list, *ptr;
	struct score_entry *scores;
	NSUInteger count, i;
	[ScoresView upgradeScoresFile]; // make sure it's up to date
	list = [ScoresView loadScores_v1]; // this needs to be updated when a new scorefile version is made
	count = llist_count(list);
	scores = malloc(sizeof(struct score_entry) * count);
	for (i = 0, ptr = list; i < count; ++i, ptr = ptr->next) memcpy(&scores[i], ptr->data, sizeof(struct score_entry)); // copy it into the structure
	score_sort(scores, count);
	highest = scores[0].score;
	free(scores);
	list = llist_free(list);
	return highest;
}
+ (struct llist_node *)loadScores_v1
{
	FILE *fp;
	struct llist_node *list;
	struct score_entry_v1 read, *write; // we use the v1 structure here directly
	NSUInteger version;
	list = NULL;
	if ((fp = fopen([ScoresView scoreFile], "rb")) != NULL)
	{
		fread(&version, sizeof(NSUInteger), 1, fp); // read out the version number. We don't need it though
		while (fread(&read, sizeof(struct score_entry_v1), 1, fp) != 0)
		{
			write = malloc(sizeof(struct score_entry_v1));
			memcpy(write, &read, sizeof(struct score_entry_v1)); // copy the data over
			llist_insert(&list, write); // add it to the list
		}
		fclose(fp);
	}
	return list;
}
- (void)loadScores
{
	struct llist_node *list, *ptr;
	struct score_entry *scores;
	NSUInteger count, i;
	[ScoresView upgradeScoresFile]; // make sure it's up to date
	list = [ScoresView loadScores_v1]; // this needs to be updated when a new scorefile version is made
	count = llist_count(list); scoreCount = (count > 25 ? 25 : count);
	scores = malloc(sizeof(struct score_entry) * count);
	for (i = 0, ptr = list; i < count; ++i, ptr = ptr->next) memcpy(&scores[i], ptr->data, sizeof(struct score_entry)); // copy it into the structure
	score_sort(scores, count);
	memset(tableScores, 0, sizeof(struct score_entry) * 25); // zero the whole structure
	for (i = 0; i < scoreCount; ++i) memcpy(&tableScores[i], &scores[i], sizeof(struct score_entry)); // copy it to the final structure
	free(scores);
	list = llist_free(list);
}
- (void)viewDidLoad
{
	[[self table_scores] setDataSource:self];
	[[self table_scores] setDelegate:self];
	[self loadScores];
	[super viewDidLoad];
}
- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return scoreCount; }
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	struct score_entry score = tableScores[[indexPath row]];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemId"];
	if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"itemId"];
	[cell setBackgroundColor:[indexPath row] % 2 ? [UIColor lightGrayColor] : [UIColor whiteColor]];
	[[cell textLabel] setText:[[NSString alloc] initWithUTF8String:(const char *)score.name]];
	[[cell detailTextLabel] setText:[[NSString alloc] initWithFormat:@"LVL %u | %u%% | %u PT", score.level, score.percent, score.score]];
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	selectedScore = [indexPath row];
	[self performSegueWithIdentifier:@"showScoreDetails" sender:self];
}
- (IBAction)button_GoBack_upin:(id)sender { [self performSegueWithIdentifier:@"returnToEntry" sender:self]; }
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	ScoreDetailsView *detailsView;
	if (!strcmp([[segue identifier] UTF8String], "showScoreDetails"))
	{
		detailsView = [segue destinationViewController];
		detailsView.score = tableScores[selectedScore];
	}
}
@end
