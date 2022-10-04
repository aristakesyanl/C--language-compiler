run: parser.tab.c lex.yy.c ast.c
	gcc -o compiler parser.tab.c lex.yy.c ast.c

parser.tab.c: parser.y
	bison -d parser.y

lex.yy.c: scanner.l
	flex scanner.l
