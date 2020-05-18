test:main.o syntax.tab.o TreeNode.o
	gcc main.o syntax.tab.o TreeNode.o -lfl -ly -o test
main.o:main.c
	gcc -c main.c
syntax.tab.o:syntax.tab.c
	gcc -c syntax.tab.c
TreeNode.o:TreeNode.c
	gcc -c TreeNode.c
syntax.tab.c:syntax.y lexical.l
	bison -d syntax.y
	flex lexical.l
.PHONY:clean test1 test2 test3 test4 test5 test6
clean:
	rm -rf *.o lex.yy.c syntax.tab.c syntax.tab.h
test1:
	./test ../Test/test1.cmm

test2:
	./test ../Test/test2.cmm
test3:
	./test ../Test/test3.cmm
test4:
	./test ../Test/test4.cmm
test5:
	./test ../Test/test5.cmm
test6:
	./test ../Test/test6.cmm