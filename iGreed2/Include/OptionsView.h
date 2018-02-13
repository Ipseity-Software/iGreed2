//
//  OptionsView.h
//  iGreed2
//
//  Created by phyrrus9 on 2/12/18.
//  Copyright © 2018 Ipseity. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <stdint.h>

@interface OptionsView : UIViewController
+ (struct preference)loadPrefs;
@end

enum difficulty
{
	kDIF_EASY = 0x0,
	kDIF_NORM = 0x1,
	kDIF_HARD = 0x2
};
enum uxcolor
{
	kCOL_GRY = 0x0,
	kCOL_RED = 0x1,
	kCOL_BLU = 0x2
};
struct preference
{
	uint8_t difficulty	: 2;
	uint8_t move1		: 2;
	uint8_t move2		: 2;
	uint8_t move3		: 2;
	uint8_t moves;
	uint16_t seed;
};
