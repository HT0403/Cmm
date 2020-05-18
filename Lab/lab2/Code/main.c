#include <stdio.h>
#include "TreeNode.h"
#include "common.h"

extern FILE *yyin;
extern int yylineno;
extern struct TreeNode *root;
extern int nError;

void yyrestart(FILE *);
void yyparse();

int main(int argc, char **argv)
{
	int i;
	if (argc >= 2)
	{
		FILE *input_fp = fopen(argv[1], "r");
		if (!input_fp)
		{
			perror(argv[1]);
			return 1;
		}
		yyrestart(input_fp);
		yyparse();
		fclose(input_fp);
		yylineno = 1;
		if (nError == 0)
		{
			printTree(root);
		}
		if (nError || !root)
		{
			return 0;
		}
	}
	else
	{
		printf("./parser <input_file> <output_file>\n");
	}

	return 0;
}
