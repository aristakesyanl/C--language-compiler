%option noyywrite nodefault
%{
	#include<ast.h>
	#include<calc.tab.h>
	#include<stdio.h>
	#include<stdlib.h>
	extern void yyerror(const char *);  /* prints grammar violation message */
	static void comment(void);
        extern int check_type(void);
%}

WS [\t\v\n\f]
D [0-9]
E ([Ee][+-]?{D}+)
FS  (f|F|l|L)
NZ [1-9]
L [a-zA-Z_]
A [a-zA-Z_0-9]

%%
"/*"                 {comment();}
"//".*               {/*ignore comment*/}
"int"                {return INT;}
"bool"               {return BOOL;}
"long"               {return LONG;}
"short"              {return SHORT;}
"long long"          {return LONG LONG;}
"float"              {return FLOAT;}
"double"             {return DOUBLE;}
"char"               {return CHAR;}
"void"               {return VOID;}
"const"              {return CONST;}
"if"                 {return IF;}
"else"               {return ELSE;}
"while"              {return WHILE;}
"for"                {return FOR;}
"do"                 {return DO;}
"sizeof"             {return SIZEOF;}
"extern"             {return EXTERN;}
"static"             {return STATIC;}
"class"              {return CLASS;}
"public"             {return PUBLIC;}
"private"            {return PRIVATE;}
"case"               {return CASE;}
"default"            {return DEFAULT;}
"switch"             {return SWITCH;}
"continue"           {return CONTINUE;}
"break"              {return BREAK;}
"return"             {return RETURN;}
"+" |
"-" |
"*" |
"/" |
"|" |
"(" |
")" |
"%" |
"|" |
"&" |
"!" |
"~" |
":" |
";" |
"=" |
"<" |
">" |
"^" |
"." |
","                   {return yytext[0];}
"=="                  {return EQ;}
"!="                  {return NOT_EQ;}
"<="                  {return LE;}
">="                  {return GE;}
"++"                  {return INC_OP;}
"--"                  {return DEC_OP;}
"&&"                  {return AND_OP;}
"||"                  {return OR_OP;}
"*="                  {return MUL_ASSIGN;}
"+="                  {return ADD_ASSIGN;}
"-="                  {return SUB_ASSIGN;}
"/="                  {return DIV_ASSIGN;}
"%="                  {return MOD_ASSIGN;}
"&="                  {return AND_ASSIGN;}
"|="                  {return OR_ASSIGN;}
"^="                  {return XOR_ASSIGN;}
"<<="                 {return LEFT_ASSIGN;}
">>="                 {return RIGHT_ASSIGN;}
"<<"                  {return LEFT_OP;}
">>"                  {return RIGHT_OP;}
{NZ}{D}*              {return I_CONSTANT;}
{D}+{E}{FS}?          {return F_CONSTANT;}
{D}*"."{D}+{E}?{FS}?  {return F_CONSTANT;}
{D}+"."{E}?{FS}?      {return F_CONSTANT;}
\"(\\.|[^"\\])*\"     {return STRING_LITERAL;}
[L]+[A]*              {return IDENTIFIER;}
{WS}+                 {/*ignore whitespace*/}
.                     {/*ignore bad character*/}
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
