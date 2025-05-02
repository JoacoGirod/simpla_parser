%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// Declare yylex so the parser knows about it
int yylex(void);

// Provide a dummy error handler
void yyerror(const char* s) {
    fprintf(stderr, "Parse error: %s\n", s);
}
%}

%union {
  char* str;
}

%token <str> DIVISION ARTICLE SUBARTICLE BODY

%%

input:
    /* empty */
  | input token_line
  ;

token_line:
    DIVISION   { printf("DIVISION(text=\"%s\")\n", $1); free($1); }
  | ARTICLE    { printf("ARTICLE(text=\"%s\")\n", $1); free($1); }
  | SUBARTICLE { printf("SUBARTICLE(text=\"%s\")\n", $1); free($1); }
  | BODY       { printf("BODY(text=\"%s\")\n", $1); free($1); }
  ;

%%
