//
//  linked_list.c
//  iGreed2
//
//  Created by phyrrus9 on 2/9/18.
//  Copyright © 2018 Ipseity. All rights reserved.
//

#include <stdlib.h>
#include "coord_list.h"

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
void clist_free(struct clist_node *list)
{
	if (list == NULL) return;
	if (list->next != NULL)
		clist_free(list->next);
	list->next = NULL;
	free(list);
}
