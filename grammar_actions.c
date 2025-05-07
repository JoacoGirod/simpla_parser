#include "grammar_actions.h"
#include <assert.h>

void printBody(FILE *out, Body *body) {
    Body *bodyIter = body;
    while (bodyIter != NULL) {
        fprintf(out, "%s ", bodyIter->scentence);
        bodyIter = bodyIter->next_body;
    }
}

void printSubarticles(FILE *out, Subarticle *subarticle) {
    Subarticle *subarticleIter = subarticle;
    while (subarticleIter != NULL) {
        fprintf(out, "%.0f. %s ", subarticleIter->subarticle->ordinal, subarticleIter->subarticle->body);
        printBody(out, subarticleIter->body);
        fprintf(out, "- ");
        subarticleIter = subarticleIter->next_subarticle;
    }
}

void printArticle(FILE *out, Article *article) {
    fprintf(out, "{\n");
    fprintf(out, "\"article_number\": %.1f,\n", article->article->ordinal);
    fprintf(out, "\"text\": \"%s ", article->article->body);
    printBody(out, article->body);
    printSubarticles(out, article->first_subarticle);
    fprintf(out, "\",\n");
    fprintf(out, "\"date\": \"03-01-1995\",\n");
    fprintf(out, "\"source\": \"%s\",\n", "https://servicios.infoleg.gob.ar/infolegInternet/anexos/0-4999/804/norma.htm");
    fprintf(out, "\"chunk_type\": \"article\"\n");
    fprintf(out, "}");
}

void * programGrammarAction(Division *division) {
    const char * filename = "constitucion-out.json";
    FILE *out = fopen(filename, "w");
    if (!out) {
        perror("Error opening file");
        return NULL;
    }

    Division *divisionIter = division;
    fprintf(out, "[\n");
    int articleCount = 0;
    while (divisionIter != NULL) {
        Article *articleIter = divisionIter->article;
        while (articleIter != NULL) {
            if (articleCount++) {
                fprintf(out, ",\n");
            }
            
            printArticle(out, articleIter);
            // if (articleIter->article->ordinal == 1) { printArticle(out, articleIter); fclose(out); return NULL; }

            articleIter = articleIter->next_article;
        }
        divisionIter = divisionIter->next_division;
    }
    fprintf(out, "]\n");

    fclose(out);
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