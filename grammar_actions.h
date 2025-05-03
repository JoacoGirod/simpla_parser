#ifndef GRAMMAR_ACTIONS
#define GRAMMAR_ACTIONS

#include <stdlib.h>

#include "abstract_syntax_tree.h"

void * divisionGrammarAction(const char * division);
void * articleGrammarAction(const char * article, Body * body, Subarticle * subarticle);
Subarticle * subarticleGrammarAction(const char * subarticle, Body * body, Subarticle * next_subarticle);
Body * bodyGrammarAction(const char * scentence, Body * body);

#endif