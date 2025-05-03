#include "grammar_actions.h"

int subarticleCount = 0;
void *divisionGrammarAction(const char *division)
{
    // printf("DIVISION(text=\"%s\")\n", division);

    return NULL;
}

void *articleGrammarAction(const char *article, Body *body, Subarticle *subarticle)
{
    Body *bodyIter = body;
    Subarticle *subarticleIter = subarticle;
    // printf("A BODY: ");
    // while (bodyIter != NULL) {
    //     printf("%s ", bodyIter->scentence);
    //     bodyIter = bodyIter->next_body;
    // }

    // if (subarticleIter != NULL) printf("A SUBARTICLE: ");
    // while (subarticleIter != NULL) {
    //     subarticleCount += 1;
    //     printf(subarticleCount);
    //     // printf("%s ", subarticleIter->scentence);
    //     subarticleIter = subarticleIter->next_subarticle;
    // }

    // printf("ARTICLE(text=\"%s\")\n", division);

    return NULL;
}

Subarticle *subarticleGrammarAction(const char *subarticle, Body *body, Subarticle *next_subarticle)
{
    return NULL;

    Subarticle *new_subarticle = (Subarticle *)malloc(sizeof(Subarticle));
    new_subarticle->scentence = subarticle;
    new_subarticle->body = body;
    new_subarticle->next_subarticle = next_subarticle;

    return new_subarticle;
}

Body *bodyGrammarAction(const char *scentence, Body *body)
{
    Body *new_body = (Body *)malloc(sizeof(Body));
    new_body->scentence = scentence;
    new_body->next_body = body;

    return new_body;
}