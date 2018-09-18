

#include ast.h
AST* astCreate(int type, HASH_NODE* symbol, AST* son0, AST* son1, AST* son2, AST* son3){
   AST* newnode;
   newnode = (AST*) calloc(1, sizeof(AST));
   newnode->type = type;
   newnode->symbol = symbol;
   newnode->son[0] = son0;
   newnode->son[1] = son1;
   newnode->son[2] = son2;
   newnode->son[3] = son3;
   return newnode;
   
}
void astPrint(AST* node){
   int i;
   if (newnode == 0)
      return;
   for(i=0; i<level; ++i)
      fprintf(stderr, "   ");
   fprintf(stderr, "AST(");
   switch(node->type){
      case AST_SYMBOL : fprintf(stderr, "AST_SYMBOL");break;
      default: fprintf(stderr, "AST_UNKNOWN"); break;
   }
   for(i=0; i< MAX_SONS; ++i)
}
