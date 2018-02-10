//
//  main.m
//  iGreed2
//
//  Created by phyrrus9 on 2/9/18.
//  Copyright © 2018 Ipseity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

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
		//printSaveFile();
		//destroySaveFile();
		return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
	}
}
