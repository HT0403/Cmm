#include "TreeNode.h"

struct TreeNode *newNode()
{
	struct TreeNode *node = (struct TreeNode *)malloc(sizeof(struct TreeNode));
	memset(node, 0, sizeof(struct TreeNode));

	return node;
}

struct TreeNode *createNode(char *pstr, int lineno)
{
	struct TreeNode *node = newNode();
	node->lineno = lineno;
	node->info = (char *)malloc(strlen(pstr) + 1);
	strncpy(node->info, pstr, strlen(pstr));
	node->info[strlen(pstr)] = '\0';

	return node;
}

void addChild(struct TreeNode *parent, struct TreeNode *child)
{
	if (!parent)
		return;
	parent->childs[parent->nChild++] = child;
}

void printNode(struct TreeNode *subTree, int depth)
{
	int i;
	for (i = 0; i < depth; i++)
		printf("  ");
	if (subTree->nType >= T_Program)
	{
		printf("%s (%d)\n", subTree->info, subTree->lineno);
	}
	else if (subTree->nType > T_Type)
	{
		printf("%s\n", subTree->info);
	}
	else
	{
		switch (subTree->nType)
		{
		case T_Int:
			printf("%s: %d\n", subTree->info, subTree->iValue);
			break;
		case T_Float:
			printf("%s: %f\n", subTree->info, subTree->fValue);
			break;
		case T_Id:
			printf("%s: %s\n", subTree->info, subTree->ptr);
			break;
		case T_Type:
			printf("%s: %s\n", subTree->info, subTree->ptr);
			break;
		}
	}
}

void preOrder(struct TreeNode *subTree, int depth)
{
	if (subTree != NULL)
	{
		printNode(subTree, depth);

		int i;
		for (i = 0; i < subTree->nChild; i++)
			preOrder(subTree->childs[i], depth + 1);
	}
}

void printTree(struct TreeNode *root)
{
	preOrder(root, 0);
}

void deleteTree(struct TreeNode *root)
{
	if (root != NULL)
	{
		int i;
		for (i = 0; i < root->nChild; i++)
			deleteTree(root->childs[i]);
		free(root);
	}
}
