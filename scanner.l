%{


int lineNumber = 1;
int tok = 0;

char buf[100];
char *s;

char c;
int charCtrl = 0;

#include "tokens.h"

%}

%x COMMENT
%x STRING
%x CHAR

%%

"char"		{ printf("KW_CHAR "); }
"int"		{ printf("KW_INT "); }
"float"		{ printf("KW_FLOAT "); }
"if"		{ printf("KW_IF "); }
"then"		{ printf("KW_THEN "); }
"else"		{ printf("KW_ELSE "); }
"while"		{ printf("KW_WHILE "); }
"or"		{ printf("OPERATOR_OR "); }
"and"		{ printf("OPERATOR_AND "); }
"not"		{ printf("OPERATOR_NOT "); }
"read"		{ printf("KW_READ "); }
"print"		{ printf("KW_PRINT "); }
"return"	{ printf("KW_RETURN "); }
">="		{ printf("OPERATOR_GE "); }
"<="		{ printf("OPERATOR_LE "); }
"=="		{ printf("OPERATOR_EQ ");}

[0-9]+		{ printf("LIT_INTEGER "); }
[0-9]+[.0-9]* 	{ printf("LIT_FLOAT "); }

[A-Za-z_0-9][A-Za-z_0-9]*	{ printf("TK_IDENTIFIER[%s] ",yytext);}
[-;:=+*,bdpq{}/<>!&$#]		{ printf("%c ",yytext[0]); }


"//".*


\" { BEGIN(STRING); s = buf;}
<STRING>\\n 		{ *s++ = '\n'; }
<STRING>\\t 		{ *s++ = 't'; }
<STRING>\\\" 		{ *s++ = '\"'; }
<STRING>\" 		{
			  *s = 0;
			  BEGIN 0;	
			  printf("LIT_STRING '%s'\n", buf); 
			}
<STRING>\n		{ printf("invalid string\n");BEGIN 0; }
<STRING>.		{ *s++ = *yytext; }

\' { BEGIN(CHAR);}
<CHAR>\\n 		{ c = '\n'; }
<CHAR>\\t 		{ c = 't'; }
<CHAR>\\\' 		{ c = '\''; }
<CHAR>\'		{
			  if (charCtrl == 1){
			    charCtrl = 0;
		  	    BEGIN 0;
		 	    printf("LIT_CHAR '%c'\n", c);
			    c = '0';
			  }
			}
<CHAR>\n		{ printf("invalid char\n"); BEGIN 0;}
<CHAR>.			{ 
			  if (charCtrl == 0 ){
			    c = yytext[0]; 
			    charCtrl = 1;
			  }
			  else{
			   BEGIN 0;	  
			   charCtrl = 0 ;
			  }
			}


"/*" { BEGIN(COMMENT);}
<COMMENT>"*/" {BEGIN(INITIAL);}
<COMMENT>"\n" { ++lineNumber; }
<COMMENT>.

[ \t]
"\n"	{ ++lineNumber; }
.	{ printf("TOKEN_ERROR "); }

%%

int main(int argc, char **argv){
 yylex();
}


int yywrap()
{
//running = 0;
return 1;
}
