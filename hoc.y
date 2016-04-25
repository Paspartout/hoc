%{
#include "hoc.h"
extern double Pow();
%}
%union {
	double val;	/* actual value */
	Symbol *sym;	/* symbol table pointer */
}

%token	<val>	NUMBER
%token	<sym>	VAR BLTIN UNDEF
%token		EXTERM
%type	<val>	expr asgn

%right	'='
%left	'%'
%left	'+' '-'
%left	'*' '/'
%left	UNARYMINUS
%right	'^'
%%
list:
	| list EXTERM
	| list asgn EXTERM
	| list expr EXTERM	{ printf("\t%.8g\n", $2); }
	| list error EXTERM	{ yyerrok; }
	;
asgn:	  VAR '=' expr { $$ = $1->u.val=$3; $1->type = VAR; }
	;
expr:	  NUMBER
	| VAR		{ if ($1->type == UNDEF) 
				execerror("undefined variable", $1->name);
				$$ = $1.val; }
	| asgn
	| BLTIN '(' expr ')' { $$ = (*($1->u.ptr))($3); }
	| expr '+' expr	{ $$ = $1 + $3; }
	| expr '-' expr	{ $$ = $1 - $3; }
	| expr '*' expr	{ $$ = $1 * $3; }
	| expr '^' expr	{ $$ = pow($1, $3); }
	| expr '/' expr	{ 
		if ($3 == 0.0)
			execerror("division by zero", "");		
		$$ = $1 / $3; }
	| expr '%' expr	{ 
		int a, b;
		a = $1; 
		b = $3; 
		$$ = a % b; }
	| '(' expr ')'	{ $$ = $2; }
	| '-' expr %prec UNARYMINUS { $$ = -$2; }
	;
%%

#include <stdio.h>
#include <ctype.h>
#include <math.h>
#include <signal.h>
#include <setjmp.h>

jmp_buf begin;
char *progname;
int lineno = 1;

void fpecatch();
void warning(char *s, char *t);

int
main(int argc, char **argv)
{
	progname = argv[0];

	setjmp(begin);
	signal(SIGFPE, fpecatch);
	yyparse();
	return 0;
}

void
execerror(char *s, char *t)
{
	warning(s,t);
	longjmp(begin, 0);
}

void
fpecatch()
{
	execerror("floating point exception", (char *)0);
}

int
yylex()
{
	int c;

	/* ignore whitespace */
	while ((c = getchar()) == ' ' || c == '\t')
		;

	if (c == EOF)
		return 0;
	
	if (c == '.' || isdigit(c)) {
		ungetc(c, stdin);
		scanf("%lf", &yylval);
		return NUMBER;
	}
	if (islower(c)) {
		yylval.index = c - 'a';
		return VAR;
	}
	
	if (c == ';')
		return EXTERM;

	if (c == '\n') {
		lineno++;
		return EXTERM;
	}

	return c;
}

void
yyerror(char *s)
{
	warning(s, (char *)0);
}

void 
warning(char *s, char *t)
{
	fprintf(stderr, "%s: %s", progname, s);
	if (t)
		fprintf(stderr, " %s", t);
	fprintf(stderr, " near line %d\n", lineno);
}

