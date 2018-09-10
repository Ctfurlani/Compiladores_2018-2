%{
#include <stdio.h>
#include <stdlib.h>
#include "hash.h"
extern int getLineNumber();
int yylex();
int yyerror(char *msg);

%}



%token KW_CHAR
%token KW_INT
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
%token<symbol> TK_IDENTIFIER
%token<symbol> LIT_INTEGER
%token<symbol> LIT_FLOAT
%token<symbol> LIT_CHAR
%token<symbol> LIT_STRING
%token TOKEN_ERROR

%left OPERATOR_LE OPERATOR_GE OPERATOR_EQ 
%left '<' '>'
%left OPERATOR_AND OPERATOR_OR
%left '+' '-'
%left '*' '/'

%union {
	HASH_NODE *symbol;
}
%nonassoc IFX
%nonassoc ELSE

%%

program : cmdlist
		|
		;

cmdlist : cmd  cmdlist
		| declaration  cmdlist
		|/*empty*/
		;

/*COMMANDS : ATTRIB, FLUX CONTROL, READ, PRINT, RETURN, BLOCK*/
cmd		: attribution								
		| flux_control
		| read
		| ret
		| function
		| print
		| block
		| /*empty*/
		;
		
attribution	: TK_IDENTIFIER '=' literal
			| TK_IDENTIFIER 'q' TK_IDENTIFIER 'p' '=' literal
			| TK_IDENTIFIER '=' function
			;
			
flux_control	: KW_IF expr KW_THEN cmd %prec IFX		
				| KW_IF expr KW_THEN cmd KW_ELSE cmd
				
				| KW_IF 'd' expr 'b' KW_THEN cmd %prec IFX	{fprintf(stderr,"Achei uma IF() %d \n", getLineNumber());}
				| KW_IF 'd' expr 'b' KW_THEN cmd KW_ELSE cmd
				| KW_WHILE expr block
				;
				
read			: KW_READ TK_IDENTIFIER 			{fprintf(stderr,"Achei uma READ %d \n", getLineNumber());}
				;

print			: KW_PRINT print_params				{fprintf(stderr,"Achei um PRINT %d \n", getLineNumber());} 
				;
				
print_params	: print_params ',' LIT_STRING
				| print_params ',' expr
				| expr
				| LIT_STRING
				;
				
ret				: KW_RETURN expr
				;
				
declaration	: data_type TK_IDENTIFIER 'd' param_list 'b' block		{fprintf(stderr,"Achei uma Func_declaracao %d \n", getLineNumber());}						
			| data_type TK_IDENTIFIER '=' expr ';'		{fprintf(stderr,"Achei uma declaracao %d \n", getLineNumber());} 
			| data_type TK_IDENTIFIER 'q' size_vec 'p'	';'	{fprintf(stderr,"Achei uma V_declaracao %d \n", getLineNumber());} 
			| data_type TK_IDENTIFIER 'q' size_vec 'p'':' init_vector';'	{fprintf(stderr,"Achei uma V_declaracao %d \n", getLineNumber());} 
			;
			
size_vec	: expr
			;
			
init_vector	: literal
			| init_vector literal 
			;
			
expr		: literal		{fprintf(stderr,"Achei um LIT_INT %d \n", getLineNumber());} 
			| TK_IDENTIFIER		{fprintf(stderr,"Achei um ID %d \n", getLineNumber());} 
			| TK_IDENTIFIER 'q'size_vec'p' {fprintf(stderr,"Achei um VETOR %d \n", getLineNumber());} 
			| expr '+' expr
			| expr '-' expr
			| expr '*' expr
			| expr '/' expr
			| expr '<' expr
			| expr '>' expr
			| expr OPERATOR_LE expr
			| expr OPERATOR_GE expr
			| expr OPERATOR_AND expr
			| expr OPERATOR_OR expr
			| expr OPERATOR_EQ expr
			| expr OPERATOR_NOT expr
			;
		
literal 	: LIT_INTEGER  {fprintf(stderr,"Achei um LIT_INT %d \n", getLineNumber());} 
			| LIT_FLOAT
			| LIT_CHAR
			;
/*FUNCTIONS*/	
function	: TK_IDENTIFIER 'd' proc_params 'b'		{fprintf(stderr,"Achei uma funcao\n");} 
			;
			
param_list	: param									{fprintf(stderr,"Achei uma lista de parametros\n");}
			| param_list ',' param  
			| /*empty*/
			;
			
param		: data_type TK_IDENTIFIER			{fprintf(stderr,"Achei um parametro\n");}
			;
			
proc_params	: expr
			| proc_params ',' expr  
			| /*empty*/
			;	
/* COMMANDS BLOCK*/		
block		: '{' block_cmd '}'			{fprintf(stderr,"Achei um bloco\n");}
			;
		
block_cmd	: block_cmd cmd ';'
			| cmd ';'
			| /*empty*/
			;
			
data_type	: KW_CHAR			{fprintf(stderr,"Achei um CHAR %d\n", getLineNumber());}
			| KW_INT			{fprintf(stderr,"Achei um INT\n");}
			| KW_FLOAT			{fprintf(stderr,"Achei um FLOAT\n");}
			; 					
%%

int yyerror(char *msg)
{
fprintf(stderr, "Syntax Error at line: %d\n", getLineNumber());
exit(3);
}
