#include "hoc.h"
#include "y.tab.h"

#include <stdlib.h>

static Symbol *symlist = 0; /* symbol table: linked list */

char *emalloc(unsigned n);

Symbol *
lookup(char *s)
{
	Symbol *sp;

	for (sp = symlist; sp != (Symbol *) 0; sp = sp->next)
		if (strcmp(sp->name, s) == 0)
			return sp;

	return 0; /* 0 => not found */
}

Symbol *
install(char *s, int t, double d)
{
	Symbol *sp;
	sp = (Symbol *) emalloc(sizeof(Symbol));
	sp->name = emalloc(strlen(s) + 1);
	strcpy(sp->name, s);

	sp->type = t;
	sp->u.val = d;
	sp->next = symlist; /* put at front of list */
	symlist = sp;
	return sp;
}

char *
emalloc(size_t n)
{
	char *p;

	p = malloc(n);
	if (p == NULL)
		execerror("out of memory", (char *) NULL);

	return p;
}

