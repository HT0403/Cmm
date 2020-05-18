%{
	#include<stdio.h>
	#include "TreeNode.h"
	#include<stdarg.h>

	int yylex();
	void yyerror(char *pstr);
	void detailedMessage(const char *msg);
	struct TreeNode *root=NULL;
	extern int nError;
	extern int newLine;
%}

/*declared types*/

%union{
	int nType;
	struct TreeNode *pNode;
};

/*declared tokens*/
%token <pNode> INT FLOAT
%token <pNode> ID
%token <pNode> SEMI COMMA
%token <pNode> ASSIGNOP
%token <pNode> RELOP
%token <pNode> PLUS MINUS STAR DIV AND OR 
%token <pNode> DOT
%token <pNode> NOT
%token <pNode> LP RP LB RB LC RC
%token <pNode> STRUCT RETURN IF ELSE WHILE
%token <pNode> UNDEF
%token <pNode> TYPE

/* declared non-terminals */
%type <pNode> Program ExtDefList ExtDef ExtDecList
%type <pNode> Specifier StructSpecifier OptTag Tag
%type <pNode> VarDec FunDec VarList ParamDec
%type <pNode> CompSt StmtList Stmt
%type <pNode> DefList Def DecList Dec
%type <pNode> Exp Args

%right ASSIGNOP
%left OR
%left AND
%left RELOP
%left PLUS MINUS
%left STAR DIV
%right NOT
%left DOT
%left LC RC
%left LB RB 
%left LP RP
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
%nonassoc STRUCT RETURN WHILE

%%

Program : ExtDefList	{
		$$ = createNode("Program", @$.first_line); 
		$$->nType = T_Program;
		addChild($$, $1);
		root = $$;
	}
	;
ExtDefList : ExtDef ExtDefList	{
		$$ = createNode("ExtDefList", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		$$->nType =T_ExtDefList;
	}
	| {//null
		$$ = NULL;
	}
	;
ExtDef : Specifier ExtDecList SEMI	{
		$$ = createNode("ExtDef", @$.first_line); 
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		$$->nType = T_ExtDef;
	}
	| Specifier SEMI	{
		$$ = createNode("ExtDef", @$.first_line); 
		addChild($$, $1);
		addChild($$, $2);
		$$->nType = T_ExtDef;
	}
	| Specifier FunDec CompSt	{
		$$ = createNode("ExtDef", @$.first_line); 
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		$$->nType = T_ExtDef;
	}
	| Specifier FunDec SEMI {
		$$ = createNode("ExtDef", @$.first_line); 
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		$$->nType = T_ExtDef;
	}
	| error SEMI {//error recovery
		//yyerror("Missing \";\"");
		nError ++;
	}
	;
ExtDecList : VarDec	{
		$$ = createNode("ExtDecList", @$.first_line); 
		addChild($$, $1);
		$$->nType = T_ExtDecList;
	}
	| VarDec COMMA ExtDecList	{
		$$ = createNode("ExtDecList", @$.first_line); 
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		$$->nType = T_ExtDecList;
	}
	;

Specifier : TYPE	{
		$$ = createNode("Specifier", @$.first_line); 
		addChild($$, $1);
		$$->nType =T_Specifier;
	}
	| StructSpecifier	{
		$$ = createNode("Specifier", @$.first_line); 
		addChild($$, $1);
		$$->nType =T_Specifier;
	}
	;
StructSpecifier : STRUCT Tag	{
		$$ = createNode("StructSpecifier", @$.first_line); 
		addChild($$, $1);
		addChild($$, $2);
		$$->nType =T_StructSpecifier;
	}
	| STRUCT OptTag LC DefList RC	{
		$$ = createNode("StructSpecifier", @$.first_line); 
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		addChild($$, $4);
		addChild($$, $5);
		$$->nType =T_StructSpecifier;
	}
	| STRUCT OptTag LC error RC {//error handle
		//yyerror("Missing \"{\"");
		nError ++;	
	}
	;
OptTag : ID	{
		$$ = createNode("OptTag", @$.first_line);
		addChild($$, $1);
		$$->nType = T_OptTag;
	}
	| {//null
		$$ = NULL;
	}
	;
Tag : ID	{
		$$ = createNode("Tag", @$.first_line);
		addChild($$, $1);
		$$->nType =T_Tag;
	}
	;

VarDec : ID	{
		$$ = createNode("VarDec", @$.first_line);
		addChild($$, $1);
		$$->nType =T_VarDec;
	}
	| VarDec LB INT RB	{
		$$ = createNode("VarDec", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		addChild($$, $4);
		$$->nType =T_VarDec;
	}
	| VarDec LB error	{//error handle	
		//yyerror("Missing \"]\"");
		nError ++;	
	}
	;
FunDec : ID LP VarList RP{
		$$ = createNode("FunDec", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		addChild($$, $4);
		$$->nType = T_FunDec;
	}
	| ID LP RP	{
		$$ = createNode("FunDec", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		$$->nType = T_FunDec;
	}
	| ID error RP {//error handle
		//yyerror("Missing \"(\"");
		nError ++;	
	}
	;
VarList : ParamDec COMMA VarList	{
		$$ = createNode("VarList", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		$$->nType =T_VarList;
	}
	| ParamDec	{
		$$ = createNode("VarList", @$.first_line);
		addChild($$, $1);
		$$->nType =T_VarList;
	}
	;
ParamDec : Specifier VarDec	{
		$$ = createNode("ParamDec", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		$$->nType =T_ParamDec;
	}
	;

CompSt : LC DefList StmtList RC	{
		$$ = createNode("CompSt", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		addChild($$, $4);
		$$->nType =T_CompSt;
	}
	| LC error RC {
		nError ++;	
		//yyerror("Missing \"*\"");
	}
	;
StmtList : Stmt StmtList	{
		$$ = createNode("StmtList", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		$$->nType =T_StmtList;
	}
	| {//null
		$$ = NULL;
	}
	;
Stmt : Exp SEMI	{
		$$ = createNode("Stmt", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		$$->nType =T_Stmt;
	}
	| CompSt	{
		$$ = createNode("Stmt", @$.first_line);
		addChild($$, $1);
		$$->nType =T_Stmt;
	}
	| RETURN Exp SEMI	{
		$$ = createNode("Stmt", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		$$->nType =T_Stmt;
	}
	| IF LP Exp RP Stmt %prec LOWER_THAN_ELSE	{
		$$ = createNode("Stmt", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		addChild($$, $4);
		addChild($$, $5);
		$$->nType =T_Stmt;
	}
	| IF LP Exp RP Stmt ELSE Stmt	{
		$$ = createNode("Stmt", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		addChild($$, $4);
		addChild($$, $5);
		addChild($$, $6);
		addChild($$, $7);
		$$->nType =T_Stmt;
	}
	| WHILE LP Exp RP Stmt	{
		$$ = createNode("Stmt", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		addChild($$, $4);
		addChild($$, $5);
		$$->nType =T_Stmt;
	}
	| Exp error SEMI	{//error handle
		//yyerror("Missing \";\"");
		nError ++;
	}
	;

DefList : Def DefList	{
		$$ = createNode("DefList", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		$$->nType =T_DefList;
	}
	| {//null
		$$ = NULL;
	}
	;
Def : Specifier DecList SEMI	{
		$$ = createNode("Def", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		$$->nType =T_Def;
	}
	| Specifier DecList error SEMI	{//error handle
		nError ++;
		//yyerror("Missing \";\"");
	}
	;
DecList : Dec	{
		$$ = createNode("DecList", @$.first_line);
		addChild($$, $1);
		$$->nType =T_DecList;
	}
	| Dec COMMA DecList	{
		$$ = createNode("DecList", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		$$->nType =T_DecList;
	}
	;
Dec : VarDec	{
		$$ = createNode("Dec", @$.first_line);
		addChild($$, $1);
		$$->nType =T_Dec;
	}
	| VarDec ASSIGNOP Exp	{
		$$ = createNode("Dec", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		$$->nType =T_Dec;
	}
	;

Exp : Exp ASSIGNOP Exp	{
		$$ = createNode("Exp", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		$$->nType =T_Exp;
	}
	| Exp AND Exp	{
		$$ = createNode("Exp", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		$$->nType =T_Exp;
	}
	| Exp OR Exp	{
		$$ = createNode("Exp", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		$$->nType =T_Exp;
	}
	| Exp RELOP Exp	{
		$$ = createNode("Exp", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		$$->nType =T_Exp;
	}
	| Exp PLUS Exp	{
		$$ = createNode("Exp", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		$$->nType =T_Exp;
	}
	| Exp MINUS Exp	{
		$$ = createNode("Exp", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		$$->nType =T_Exp;
	}
	| Exp STAR Exp	{
		$$ = createNode("Exp", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		$$->nType =T_Exp;
	}
	| Exp DIV Exp	{
		$$ = createNode("Exp", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		$$->nType =T_Exp;
	}
	| LP Exp RP		{
		$$ = createNode("Exp", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		$$->nType =T_Exp;
	}
	| MINUS Exp		{
		$$ = createNode("Exp", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		$$->nType =T_Exp;
	}
	| NOT Exp		{
		$$ = createNode("Exp", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		$$->nType =T_Exp;
	}
	| ID LP Args RP	{
		$$ = createNode("Exp", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		addChild($$, $4);
		$$->nType =T_Exp;
	}
	| ID LP RP		{
		$$ = createNode("Exp", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		$$->nType =T_Exp;
	}
	| Exp LB Exp RB	{
		$$ = createNode("Exp", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		addChild($$, $4);
		$$->nType =T_Exp;
	}
	| Exp DOT ID	{
		$$ = createNode("Exp", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		$$->nType =T_Exp;
	}
	| ID			{
		$$ = createNode("Exp", @$.first_line);
		addChild($$, $1);
		$$->nType =T_Exp;
	}
	| INT			{
		$$ = createNode("Exp", @$.first_line);
		addChild($$, $1);
		$$->nType =T_Exp;
	}
	| FLOAT			{
		$$ = createNode("Exp", @$.first_line);
		addChild($$, $1);
		$$->nType =T_Exp;
	}
	| Exp LB error RB	{//error handle 
		//yyerror("Missing \"]\"");
		nError ++;
	}
	;

Args : Exp COMMA Args	{
		$$ = createNode("Args", @$.first_line);
		addChild($$, $1);
		addChild($$, $2);
		addChild($$, $3);
		$$->nType =T_Args;
	}
	| Exp			{
		$$ = createNode("Args", @$.first_line);
		addChild($$, $1);
		$$->nType =T_Args;
	}
	;

%%

#include "lex.yy.c"



void yyerror(char *pstr)
{
	fprintf(stderr, "黄庭180650208 Error type B at Line %d : %s,near '%s'\n", yylineno, pstr,yytext);
    nError ++;
}
