%{
#define YYSTYPE double
%}

%token	NUMBER
%left	'%'
%left	'+' '-'
%left	'*' '/'
%left	UNARYMINUS

%%
list:
	| list '\n'
	| list expr '\n'	{ printf("\t%.8g\n", $2); }
	;

expr:	  NUMBER	{ $$ = $1; }
	| '-' expr %prec UNARYMINUS { $$ = -$2; }
	| expr '+' expr	{ $$ = $1 + $3; }
	| expr '-' expr	{ $$ = $1 - $3; }
	| expr '*' expr	{ $$ = $1 * $3; }
	| expr '/' expr	{ $$ = $1 / $3; }
	| expr '%' expr	{ int a, b; a = $1; b = $3; $$ = a % b; }
	| '(' expr ')'	{ $$ = $2; }
	;
%%

#include <stdio.h>
#include <ctype.h>
#include <math.h>

char *progname;
int lineno = 1;

int
main(int argc, char **argv)
{
	progname = argv[0];

	yyparse();
	return 0;
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

	if (c == '\n')
		lineno++;

	return c;
}

/* todo: probably void */
int
yyerror(char *s)
{
	warning(s, (char *)0);
}

/* todo: probably void */
int 
warning(char *s, char *t)
{
	fprintf(stderr, "%s: %s", progname, s);
	if (t)
		fprintf(stderr, " %s", t);
	fprintf(stderr, " near line %d\n", lineno);
}



