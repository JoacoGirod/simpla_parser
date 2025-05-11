#include "json_utils.h"
#include <glib.h>
#include <errno.h>

void writeToFile(cJSON *json, const char *fileName)
{
    char *json_str = cJSON_Print(json);

    FILE *fp = fopen(fileName, "w");
    if (fp == NULL)
    {
        fprintf(stderr, "Error: Unable to open the file '%s'\n", fileName);
        perror("fopen");
        fprintf(stderr, "Hint: Make sure the output directory exists (e.g., use `mkdir -p`)\n");
        cJSON_free(json_str);
        cJSON_Delete(json);
        return;
    }

    fputs(json_str, fp);
    fclose(fp);

    cJSON_free(json_str);
    cJSON_Delete(json);
}

cJSON *initializeArray()
{
    return cJSON_CreateArray();
}

void appendBodyString(GString *str, Body *body)
{
    Body *bodyIter = body;
    while (bodyIter != NULL)
    {
        g_string_append(str, " ");
        g_string_append(str, bodyIter->scentence);
        bodyIter = bodyIter->next_body;
    }
}

void appendSubarticleString(GString *str, Subarticle *subarticle)
{
    Subarticle *subarticleIter = subarticle;
    while (subarticleIter != NULL)
    {
        g_string_append_printf(str, " %.0f. %s", subarticleIter->subarticle->ordinal, subarticleIter->subarticle->body);
        appendBodyString(str, subarticleIter->body);
        g_string_append(str, " -");
        subarticleIter = subarticleIter->next_subarticle;
    }
}

char *generateArticleText(Article *article)
{
    GString *str = g_string_new("");

    g_string_append(str, article->article->body);
    appendBodyString(str, article->body);
    appendSubarticleString(str, article->first_subarticle);

    return str->str;
}

cJSON *createArticle(Article *article)
{
    cJSON *articleJson = cJSON_CreateObject();

    cJSON_AddNumberToObject(articleJson, "article_number", article->article->ordinal);
    cJSON_AddStringToObject(articleJson, "text", generateArticleText(article));
    cJSON_AddStringToObject(articleJson, "date", "03-01-1995");
    cJSON_AddStringToObject(articleJson, "source", "https://servicios.infoleg.gob.ar/infolegInternet/anexos/0-4999/804/norma.htm");
    cJSON_AddStringToObject(articleJson, "chunk_type", "article");

    return articleJson;
}

void addArticleToArray(cJSON *articleArrayJson, Article *article)
{
    cJSON *articleJson = createArticle(article);
    cJSON_AddItemToArray(articleArrayJson, articleJson);
}
