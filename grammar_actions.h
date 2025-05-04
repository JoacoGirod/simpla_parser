#ifndef GRAMMAR_ACTIONS
#define GRAMMAR_ACTIONS

#include <stdlib.h>

#include "abstract_syntax_tree.h"
#include "lexer_utils.h"

void * divisionGrammarAction(DivisionInfo * division, Body * body);
void * articleGrammarAction(ArticleInfo * article, Body * body, Subarticle * subarticle);
Subarticle * subarticleGrammarAction(ArticleInfo * subarticle, Body * body, Subarticle * next_subarticle);
Body * bodyGrammarAction(const char * scentence, Body * body);

#endif