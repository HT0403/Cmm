test:lex.yy.o calculator.tab.o
	gcc lex.yy.o calculator.tab.o -lfl -ly -o test
lex.yy.o:lex.yy.c calculator.tab.h
	gcc -c lex.yy.c
calculator.tab.o:calculator.tab.c
	gcc -c calculator.tab.c
calculator.tab.c calculator.tab.h:calculator.y
	bison -d calculator.y
lex.yy.c:calculator.l
	flex calculator.l

.PHONY:clean test1
clean:
	rm -rf *.o lex.yy.c calculator.tab.c calculator.tab.h
test1:
	./test