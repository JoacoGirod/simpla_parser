#include "grammar_actions.h"
#include <assert.h>

void * programGrammarAction(Division * division) {
    // Aca podemos imprimir toda la estructura, hacer chiches
    // Hay un mejor lugar para hacerlo, pero aca ya tenemos todo


    // OJOTA!! hay divisions sin articles: ej - PRIMERA PARTE (directamente capitulo primero despues)
    return NULL;
}

Division *divisionGrammarAction(DivisionInfo *division, Body * body, Article * article, Division * next_division)
{
    Division *new_division = (Division *)malloc(sizeof(Division));
    new_division->division = division;
    new_division->body = body;
    new_division->article = article;
    new_division->next_division = next_division;

    return new_division;
}

int subarticleCount = 0;
Article *articleGrammarAction(ArticleInfo *article, Body *body, Subarticle *subarticle, Article * next_article)
{
    assert(article != NULL);

    // Body *bodyIter = body;
    // while (bodyIter != NULL) {
    //         printf("%s ", bodyIter->scentence);
    //         bodyIter = bodyIter->next_body;
    //     }
        
    // Subarticle *subarticleIter = subarticle;
    // if (subarticleIter != NULL) printf("A SUBARTICLE: ");
    // while (subarticleIter != NULL) {
    //     subarticleCount += 1;
    //     // printf("%i\n", subarticleCount);
    //     printf("%i, %s\n", subarticleIter->subarticle->ordinal, subarticleIter->subarticle->body);
    //     subarticleIter = subarticleIter->next_subarticle;
    // }

    // printf("ARTICLE(text=\"%s\")\n", division);

    assert(article != NULL);

    Article *new_article = (Article *)malloc(sizeof(Article));
    new_article->article = article;
    new_article->body = body;
    new_article->first_subarticle = subarticle;
    new_article->next_article = next_article;

    return new_article;
}

Subarticle *subarticleGrammarAction(ArticleInfo *subarticle, Body *body, Subarticle *next_subarticle)
{
    assert(subarticle != NULL);

    Subarticle *new_subarticle = (Subarticle *)malloc(sizeof(Subarticle));
    new_subarticle->subarticle = subarticle;
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