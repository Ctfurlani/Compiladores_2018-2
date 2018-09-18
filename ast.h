#define MAS_SONS 4
typedef struct ast_node {
   int type;
   struct ast_node *son[MAX_SONS];
} AST;

AST* astCreate(int type, AST* son0, AST* son1, AST* son2, AST* son3);
void astPrint(AST* node);
