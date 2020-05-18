test:flex_main_example.o lex.yy.o
	gcc flex_main_example.o lex.yy.o -lfl -ly -o test
flex_main_example.o:flex_main_example.c
	gcc -c flex_main_example.c
lex.yy.o:lex.yy.c
	gcc -c lex.yy.c
lex.yy.c:flex_example.l
	flex flex_example.l
# 定义的一些伪目标
.PHONY: clean test1 test2 test3 test4 test5 test6

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
clean:
	rm -rf lex.yy.c *.o
