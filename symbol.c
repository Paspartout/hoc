#include "hoc.h"
#include "y.tab.h"

static Symbol *symlist = 0; /* symbol table: linked list */

char *emalloc();

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


}

