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
  // No terminales
  void* token_lines;
  // void* article; //temp
  void* subarticles; //temp
  void* body;
  
  // Terminales
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

%type <token_lines> token_lines
%type <article> article
%type <subarticles> subarticles
%type <body> body

%token <div> DIVISION
%token <article> ARTICLE SUBARTICLE
%token <str> BODY

%%

program:
    /* empty */
  | token_lines
  ;

token_lines:
    DIVISION token_lines  { $$ =  divisionGrammarAction($1); }
  | article token_lines   { ; }
  | BODY token_lines      { $$ = bodyGrammarAction($1, NULL); }
  | %empty               { $$ = NULL; }
  ;

article:
  ARTICLE body subarticles        { $$ = articleGrammarAction($1, $2, $3); }
  ;

body:
   BODY body                      { bodyGrammarAction($1, $2); }
  | %empty
  ;

subarticles: 
  SUBARTICLE body subarticles     { $$ = subarticleGrammarAction($1, $2, $3); }
  | %empty                        { $$ = NULL; }

%%
