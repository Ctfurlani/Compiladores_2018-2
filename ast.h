#include hash.h

#define MAX_SONS 4
#define AST_SYMBOL 1
typedef struct ast_node {
   int type;
   struct ast_node *son[MAX_SONS];
   HASH_NODE *symbol;
} AST;

AST* astCreate(int type, HASH_NODE* symbol, AST* son0, AST* son1, AST* son2, AST* son3);
void astPrint(AST* node);
