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
/* input:
| token_line input
;

token_line:
DIVISION {
	printf("DIVISION(type=\"%s\", ordinal=%d, original_type_text=\"%s\", original_ordinal_text=\"%s\", body=\"%s\")\n",
	$1->type, $1->ordinal, $1->original_type_text, $1->original_ordinal_text, $1->body);
	free($1->type); free($1->original_type_text); free($1->original_ordinal_text); free($1->body); free($1);
}

| ARTICLE {
printf("ARTICLE(ordinal=%f, original_ordinal_text=\"%s\", body=\"%s\")\n",
$1->ordinal, $1->original_ordinal_text, $1->body);
free($1->original_ordinal_text); free($1->body); free($1);
}

| SUBARTICLE {
printf("SUBARTICLE(ordinal=%f, original_ordinal_text=\"%s\", body=\"%s\")\n",
$1->ordinal, $1->original_ordinal_text, $1->body);
free($1->original_ordinal_text); free($1->body); free($1);
}

| BODY {
printf("BODY(text=\"%s\")\n", $1); free($1);
}

; */

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
