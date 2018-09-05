%{
#include <stdio.h>
#include <stdlib.h>
%}

%union {
	int value;
}

%token KW_CHAR
%token<value> KW_INT
%token KW_FLOAT
%token KW_IF
%token KW_THEN
%token KW_ELSE
%token KW_WHILE
%token KW_READ
%token KW_RETURN
%token KW_PRINT
%token OPERATOR_LE
%token OPERATOR_GE
%token OPERATOR_EQ
%token OPERATOR_OR
%token OPERATOR_AND
%token OPERATOR_NOT
%token TK_IDENTIFIER
%token LIT_INTEGER
%token LIT_FLOAT
%token LIT_CHAR
%token LIT_STRING
%token TOKEN_ERROR

%%

program : //cmdlist
	;
/*
cmdlist : cmdlist
	|
	;

cmd:
	;

expr	: 
	;*/
%%

int yyerror(char *msg)
{
fprintf(stderr, "Syntax Error\n");
exit(3);
}
