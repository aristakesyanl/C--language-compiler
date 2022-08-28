compile
bison -d comp.y
flex comp.l
gcc -o compiler comp.tab.c lex.yy.c
./compiler example.c
