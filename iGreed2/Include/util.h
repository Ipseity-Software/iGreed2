//
//  linked_list.h
//  iGreed2
//
//  Created by phyrrus9 on 2/9/18.
//  Copyright © 2018 Ipseity. All rights reserved.
//

#ifndef UTIL_H
#define UTIL_H

#import <UIKit/UIKit.h>
#include <stdint.h>

enum gl_device
{
	kDEV_SE,
	kDEV_X,
	kDEV_8P,
	kDEV_8
};

struct gameUI_item
{
	NSUInteger x, y; // top left corner x, y pixel val
	NSUInteger w, h; // width, height
};

struct gameUI_device
{
	struct gameUI_item
	map,
	restart,
	cheat,
	endgame,
	score,
	points,
	level,
	keypadBase;
};

struct clist_node
{
	uint64_t coord_x;
	uint64_t coord_y;
	struct clist_node *next;
};

void clist_insert(struct clist_node ** list, uint64_t coord_x, uint64_t coord_y);
void clist_free(struct clist_node *list);
struct gameUI_item gUIGetButton(uint32_t direction);

#endif /* UTIL_H */
