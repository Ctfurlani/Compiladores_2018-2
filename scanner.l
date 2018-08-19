%{


int lineNumber = 1;

#include "tokens.h"
#include "hash.c"

%}

%x COMMENT
%x STRING



%%

"char"		{ return KW_CHAR; }
"int"		{ return KW_INT; }
"float"		{ return KW_FLOAT; }
"if"		{ return KW_IF; }
"then"		{ return KW_THEN; }
"else"		{ return KW_ELSE; }
"while"		{ return KW_WHILE; }
"or"		{ return OPERATOR_OR; }
"and"		{ return OPERATOR_AND; }
"not"		{ return OPERATOR_NOT; }
"read"		{ return KW_READ; }
"print"		{ return KW_PRINT; }
"return"	{ return KW_RETURN; }
">="		{ return OPERATOR_GE; }
"<="		{ return OPERATOR_LE; }
"=="		{ return OPERATOR_EQ;}

[-0-9]+			{ hashInsert(0,yytext); return LIT_INTEGER; }
[-0-9]*\.?[-0-9]+ 	{ hashInsert(0, yytext); return LIT_FLOAT; }
'(([^']|(\\.)))?'		{ hashInsert(0, yytext); return LIT_CHAR; }
\"([^\"\\n]|\\.)*\" 	{ hashInsert(0, yytext); return LIT_STRING; }

[_ACE-OR-Zace-or-z0-9][_ACE-OR-Zace-or-z0-9]*		{ hashInsert(0,yytext); return TK_IDENTIFIER; }
[-;:=+*,bdpq{}/<>!&$#]		{ return yytext[0]; }


"//".*

"/*" { BEGIN(COMMENT);}
<COMMENT>"*/" {BEGIN(INITIAL);}
<COMMENT>\n { ++lineNumber; }
<COMMENT>.

[ \t]					/* whitespace */
\n	{ ++lineNumber; }
.	{ return TOKEN_ERROR; }

%%


int running = 1;
void initMe(void){
	hashInit();
}

int isRunning(void){
	return running;
}
int getLineNumber(void){
	return lineNumber;
}

int yywrap()
{
running = 0;
return 1;
}
