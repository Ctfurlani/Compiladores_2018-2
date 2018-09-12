#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"


extern FILE *yyin;
extern int isRunning(void);
extern void initMe(void);
extern int getLineNumber();

int main(int argc, char** argv)
  {
  initMe();
  fprintf(stderr,"Rodando main da etapa2 \n");

  if (argc < 2)
    {
    printf("call: ./etapa2 input.txt  \n");
    exit(1);
    }
  if (0==(yyin = fopen(argv[1],"r")))
    {
    printf("Cannot open file %s... \n",argv[1]);
    exit(1);
    }
  yyparse();
  printf("Concluido\n");
  return 0;

  }
