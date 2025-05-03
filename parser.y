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
  void* program;
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
%type <program>

%token <div> DIVISION
%token <article> ARTICLE SUBARTICLE
%token <str> BODY

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
  | token_lines           { $$ = NULL; }
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
  | %empty                        { $$ = NULL; }
  ;

subarticles:
  SUBARTICLE body subarticles     { $$ = subarticleGrammarAction($1, $2, $3); }
  | %empty                        { $$ = NULL; }

%%
