%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	extern FILE *yyin;
	extern FILE *yyout;
	extern int lineno;
	extern int yylex();
	void yyerror();
%}

/* token definition */
%token CHAR INT DOUBLE IF ELSE WHILE FOR CONTINUE BREAK VOID RETURN BOOL
%token ADD_OP MUL_OP DIV_OP INC_OP OR_OP AND_OP NOT_OP MOD_OP DEC_OP SUB_OP
%token LS GR EQ NOT_EQ
%token LPAREN RPAREN LBRACK RBRACK LBRACE RBRACE SEMI DOT COMMA ASSIGN 
%token ID ICONST FCONST CCONST STRING
%token PRINT

%start program

%%
program: program general_statements;
 |/*empty*/
 ;

general_statements: declarations
 | statements
 ;
 

declarations: declaration declarations;
 |/*empty*/
 ;

declaration: INT variable SEMI
 | DOUBLE variable SEMI
 | BOOL variable SEMI
 | CHAR variable SEMI
 | VOID variable SEMI
 ;

variable: ID 
 | ID array
 ;

array: LBRACK ICONST RBRACK
 | array LBRACK ICONST RBRACK
 ;


statements: statement statements
 | /*empty*/
 ;

statement: if_statement
 | for_statement
 | while_statement
 | expression_statement
 | RETURN SEMI
 | BREAK SEMI
 | CONTINUE SEMI
 ;

if_statement: IF LPAREN expression RPAREN block else_part;

for_statement: FOR LPAREN expression SEMI expression SEMI expression RPAREN block;

while_statement: WHILE LPAREN expression RPAREN block;

expression_statement: variable ASSIGN expression SEMI;
 | expression INC_OP SEMI
 | expression DEC_OP SEMI
 ;

block: LBRACE RBRACE
 | LBRACE statements RBRACE
 ;

else_part: /*empty*/
 | ELSE block
 ;

expression: variable
 | LPAREN expression RPAREN
 | sign constant
 | expression LS expression
 | expression GR expression
 | expression EQ expression
 | expression NOT_EQ expression
 | expression ASSIGN expression
 | expression INC_OP
 | expression DEC_OP
 | expression ADD_OP expression
 | expression SUB_OP expression
 | expression MUL_OP expression
 | expression DIV_OP expression
 | expression MOD_OP expression
 | expression AND_OP expression
 | expression OR_OP expression
 | NOT_OP expression
 ;

constant: ICONST | FCONST | CCONST ;

sign: ADD_OP | SUB_OP | /*empty*/ ;

 
%%



void yyerror (const char* s)
{
  fprintf(stderr, "Error: %s in line %d\n", s,lineno);
  exit(1);
}

int main (int argc, char *argv[]){

	int flag;
	yyin = fopen(argv[1], "r");
	flag = yyparse();
	fclose(yyin);
	return flag;
}
