//
//  GameViewViewController.h
//  iGreed2
//
//  Created by phyrrus9 on 2/9/18.
//  Copyright © 2018 Ipseity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "util.h"

@interface GameView : UIViewController

@end
/*
 iPhone SE	(0	0)
 iPhone 8		(8	4)
 iPhone 8 Plus	(13	8)
 iPhone X		(8	14)
 */
#define BASE_XSIZE 40
#define BASE_YSIZE 26
#define WINPERCENT 25

enum direction
{
	kDIR_N = 0x1,
	kDIR_W = 0x2,
	kDIR_S = 0x4,
	kDIR_E = 0x8,
};

extern NSUInteger XSIZE;
extern NSUInteger YSIZE;
extern char **map;
extern NSUInteger player_x, player_y;
extern enum gl_device gUIDeviceType;
extern struct gameUI_device gUIDeviceDetails;
