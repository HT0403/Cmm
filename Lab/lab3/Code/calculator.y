%{
	#include<stdio.h>
	#include<math.h>
	#define YYSTYPE double
	#define pi 3.1415926
	void yyerror(char const *);
	int yylex(void);
	double sym[26];
%}
%token	HEXADECIMAL INTEGER VARIABLE SIN COS TAN LOG
%left	'+' '-'
%left	'*' '/'
%left	NEG
%left	'&'
%left	'|'
%left	'^'
%right	'@'
%right	'~'
%left	'!'
%left	'%'
%%
program:
	program statement '\n'
	|
	;
statement:
	expr	{printf("%lf\n",$1);}
	|VARIABLE '=' expr {sym[(int)$1]=$3;}
	;
expr:
	INTEGER
	|HEXADECIMAL
	|VARIABLE	{$$=sym[(int)$1];}
	|expr '+' expr	{$$=$1+$3;}
	|expr '-' expr	{$$=$1-$3;}
	|expr '*' expr	{$$=$1*$3;}
	|expr '/' expr	{$$=$1/$3;}
	|'-' expr %prec NEG	{$$=-$2;}
	|expr '&' expr	{$$=(int)$1 & (int)$3;}
	|expr '|' expr	{$$=(int)$1 | (int)$3;}
	|'@' expr	{$$=sqrt($2);}
	|expr '@' expr	{$$=pow($3,1/$1);}
	|'~' expr	{$$=~(int)$2;}
	|expr '!'	{int i=1,s=1;for(;i<=$1;i++)s*=i;$$=s;}
	|expr '^' expr	{$$=pow($1,$3);}
	|'('expr')'	{$$=$2;}
	|SIN'('expr')'	{$$=sin($3*pi/180.0);}
	|COS'('expr')'	{$$=cos($3*pi/180.0);}
	|TAN'('expr')'	{$$=tan($3*pi/180.0);}
	|LOG expr	{$$=log10($2);}
	|LOG expr expr	{$$=log($3)/log($2);}
	|expr '%' expr {$$=(int)$1%(int)$3;}
	;
%%
void yyerror(char const *msg)
{
	fprintf(stderr,"%s\n",msg);
}
int main(void)
{
	printf("科学计算器\n");
	printf("+加、-减、*乘、/除\n");
	printf("&与、|或、~反、！阶乘\n");
	printf("幂运算：a^b\n");
	printf("@ 开二次方根:@4\t开多次方根：3@27\n");
	printf("sin、cos、tan三角函数：sin(45)\n");
	printf("log 以10为底的对数:log10\t以任意数为底的对数:(注意加空格)log 2 4\n");
	printf("求余运算%%：\n");
    yyparse();
    return 0;
}
