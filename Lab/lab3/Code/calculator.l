%{
	#include<stdlib.h>
	#define YYSTYPE double
	#include "calculator.tab.h"
	void yyerror(char const *);
%}

%%
[a-z]	{
	yylval=*yytext-'a';
	return VARIABLE;
	}
	/*16进制*/
0x\.?[a-f0-9]+|0x[a-f0-9]+\.[a-f0-9]*	{
	yylval=atof(yytext);
	return HEXADECIMAL;
	}
	/*小数和整数*/
\.?[0-9]+|[0-9]+\.[0-9]*	{
	yylval = atof(yytext);
	return INTEGER;
	}
	/*运算符*/
[-+()=/*&|~!^@%\n]	{return *yytext;}
	/*三角函数*/
sin	{
	return SIN;
}
cos	{
	return COS;
}
tan	{
	return TAN;
}
	/*对数运算*/
log	{
	return LOG;
}
[ \t]	{}
.	{
	printf("\n黄庭180650208\n Error type A:Mysterious characters \'%s\'\n", yytext);
}
%%
int yywrap(void)
{
	return 1;
}
