%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  extern FILE *yyin;
  extern FILE *yyout;
  extern int lineno;
  extern int yylex();

  struct decl* parser_result;

  #include"ast.h"
  void yyerror();
%}

%union{
  int int_val;
  char* name;
  char char_val;
  double double_val;
  struct decl* decl;
  struct expr* expr;
  struct stmt* stmt;
  struct type* type;
  struct param_list* param_list;
}

/* token definition */
%token<int_val> CHAR INT BOOL
%token<double_val> DOUBLE
%token IF ELSE WHILE FOR CONTINUE BREAK VOID RETURN
%token ADD_OP MUL_OP DIV_OP INC_OP OR_OP AND_OP NOT_OP MOD_OP DEC_OP SUB_OP
%token LS GR EQ NOT_EQ
%token LPAREN RPAREN LBRACK RBRACK LBRACE RBRACE SEMI DOT COMMA ASSIGN 
%token<name> ID
%token<const int> ICONST
%token<const double> FCONST
%token<const char> CCONST
%token STRING
%token PRINT

%right ASSIGN
%left OR_OP
%left AND_OP
%left EQ NOT_EQ
%left LS GR
%left ADD_OP SUB_OP
%left MUL_OP DIV_OP MOD_OP
%right NOT_OP
%left INC_OP DEC_OP

%type<decl> program decl_list general_statement declaration function_definition
%type<stmt> statements statement if_statement for_statement while_statement
%type<stmt> return_statement expression_statement block 
%type<expr> expression variable function_call constant expression_list
%type<param_list> param_list argument_list argument

%start program

%%
program: decl_list
 {parser_result=$1;}
 ;
 
decl_list: general_statement decl_list
 {$$=$1; $1->next=$2;}
 |/*empty*/ {$$=0;}
 ; 

general_statement: declaration {$$=$1;}
 | function_definition {$$=$1;}
 ;
 
declaration: INT variable SEMI
 {$$=decl_create(yylval.name,type_create(TYPE_INTEGER,0,0),0,0,0);}
 | DOUBLE variable SEMI
 {$$=decl_create(yylval.name,type_create(TYPE_DOUBLE,0,0),0,0,0);}
 | BOOL variable SEMI
 {$$=decl_create(yylval.name,type_create(TYPE_BOOL,0,0),0,0,0);}
 | CHAR variable SEMI
 {$$=decl_create(yylval.name,type_create(TYPE_CHAR,0,0),0,0,0);}
 | VOID variable SEMI
 {$$=decl_create(yylval.name,type_create(TYPE_VOID,0,0),0,0,0);}
 | INT variable ASSIGN expression SEMI
 {$$=decl_create(yylval.name,type_create(TYPE_INTEGER,0,0),$4,0,0);}
 | DOUBLE variable ASSIGN expression SEMI
 {$$=decl_create(yylval.name,type_create(TYPE_DOUBLE,0,0),$4,0,0);}
 | BOOL variable ASSIGN expression SEMI
 {$$=decl_create(yylval.name,type_create(TYPE_BOOL,0,0),$4,0,0);}
 | CHAR variable ASSIGN expression SEMI
 {$$=decl_create(yylval.name,type_create(TYPE_CHAR,0,0),$4,0,0);}
 | VOID variable ASSIGN expression SEMI
 {$$=decl_create(yylval.name,type_create(TYPE_VOID,0,0),$4,0,0);}
 ;

variable: ID 
 {$$=expr_name(yylval.name);}
 | ID array
 {$$=expr_subscript(yylval.name);}
 ;

array: LBRACK ICONST RBRACK
 | array LBRACK ICONST RBRACK
 ;


statements: statement statements
 {$$=$1;$1->next=$2;}
 | /*empty*/
 {$$=0;}
 ;

statement: if_statement
 {$$=$1;}
 | for_statement
 {$$=$1;}
 | while_statement
 {$$=$1;}
 | expression_statement
 {$$=$1;}
 | return_statement
 {$$=$1;}
 | BREAK SEMI
 {$$=stmt_create(STMT_BREAK,0,0,0,0,0,0,0);}
 | CONTINUE SEMI
 {$$=stmt_create(STMT_CONTINUE,0,0,0,0,0,0,0);}
 ;

return_statement: RETURN SEMI
 {$$=stmt_create(STMT_RETURN,0,0,0,0,0,0,0);}
 | RETURN expression SEMI
 {$$=stmt_create(STMT_RETURN,0,0,$2,0,0,0,0);}
 ; 

if_statement: IF LPAREN expression RPAREN block
 {$$=stmt_create(STMT_IF_ELSE,0,0,$3,0,$5,0,0);}
 |IF LPAREN expression RPAREN block ELSE block
 {$$=stmt_create(STMT_IF_ELSE,0,0,$3,0,$5,$7,0);}
 ;

for_statement: FOR LPAREN expression SEMI expression SEMI expression RPAREN block
 {$$=stmt_create(STMT_FOR,0,$3,$5,$7,$9,0,0);};

while_statement: WHILE LPAREN expression RPAREN block
 {$$=stmt_create(STMT_WHILE,0,0,$3,0,$5,0,0);};

expression_statement: variable ASSIGN expression SEMI
 {$$=stmt_create(STMT_EXPR,0,0,expr_create(EXPR_ASSIGN,$1,$3),0,0,0,0);}
 | expression INC_OP SEMI
 {$$=stmt_create(STMT_EXPR,0,0,expr_create(EXPR_INC,0,0),0,0,0,0);}
 | expression DEC_OP SEMI
 {$$=stmt_create(STMT_EXPR,0,0,expr_create(EXPR_DEC,0,0),0,0,0,0);}
 ;

block: LBRACE RBRACE
 {$$=0;}
 | LBRACE statements RBRACE
 {$$=$2;}
 ;


expression: variable
 {$$=$1;}
 | function_call
 {$$=$1;}
 | LPAREN expression RPAREN
 {$$=$2;}
 | constant
 {$$=$1;}
 | expression LS expression
 {$$=expr_create(EXPR_LS,$1,$3);}
 | expression GR expression
 {$$=expr_create(EXPR_GR,$1,$3);}
 | expression EQ expression
 {$$=expr_create(EXPR_EQ,$1,$3);}
 | expression NOT_EQ expression
 {$$=expr_create(EXPR_NOT_EQ,$1,$3);}
 | expression ASSIGN expression
 {$$=expr_create(EXPR_ASSIGN,$1,$3);}
 | expression INC_OP
 {$$=expr_create(EXPR_INC,$1,0);}
 | expression DEC_OP
 {$$=expr_create(EXPR_DEC,$1,0);}
 | expression ADD_OP expression
 {$$=expr_create(EXPR_ADD,$1,$3);}
 | expression SUB_OP expression
 {$$=expr_create(EXPR_SUB,$1,$3);}
 | expression MUL_OP expression
 {$$=expr_create(EXPR_MUL,$1,$3);}
 | expression DIV_OP expression
 {$$=expr_create(EXPR_DIV,$1,$3);}
 | expression MOD_OP expression
 {$$=expr_create(EXPR_MOD,$1,$3);}
 | expression AND_OP expression
 {$$=expr_create(EXPR_AND,$1,$3);}
 | expression OR_OP expression
 {$$=expr_create(EXPR_OR,$1,$3);}
 | NOT_OP expression
 {$$=expr_create(EXPR_NOT,$2,0);}
 ;

constant: ICONST
 {$$=expr_val(yylval.int_val);}
 | FCONST
 {$$=expr_dval(yylval.double_val);}
 | CCONST
 {$$=expr_val(yylval.char_val);}
 ;
 


function_definition: INT variable LPAREN param_list RPAREN block
 {$$=decl_create(yylval.name,type_create(TYPE_FUNCTION,type_create(TYPE_INTEGER,0,0),$4),0,0,0);}
 |DOUBLE variable LPAREN param_list RPAREN block
 {$$=decl_create(yylval.name,type_create(TYPE_FUNCTION,type_create(TYPE_DOUBLE,0,0),$4),0,0,0);}
 |CHAR variable LPAREN param_list RPAREN block
 {$$=decl_create(yylval.name,type_create(TYPE_FUNCTION,type_create(TYPE_CHAR,0,0),$4),0,0,0);}
 |VOID variable LPAREN param_list RPAREN block
 {$$=decl_create(yylval.name,type_create(TYPE_FUNCTION,type_create(TYPE_VOID,0,0),$4),0,0,0);}
 |BOOL variable LPAREN param_list RPAREN block
 {$$=decl_create(yylval.name,type_create(TYPE_FUNCTION,type_create(TYPE_BOOL,0,0),$4),0,0,0);}
 ;

param_list: argument_list
 {$$=$1;}
 |/*empty*/
 {$$=0;}
 ;

argument_list: argument COMMA argument_list
 {$$=$1; $1->next=$3;}
 |/*empty*/
 {$$=0;}
 ;

argument: INT variable
 {$$=param_list_create(yylval.name,type_create(TYPE_INTEGER,0,0),0);}
 | BOOL variable
 {$$=param_list_create(yylval.name,type_create(TYPE_BOOL,0,0),0);}
 | CHAR variable
 {$$=param_list_create(yylval.name,type_create(TYPE_CHAR,0,0),0);}
 | DOUBLE variable
 {$$=param_list_create(yylval.name,type_create(TYPE_DOUBLE,0,0),0);}
 ;

function_call: variable LPAREN expression_list RPAREN
 {$$=expr_create(EXPR_CALL,expr_name(yylval.name),$3);}
 |variable LPAREN RPAREN
 {$$=expr_create(EXPR_CALL,expr_name(yylval.name),0);}
 ;

expression_list: expression COMMA expression_list
 {$$=$1; $1->right=$3;}
 | /*empty*/{$$=0;}
 ;   

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
