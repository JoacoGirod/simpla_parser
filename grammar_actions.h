#ifndef GRAMMAR_ACTIONS
#define GRAMMAR_ACTIONS

#include <stdlib.h>

#include "abstract_syntax_tree.h"
#include "lexer_utils.h"

void * programGrammarAction(Division * division);
Division * divisionGrammarAction(DivisionInfo * division, Body * body, Article * article, Division * next_division);
Article * articleGrammarAction(ArticleInfo * article, Body * body, Subarticle * subarticle, Article * next_article);
Subarticle * subarticleGrammarAction(ArticleInfo * subarticle, Body * body, Subarticle * next_subarticle);
Body * bodyGrammarAction(const char * scentence, Body * body);

#endif