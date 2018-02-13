//
//  Scores.m
//  iGreed2
//
//  Created by phyrrus9 on 2/10/18.
//  Copyright © 2018 Ipseity. All rights reserved.
//

#import "ScoresView.h"

struct load_entry
{
	char		 name[16];
	NSUInteger level,
			 score;
	float	 percent;
};

@interface ScoresView ()
@property (weak, nonatomic) IBOutlet UITableView *table_scores;
@end

@implementation ScoresView
NSArray *tableNames;
NSArray *tableData;

void load_swap(struct load_entry **l, NSUInteger x, NSUInteger y)
{
	struct load_entry *tmp = l[x];
	l[x] = l[y];
	l[y] = tmp;
}
void load_sort(struct load_entry **l, NSUInteger size)
{ NSUInteger i, j;
  for (i = 0; i < size - 1; ++i) for (j = 0; j < size - i - 1; ++j) if (l[j]->score < l[j + 1]->score) load_swap(l, j, j + 1); /* simple bubble sort */ }
+ (NSUInteger)highestScore
{
	FILE *fp;
	struct load_entry fentry;
	struct load_entry **list_fentry;
	NSUInteger load_count = 0, load_i, highest = 0;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *scoresFile = [documentsDirectory stringByAppendingPathComponent:@"/scores.txt"];
	if ((fp = fopen([scoresFile UTF8String], "r")) == NULL) // failed to open file
	{ printf("File not exist\n"); return 0; }
	// read over the file to determine data entries
	while (fscanf(fp, "%[^\n]\n", fentry.name) != EOF)
	{ fscanf(fp, "%lu/%f/%lu\n", &fentry.level, &fentry.percent, &fentry.score); ++load_count; }
	fseek(fp, 0L, SEEK_SET);
	// read the file twice, this time store the data
	list_fentry = malloc(sizeof(struct load_entry *) * load_count);
	for (load_i = 0; load_i < load_count; ++load_i)
	{
		list_fentry[load_i] = malloc(sizeof(struct load_entry));
		fscanf(fp, "%[^\n]\n", list_fentry[load_i]->name);
		fscanf(fp, "%lu/%f/%lu\n", &list_fentry[load_i]->level, &list_fentry[load_i]->percent, &list_fentry[load_i]->score);
	}
	fclose(fp);
	// done reading it, now time to sort and set up the arrays
	load_sort(list_fentry, load_count);
	if (load_count > 0) highest = list_fentry[0]->score;
	// clean up
	for (load_i = 0; load_i < load_count; ++load_i) free(list_fentry[load_i]);
	free(list_fentry);
	return highest;
}
- (void)viewDidLoad
{
	FILE *fp;
	struct load_entry fentry;
	struct load_entry **list_fentry;
	NSUInteger load_count = 0, load_i;
	NSMutableArray *load_name = [[NSMutableArray alloc] init];
	NSMutableArray *load_data = [[NSMutableArray alloc] init];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *scoresFile = [documentsDirectory stringByAppendingPathComponent:@"/scores.txt"];
	[[self table_scores] setDelegate: self];
	[[self table_scores] setDataSource: self];
	if ((fp = fopen([scoresFile UTF8String], "r")) == NULL) // failed to open file
	{ printf("File not exist\n"); return; }
	// read over the file to determine data entries
	while (fscanf(fp, "%[^\n]\n", fentry.name) != EOF)
	{ fscanf(fp, "%lu/%f/%lu\n", &fentry.level, &fentry.percent, &fentry.score); ++load_count; }
	fseek(fp, 0L, SEEK_SET);
	// read the file twice, this time store the data
	list_fentry = malloc(sizeof(struct load_entry *) * load_count);
	for (load_i = 0; load_i < load_count; ++load_i)
	{
		list_fentry[load_i] = malloc(sizeof(struct load_entry));
		fscanf(fp, "%[^\n]\n", list_fentry[load_i]->name);
		fscanf(fp, "%lu/%f/%lu\n", &list_fentry[load_i]->level, &list_fentry[load_i]->percent, &list_fentry[load_i]->score);
	}
	fclose(fp);
	// done reading it, now time to sort and set up the arrays
	load_sort(list_fentry, load_count);
	for (load_i = 0; load_i < (load_count > 25 ? 25 : load_count); ++load_i)
	{
		[load_name addObject:[[NSString alloc] initWithUTF8String:list_fentry[load_i]->name]];
		[load_data addObject:[[NSString alloc] initWithFormat:@"LVL %lu | %.0f%% | %lu PT", list_fentry[load_i]->level, round(list_fentry[load_i]->percent), list_fentry[load_i]->score]];
	}
	tableNames = load_name; tableData = load_data; // set the tables
	// clean up
	for (load_i = 0; load_i < load_count; ++load_i) free(list_fentry[load_i]);
	free(list_fentry);
	[super viewDidLoad];
}
- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return [tableData count]; }
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemId"];
	if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"itemId"];
	cell.textLabel.text = [tableNames objectAtIndex:indexPath.row];
	cell.detailTextLabel.text = [tableData objectAtIndex:indexPath.row];
	return cell;
}
- (IBAction)button_GoBack_upin:(id)sender { [self performSegueWithIdentifier:@"returnToEntry" sender:self]; }
@end
