//
//  main.m
//  iGreed2
//
//  Created by phyrrus9 on 2/9/18.
//  Copyright © 2018 Ipseity. All rights reserved.
//

#import <sys/utsname.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "GameView.h"

const char* deviceName()
{
	struct utsname systemInfo;
	uname(&systemInfo);
	return [[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding] UTF8String];
}

extern NSUInteger XSIZE;
extern NSUInteger YSIZE;
extern struct gameUI_device gUIDevice_X;
extern struct gameUI_device gUIDevice_EightPlus;
extern struct gameUI_device gUIDevice_Eight;
extern struct gameUI_device gUIDevice_SE;
void setSizes()
{
	unsigned i;
	const char *Id = deviceName();
	XSIZE = BASE_XSIZE;
	YSIZE = BASE_YSIZE;
	
	if (!strcmp(Id, "iPhone8,4") || !strcmp(Id, "iPhone10,4")) //SE
	{ gUIDeviceType = kDEV_SE; XSIZE += 0; YSIZE += 1; }
	if (!strcmp(Id, "iPhone10,1") || !strcmp(Id, "iPhone10,4") || //8
	    (!strcmp(Id, "iPhone7,2") /* 6 */ || !strcmp(Id, "iPhone8,1") /* 6P */) ||
	    (!strcmp(Id, "iPhone9,1") || !strcmp(Id, "iPhone9,3"))) // 7
	{ gUIDeviceType = kDEV_8;  XSIZE += 8; YSIZE += 2; }
	if ((!strcmp(Id, "iPhone10,2") || !strcmp(Id, "iPhone10,5")) || //8 Plus
	    (!strcmp(Id, "iPhone7,1") /* 6P */ || !strcmp(Id, "iPhone8,2") /* 6SP */) ||
	    (!strcmp(Id, "iPhone9,2") || !strcmp(Id, "iPhone9,4"))) // 7 Plus
	{ gUIDeviceType = kDEV_8P; XSIZE += 13; YSIZE += 4; }
	if (!strcmp(Id, "iPhone10,3") || !strcmp(Id, "iPhone10,6")) //X
	{ gUIDeviceType = kDEV_X;  XSIZE += 8; YSIZE += 14; }
	map = malloc(sizeof(char *) * XSIZE);
	for (i = 0; i < XSIZE; i++)
		map[i] = malloc(sizeof(char) * YSIZE);
	switch (gUIDeviceType)
	{
		case kDEV_X:	gUIDeviceDetails = gUIDevice_X;		break;
		case kDEV_8P:	gUIDeviceDetails = gUIDevice_EightPlus;	break;
		case kDEV_8:	gUIDeviceDetails = gUIDevice_Eight;	break;
		case kDEV_SE:	gUIDeviceDetails = gUIDevice_SE;		break;
	}
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
		setSizes();
		//printSaveFile();
		//destroySaveFile();
		return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
	}
}
