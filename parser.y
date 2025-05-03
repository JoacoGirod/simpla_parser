%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int yyparse(void);

// Provide a dummy error handler
void yyerror(const char* s) {
    fprintf(stderr, "Parse error: %s\n", s);
}


int main() {
    return yyparse();
}

%}

%union {
  char* str;
}

%token <str> DIVISION ARTICLE SUBARTICLE BODY

%%

input:
    /* empty */
  | token_line input
  ;

token_line:
    DIVISION   { printf("DIVISION(text=\"%s\")\n", $1); free($1); }
  | ARTICLE    { printf("ARTICLE(text=\"%s\")\n", $1); free($1); }
  | SUBARTICLE { printf("SUBARTICLE(text=\"%s\")\n", $1); free($1); }
  | BODY       { printf("BODY(text=\"%s\")\n", $1); free($1); }
  ;

%%
