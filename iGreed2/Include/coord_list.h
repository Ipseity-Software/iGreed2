//
//  linked_list.h
//  iGreed2
//
//  Created by phyrrus9 on 2/9/18.
//  Copyright © 2018 Ipseity. All rights reserved.
//

#ifndef linked_list_h
#define linked_list_h

#include <stdint.h>

struct clist_node
{
	uint64_t coord_x;
	uint64_t coord_y;
	struct clist_node *next;
};

void clist_insert(struct clist_node ** list, uint64_t coord_x, uint64_t coord_y);
void clist_free(struct clist_node *list);

#endif /* linked_list_h */
