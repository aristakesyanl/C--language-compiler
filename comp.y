%{
	#include "symtab.c"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	extern FILE *yyin;
	extern FILE *yyout;
	extern int lineno;
	extern int yylex();
	void yyerror();
%}

%right '=' MUL_ASSIGN ADD_ASSIGN SUB_ASSIGN DIV_ASSIGN MOD_ASSIGN AND_ASSIGN OR_ASSIGN XOR_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN
%left OR_OP
%left AND_OP
%left '|' '^' '&'
%left EQ NOT_EQ
%left '<' GE_OP '>' LE_OP
%left LEFT_SHIFT RIGHT_SHIFT
%left '+' '-'
%left '*' '/' '%'

%token INT BOOL LONG SHORT LONGLONG FLOAT DOUBLE CHAR VOID
%token CONST
%token IF ELSE WHILE FOR DO 
%token EXTERN STATIC
%token CLASS PUBLIC PRIVATE
%token SWITCH CASE DEFAULT CONTINUE BREAK RETURN
%token EQ NOT_EQ LE_OP GE_OP
%token AND_OP
%token OR_OP
%token INC_OP DEC_OP
%token LEFT_OP RIGHT_OP
%token MUL_ASSIGN ADD_ASSIGN SUB_ASSIGN DIV_ASSIGN MOD_ASSIGN AND_ASSIGN OR_ASSIGN XOR_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN
%token I_CONSTANT F_CONSTANT STRING_LITERAL IDENTIFIER

%start program
%%

type_specifier
	:built_in_type
	;

built_in_type
	:INT
	|BOOL
	|LONG
	|LONGLONG
	|SHORT
	|FLOAT
	|DOUBLE
	|CHAR
	|VOID
	;

type_qualifier
	:/*empty*/
	|CONST
	;

primary_expression
	:IDENTIFIER
	|constant
	|STRING_LITERAL
	|'(' expression ')'
	;

constant
	:I_CONSTANT
	|F_CONSTANT
	;

unary_expression
	:INC_OP unary_expression
	|DEC_OP unary_expression
	|unary_operator cast_expression
	|postfix_expression
	;

unary_operator
	:'+'
	|'-'
	|'~'
	|'!'
	;

cast_expression
	:unary_expression
	|'(' type_specifier ')' cast_expression
	;

postfix_expression
	:primary_expression
	|postfix_expression '[' expression ']'
	|postfix_expression '(' ')'
	|postfix_expression '(' argument_list ')'
	|postfix_expression INC_OP
	|postfix_expression DEC_OP
	|postfix_expression '.' IDENTIFIER
	;

argument_list
	:expression
	|argument_list ',' expression
	;

expression
	:cast_expression
	|expression '+' expression
	|expression '-' expression
	|expression '*' expression
	|expression '/' expression
	|expression '%' expression
	|expression LEFT_SHIFT expression
	|expression RIGHT_SHIFT expression
	|expression '&' expression
	|expression '^' expression
	|expression '|' expression
	;

relational_expression
	:expression
	|expression '<' expression
	|expression '>' expression
	|expression LE_OP expression
	|expression GE_OP expression
	|expression EQ expression
	|expression NOT_EQ expression
	|relational_expression AND_OP relational_expression
	|relational_expression OR_OP relational_expression
	;

assignment_expression
	:unary_expression assignment_operator expression
	;

assignment_operator
	:'='
	|MUL_ASSIGN
	|DIV_ASSIGN
	|MOD_ASSIGN
	|ADD_ASSIGN
	|SUB_ASSIGN
	|LEFT_ASSIGN
	|RIGHT_ASSIGN
	|AND_ASSIGN
	|OR_ASSIGN
	|XOR_ASSIGN
	;

declaration
	:declaration_qualifier type_qualifier type_specifier direct_declarator '=' initializer
	;

declaration_qualifier
	:/*empty*/
	|EXTERN
	|STATIC
	;

direct_declarator
	:IDENTIFIER 
	|direct_declarator '[' expression ']' 
	;


initializer
	:expression
	|'{' '}'
	| '{' argument_list '}'
	;

statement
	:labeled_statement
	|expression_statement
	|selection_statement
	|iteration_statement
	|jump_statement
	|compound_statement
	;

labeled_statement
	:CASE expression ':' statement
	|DEFAULT ':' statement
	;

expression_statement
	:';'
	|assignment_expression ';'
	;
selection_statement
	:IF '('relational_expression ')' statement
	|IF '('relational_expression ')' statement ELSE statement 
	|SWITCH '(' expression ')' statement 
	;

iteration_statement
	:WHILE '(' relational_expression ')' statement 
	|DO statement WHILE '(' relational_expression ')' statement ';'
	|FOR '(' assignment_expression ';' relational_expression ';' expression ')'
	;

jump_statement
	:CONTINUE ';'
	|BREAK ';'
	|RETURN ';'
	|RETURN expression ';' 
	;

compound_statement
	:'{' '}'
	| '{' block_item_list '}'
	;

block_item_list
	:block_item
	|block_item_list block_item;

block_item
	:declaration ';'
	|statement
	;

program
	:external_declaration
	|program external_declaration
	;

external_declaration
	:declaration ';'
	|function_definition
	|class_definition
	;

function_definition
	:declaration_qualifier type_qualifier type_specifier IDENTIFIER '(' argument_list ')' compound_statement
	;

class_definition
	:CLASS IDENTIFIER class_compound_statement ';'
	;

class_compound_statement
	:'{' class_block_item_list '}'
	;

class_block_item_list
	:/*empty*/
	|PRIVATE ':' class_block_item_list
	|PUBLIC ':' class_block_item_list
	|function_definition class_block_item_list
	|declaration ';' class_block_item_list
	;	
%%

void yyerror ()
{
  fprintf(stderr, "Syntax error at line %d\n", lineno);
  exit(1);
}

int main(int argc, char *argv[]){
   // initialize symbol table
    init_hash_table();
 
    // open input file
    yyin = fopen(argv[1], "r");
    
    // lexical analysis
    yylex();
    fclose(yyin);
    
    // symbol table dump
    yyout = fopen("symtab_dump.out", "w");
    symtab_dump(yyout);
    fclose(yyout);  
    
    return 0;
}
