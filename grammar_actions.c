#include "grammar_actions.h"
#include "./utils/json_utils.h"
#include <assert.h>


void * programGrammarAction(Division *division) {
    cJSON * articleArrayJson = initializeArray();
    
    Division *divisionIter = division;
    while (divisionIter != NULL) {
        Article *articleIter = divisionIter->article;
        while (articleIter != NULL) {            
            cJSON * articleJson = createArticle(articleIter);
            cJSON_AddItemToArray(articleArrayJson, articleJson);
            articleIter = articleIter->next_article;
        }
        divisionIter = divisionIter->next_division;
    }

    writeToFile(articleArrayJson, "constitucion-out.json");

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