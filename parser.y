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
%left 'd' 'b' 'q' 'p'

%union {
	HASH_NODE *symbol;
}
%nonassoc IFX
%nonassoc KW_ELSE

%%

program : list_dec
		;

list_dec	: list_dec dec_func
			| list_dec dec_var ';'
			|								
			;		
	dec_var		: data_type TK_IDENTIFIER '=' expr 								
				| data_type TK_IDENTIFIER 'q' expr 'p' 							
				| data_type TK_IDENTIFIER 'q' expr 'p' ':' list_literal			
				;
		data_type	: KW_CHAR													
					| KW_INT													
					| KW_FLOAT													
					; 
			list_literal 	: literal							
							| list_literal literal
							;
				literal 	: LIT_INTEGER  										
							| LIT_FLOAT											
							| LIT_CHAR											
							;
	dec_func	: header body													
				;
		header	: data_type TK_IDENTIFIER 'd' list_func 'b'
				;
			list_func	: param
						| list_func ',' param	
						;
				param	: data_type TK_IDENTIFIER
						|	/*empty*/
						;
		body	: block															
				;
			block	: '{' list_cmd '}'
					;
				list_cmd 	: cmd ';'											
							| list_cmd cmd ';' 									
							| /*empty*/											
							;
					cmd		: block												
							| attr												
							| flux_ctrl											
							| read												
							| print												
							| ret												
							| /*empty*/
							;
						attr	: TK_IDENTIFIER '=' expr
								| TK_IDENTIFIER 'q' expr 'p' '=' expr
								;
						read	: KW_READ TK_IDENTIFIER					
								;
						print	: KW_PRINT list_print
								;
							list_print	: elem
										| list_print ',' elem
										;
								elem	: LIT_STRING
										| expr
										;
						ret		: KW_RETURN expr				
								;
						flux_ctrl	: KW_IF expr KW_THEN cmd %prec IFX	
									| KW_IF expr KW_THEN cmd KW_ELSE cmd
									| KW_WHILE expr cmd
									;
	expr	: TK_IDENTIFIER										
			| literal
			| TK_IDENTIFIER 'q' expr 'p'			
			| 'd' expr 'b'
			| expr '+' expr						
			| expr '-' expr
			| expr '*' expr
			| expr '/' expr
			| expr '<' expr
			| expr '>' expr
			| expr OPERATOR_AND expr
			| expr OPERATOR_OR expr
			| expr OPERATOR_NOT expr
			| expr OPERATOR_LE expr
			| expr OPERATOR_GE expr
			| expr OPERATOR_EQ expr
			| TK_IDENTIFIER 'd' func_param 'b'					
			| 
			;
		func_param	: expr
					| func_param ',' expr
					;			
%%

int yyerror(char *msg)
{
fprintf(stderr, "Syntax Error at line: %d\n", getLineNumber());
exit(3);
}
