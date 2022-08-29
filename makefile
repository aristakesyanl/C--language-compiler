run: comp.tab.c lex.yy.c
	gcc -o compiler comp.tab.c lex.yy.c

comp.tab.c: comp.y
	bison -d comp.y

lex.yy.c: comp.l
	flex comp.l
