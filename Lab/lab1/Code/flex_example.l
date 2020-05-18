SEMI        ;
COMMA       ,
ASSIGNOP    =
RELOP       >|<|>=|<=|==|!=
PLUS        \+
MINUS       -
STAR        \*
DIV         \/
AND         &&
OR          \|\|
DOT         \.
NOT         !
TYPE        int|float
LP          \(
RP          \)
LB          \[
RB          \]
LC          \{
RC          \}
STRUCT      struct 
RETURN      return 
IF          if
ELSE        else
WHILE       while

ID          [_a-zA-Z][_a-zA-Z0-9]*

digit       [0-9]
digits      {digit}+
radix       ({digits}\.{digit}?)|({digit}?\.{digits})

INT         {digits}
FLOAT       ({digits}\.{digits})|({radix}[E|e][+-]?{digits}) 

BLANK       [\n\t\r ]+


%%
\n          {}

{SEMI}          {
        printf("SEMI.lex: %s\n", yytext);
    }
{COMMA}         {
        printf("COMMA.lex: %s\n", yytext);
    }
{ASSIGNOP}      {
        printf("ASSIGNOP.lex: %s\n", yytext);
    }
{RELOP}         {
        printf("RELOP.lex: %s\n", yytext);
    }
{PLUS}         {
        printf("PLUS.lex: %s\n", yytext);
    }
{MINUS}         {
        printf("MINUS.lex: %s\n", yytext);
    }
{STAR}          {
        printf("STAR.lex: %s\n", yytext);
    }
{DIV}           {
        printf("DIV.lex: %s\n", yytext);
    }
{AND}           {
        printf("AND.lex: %s\n", yytext);
    }
{OR}            {
        printf("OR.lex: %s\n", yytext);
    }
{DOT}           {
        printf("DOT.lex: %s\n", yytext);
    }
{NOT}           {
        printf("NOT.lex: %s\n", yytext);
    }
{LP}            {
        printf("LP.lex: %s\n", yytext);
    }
{RP}            {
        printf("RP.lex: %s\n", yytext);
    }
{LB}            {
        printf("LB.lex: %s\n", yytext);
    }
{RB}            {
        printf("RB.lex: %s\n", yytext);
    }
{LC}            {
        printf("LC.lex: %s\n", yytext);
    }
{RC}            {
        printf("RC.lex: %s\n", yytext);
    }
{STRUCT}        {
        printf("STRUCT.lex: %s\n", yytext);
    }
{RETURN}        {
        printf("RETURN.lex: %s\n", yytext);
    }
{IF}            {
        printf("IF.lex: %s\n", yytext);
    }
{ELSE}          {
        printf("ELSE.lex: %s\n", yytext);
    }
{WHILE}         {
        printf("WHILE.lex: %s\n", yytext);
    }

{TYPE}          {
        printf("TYPE.lex: %s\n", yytext);
    }
{INT}           {
        printf("INT.lex: %s\n", yytext);
}
{ID}            {
        printf("ID.lex: %s\n", yytext);
    }
{FLOAT}         {
        printf("FLOAT.lex: %s\n", yytext);
    }

{BLANK} {}

.               {
    printf("\n黄庭180650208\n Error type A: Mysterious characters \'%s\'\n", yytext);}
%%


