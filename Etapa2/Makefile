#
# UFRGS - Compiladores B - Marcelo Johann - 2009/2 - Etapa 1
#
# Makefile
# Read the comments on Makefile2. All of them apply here too.
# But now the hash table is compiled in a separate gcc call
# Therefore, there must be a header of it to be included in scanner.l
#

etapa2: y.tab.o lex.yy.o hash.o 
	gcc y.tab.o lex.yy.o hash.o -o etapa2
#
#main.o: main.c
#	gcc -c main.c

y.tab.o: y.tab.c 
	gcc -c y.tab.c
lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

hash.o: hash.c 
	gcc -c hash.c

lex.yy.c: scanner.l
	lex scanner.l

y.tab.c: parser.y
	yacc -d parser.y 
clean:
	rm *.o lex.yy.c y.tab.c etapa2 y.tab.h

