//
//  linked_list.m
//  iGreed2
//
//  Created by phyrrus9 on 2/9/18.
//  Copyright © 2018 Ipseity. All rights reserved.
//

#include <stdlib.h>
#import "GameView.h" // for direction enum
#import "util.h"

enum gl_device gUIDeviceType; // set in main.m, used to set up game view

struct gameUI_device gUIDevice_SE =
{	/*x		y		width	height 	// item	*/
	{ 0,		20,		320,		357 },	// map
	{ 16,	407,		50,		30 },	// restart
	{ 3,		460,		76,		29 },	// cheat
	{ 6,		508, 	71,		30 },	// endgame
	{ 244,	412,		68,		21 },	// score
	{ 244,	463,		68,		21 },	// points
	{ 244,	513,		68,		21 },	// level
	{ 85,	398,		50,		50}		// keypadBase
};

struct gameUI_device gUIDevice_X =
{	/*x		y		width	height 	// item	*/
	{ 0,		33,		375,		440 },	// map
	{ 16,	481,		50,		30  },	// restart
	{ 149,	483,		76,		29  },	// cheat
	{ 288,	480, 	71,		30  },	// endgame
	{ 7,		757,		68,		21  },	// score
	{ 289,	757,		68,		21  },	// points
	{ 153,	757,		68,		21  },	// level
	{ 91,	541,		64,		64  }	// keypadBase
};

struct gameUI_device gUIDevice_EightPlus =
{	/*x		y		width	height 	// item	*/
	{ 0,		20,		414,		393 },	// map
	{ 20,	429,		50,		30  },	// restart
	{ 169,	430,		76,		29  },	// cheat
	{ 325,	429, 	71,		30  },	// endgame
	{ 11,	695,		68,		21  },	// score
	{ 173,	695,		68,		21  },	// points
	{ 326,	695,		68,		21  },	// level
	{ 105,	477,		68,		68 }		// keypadBase
};

struct gameUI_device gUIDevice_Eight =
{	/*x		y		width	height 	// item	*/
	{ 0,		20,		375,		374 },	// map
	{ 16,	403,		50,		30  },	// restart
	{ 149,	404,		76,		29  },	// cheat
	{ 288,	402, 	71,		30  },	// endgame
	{ 7,		635,		68,		21  },	// score
	{ 291,	634,		68,		21  },	// points
	{ 153,	635,		68,		21  },	// level
	{ 91,	447,		60,		60  }	// keypadBase 67
};

void clist_insert(struct clist_node ** list, uint64_t coord_x, uint64_t coord_y)
{
	struct clist_node *node;
	struct clist_node *position;
	node = malloc(sizeof(struct clist_node));
	node->coord_x = coord_x;
	node->coord_y = coord_y;
	node->next = NULL;
	if (*list == NULL) // empty list
		*list = node;
	else
	{
		for (position = *list; position->next != NULL; position = position->next);
		position->next = node;
	}
}
struct clist_node *clist_get(struct clist_node *list, NSUInteger position)
{
	struct clist_node *ptr;
	NSUInteger i;
	for (i = 0, ptr = list; ptr != NULL && i != position; ++i, ptr = ptr->next);
	return ptr;
}
NSUInteger clist_count(struct clist_node *list)
{
	struct clist_node *ptr;
	NSUInteger i;
	for (i = 0, ptr = list; ptr != NULL; ++i, ptr = ptr->next);
	return i;
}
struct clist_node *clist_free(struct clist_node *list)
{
	if (list == NULL) return NULL;
	list->next = clist_free(list->next);
	free(list);
	return NULL;
}
struct gameUI_item gUIGetButton(uint32_t direction)
{
	struct gameUI_item ret;
	struct gameUI_item base;
	switch (gUIDeviceType)
	{
		case kDEV_X:	base = gUIDevice_X.keypadBase;		break;
		case kDEV_8P:	base = gUIDevice_EightPlus.keypadBase;	break;
		case kDEV_8:	base = gUIDevice_Eight.keypadBase;		break;
		case kDEV_SE:	base = gUIDevice_SE.keypadBase;		break;
	}
	ret = base;
	if (direction == 0)						{ ret.y += (base.h * 1); ret.x += (base.w * 1); } //+  1 down, 1 over
	else if (direction == kDIR_N)				{ ret.y += (base.h * 0); ret.x += (base.w * 1);} //N  0 down, 0 over
	else if (direction == kDIR_S)				{ ret.y += (base.h * 2); ret.x += (base.w * 1);} //S  2 down, 1 over
	else if (direction == kDIR_E)				{ ret.y += (base.h * 1); ret.x += (base.w * 2);} //E  1 down, 2 over
	else if (direction == kDIR_W)				{ ret.y += (base.h * 1); ret.x += (base.w * 0);} //W  1 down, 0 over
	else if (direction == (kDIR_N | kDIR_W))	{ ret.y += (base.h * 0); ret.x += (base.w * 0);} //NW 0 down, 0 over
	else if (direction == (kDIR_N | kDIR_E))	{ ret.y += (base.h * 0); ret.x += (base.w * 2);} //NE 0 down, 2 over
	else if (direction == (kDIR_S | kDIR_W))	{ ret.y += (base.h * 2); ret.x += (base.w * 0);} //SW 2 down, 0 over
	else if (direction == (kDIR_S | kDIR_E))	{ ret.y += (base.h * 2); ret.x += (base.w * 2);} //SE 2 down, 2 over
	return ret;
}
