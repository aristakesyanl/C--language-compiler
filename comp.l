%option noyywrap nodefault
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "parser.tab.h"
    extern FILE *yyin;
    extern FILE *yyout;
    int lineno = 1;
    void yyerror();
    static void comment(void);
%}

WS [ \t\r\f]
D [0-9]
E ([Ee][+-]?{D}+)
FS  (f|F|l|L)
NZ [1-9]
L [a-zA-Z_]
A [a-zA-Z_0-9]
print       [ -~]
CCONST      (\'{print}\')|(\'\\[nftrbv]\')

%%
"/*"                  {comment();}
"//".*                {/*ignore comment*/}
"int"                 {return INT;}
"bool"                {return BOOL;}
"double"              {return DOUBLE;}
"char"                {return CHAR;}
"void"                {return VOID;}
"if"                  {return IF;}
"else"                {return ELSE;}
"while"               {return WHILE;}
"for"                 {return FOR;}
"continue"            {return CONTINUE;}
"break"               {return BREAK;}
"return"              {return RETURN;}
"print"               {return PRINT;}
"+"                   {return ADD_OP;}
"-"                   {return SUB_OP;}
"*"                   {return MUL_OP;}
"/"                   {return DIV_OP;}
"%"                   {return MOD_OP;}
"<"                   {return LS;}
">"                   {return GR;}
"=="                  {return EQ;}
"!="                  {return NOT_EQ;}
"++"                  {return INC_OP;}
"--"                  {return DEC_OP;}
"&&"                  {return AND_OP;}
"||"                  {return OR_OP;}
"!"                   {return NOT_OP;}
"("                   {return LPAREN;}
")"                   {return RPAREN;}
"["                   {return LBRACK;}
"]"                   {return RBRACK;}
"{"                   {return LBRACE;}
"}"                   {return RBRACE;}
";"                   {return SEMI;}
"."                   {return DOT;}
","                   {return COMMA;}
"="                   {return ASSIGN;}
"0"|{NZ}{D}*          {return ICONST;}
{D}+{E}{FS}?          {return FCONST;}
{D}*"."{D}+{E}?{FS}?  {return FCONST;}
{D}+"."{E}?{FS}?      {return FCONST;}
CCONST                {return CCONST;}
\"(\\.|[^"\\])*\"     {return STRING;}
{L}+{A}*              {return ID;}
{WS}+                 {/*ignore whitespace*/}
"\n"                  {lineno++;}
.                     {yyerror("unrecognized character");}
%%

static void comment(void){
    int c;
    while ((c = input()) != 0)
        if (c == '*'){
            while ((c = input()) == '*')
                ;
            if (c == '/')
                return;
            if (c == 0)
                break;
        }
    yyerror("unterminated comment");
}
