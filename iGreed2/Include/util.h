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
	kDEV_8,
	kDEV_7P = kDEV_8P,
	kDEV_7 = kDEV_8,
	kDEV_6S = kDEV_8,
	kDEV_6SP = kDEV_8P,
	kDEV_6P = kDEV_8P,
	kDEV_6 = kDEV_8
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

struct llist_node
{
	void *data;
	struct llist_node *next;
};

void clist_insert(struct clist_node ** list, uint64_t coord_x, uint64_t coord_y);
struct clist_node *clist_get(struct clist_node *list, NSUInteger position);
struct clist_node *clist_free(struct clist_node *list);
NSUInteger clist_count(struct clist_node *list);
void llist_insert(struct llist_node **list, void *data);
struct llist_node *llist_free(struct llist_node *list);
NSUInteger llist_count(struct llist_node *list);
struct gameUI_item gUIGetButton(uint32_t direction);

#endif /* UTIL_H */
