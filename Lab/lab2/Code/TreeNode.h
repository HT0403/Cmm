#ifndef _TREENODE_H_
#define _TREENODE_H_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef enum ValueType
{
	//value
	T_Int = 1,
	T_Float,
	T_Id,
	//sign
	T_Semi,
	T_Comma,
	T_Assignop,
	T_Relop,
	T_Plus,
	T_Minus,
	T_Star,
	T_Div,
	T_And,
	T_Or,
	T_Dot,
	T_Not,
	T_Lp,
	T_Rp,
	T_Lb,
	T_Rb,
	T_Lc,
	T_Rc,
	//keyword
	T_Struct,
	T_Return,
	T_If,
	T_Else,
	T_While,
	T_Type,
	//nonterminals
	T_Program,
	T_ExtDefList,
	T_ExtDef,
	T_ExtDecList,
	T_Specifier,
	T_StructSpecifier,
	T_OptTag,
	T_Tag,
	T_VarDec,
	T_FunDec,
	T_VarList,
	T_ParamDec,
	T_CompSt,
	T_StmtList,
	T_Stmt,
	T_DefList,
	T_Def,
	T_DecList,
	T_Dec,
	T_Exp,
	T_Args
} ValueType;

typedef struct TreeNode
{
	int lineno;
	ValueType nType;
	union {
		int iValue;
		float fValue;
		char *ptr;
	};
	char *info;
	int nChild;
	struct TreeNode *childs[8];
} TreeNode;

struct TreeNode *newNode();
struct TreeNode *createNode(char *pstr, int lineno);
void addChild(struct TreeNode *parent, struct TreeNode *child);
void printTree(struct TreeNode *root);
void deleteTree(struct TreeNode *root);

#endif
