#include "grammar_actions.h"

void * divisionGrammarAction(const char * division) {
    printf("DIVISION(text=\"%s\")\n", division); 
    free(division);
}

void * articleGrammarAction(const char * division) {
    printf("ARTICLE(text=\"%s\")\n", division); 
    free(division);
}

void * subarticleGrammarAction(const char * division) {
    printf("SUBARTICLE(text=\"%s\")\n", division); 
    free(division);
}

void * bodyGrammarAction(const char * division) {
    printf("BODY(text=\"%s\")\n", division); 
    free(division);
}
