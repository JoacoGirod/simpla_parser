%{

#include "grammar_actions.h"

%}

%union {
  // No terminales
  void* divisions;
  void* program;
  void* articles;
  void* subarticles;
  void* body;

  // Terminales
  char* str;
  char * preambulo;
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

%type <program> program
%type <divisions> divisions
%type <articles> articles
%type <subarticles> subarticles
%type <body> body

%token <div> DIVISION
%token <article> ARTICLE SUBARTICLE
%token <str> PREAMBULO BODY

// DEBUG VERSION

%%

program:
   PREAMBULO BODY divisions     { $$ = programGrammarAction($3); }
  | body divisions              { $$ = programGrammarAction($2); }
  ;

divisions:
    DIVISION body articles divisions    { $$ =  divisionGrammarAction($1, $2, $3, $4); }
  | %empty                              { $$ = NULL; }
  ;

articles:
  ARTICLE body subarticles articles     { $$ = articleGrammarAction($1, $2, $3, $4); }
  | %empty                              { $$ = NULL; }
  ;

body:
   BODY body                      { $$ = bodyGrammarAction($1, $2); }
  | %empty                        { $$ = NULL; }
  ;

subarticles:
  SUBARTICLE body subarticles     { $$ = subarticleGrammarAction($1, $2, $3); }
  | %empty                        { $$ = NULL; }

%%
