//
//  main.m
//  iGreed2
//
//  Created by phyrrus9 on 2/9/18.
//  Copyright © 2018 Ipseity. All rights reserved.
//

#import <sys/utsname.h>
#import <UIKit/UIKit.h>
#import "../Include/AppDelegate.h" // this might need to be changed
#import "../Include/GameView.h" // this might need to be changed

const char* deviceName()
{
	struct utsname systemInfo;
	uname(&systemInfo);
	return [[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding] UTF8String];
}

extern NSUInteger XSIZE;
extern NSUInteger YSIZE;
void setMapSize()
{
	unsigned i;
	const char *Id = deviceName();
	XSIZE = BASE_XSIZE;
	YSIZE = BASE_YSIZE;
	if (!strcmp(Id, "iPhone8,4") || !strcmp(Id, "iPhone10,4")) //SE
	{ XSIZE += 0; YSIZE += 1; }
	if (!strcmp(Id, "iPhone10,1") || !strcmp(Id, "iPhone10,4")) //8
	{ XSIZE += 8; YSIZE += 4; }
	if (!strcmp(Id, "iPhone10,2") || !strcmp(Id, "iPhone10,5")) //8 Plus
	{ XSIZE += 13; YSIZE += 8; }
	if (!strcmp(Id, "iPhone10,3") || !strcmp(Id, "iPhone10,6")) //X
	{ XSIZE += 8; YSIZE += 14; }
	map = malloc(sizeof(char *) * XSIZE);
	for (i = 0; i < XSIZE; i++)
		map[i] = malloc(sizeof(char) * YSIZE);
}

const char *getScoreFilePath()
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *scoresFile = [documentsDirectory stringByAppendingPathComponent:@"/scores.txt"];
	return [scoresFile UTF8String];
}
void printScoreFile()
{
	FILE *fp;
	char c;
	if ((fp = fopen(getScoreFilePath(), "r")) != NULL)
	{
		printf("Save file is at %s\n", getScoreFilePath());
		while (fscanf(fp, "%c", &c) > 0)
			printf("%c", c);
		printf("<EOF>\n");
		fclose(fp);
	}
	else
		printf("No save file\n");
}
void destroyScoreFile() { unlink(getScoreFilePath()); }

int main(int argc, char * * argv)
{
	@autoreleasepool
	{
		setMapSize();
		//printSaveFile();
		//destroySaveFile();
		return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
	}
}
