%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "grammar_actions.h"

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
  struct {
    char* type;
    int ordinal;
    char* original_type_text;
    char* original_ordinal_text;
    char* body;
  } *div;
  struct {
    float ordinal;
    char* original_ordinal_text;
    char* body;
  } *article;
}

%token <div> DIVISION
%token <article> ARTICLE SUBARTICLE
%token <str> BODY

%%

input:
    /* empty */
  | token_line input
  ;

token_line:
    DIVISION   { divisionGrammarAction($1); }
  | article    { ; }
  | BODY       { bodyGrammarAction($1); }
  ;

article:
  ARTICLE body subarticles        { articleGrammarAction($1); }

/* article:
  ARTICLE NUMBER body subarticles
  ; */

body:
   BODY body                      { bodyGrammarAction($1); }
  | %empty
  ;

subarticles:
  SUBARTICLE body subarticles     { subarticleGrammarAction($1); }
  | %empty
  ;

%%
