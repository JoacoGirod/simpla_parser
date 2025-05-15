#ifndef JSON_UTLIS_H
#define JSON_UTLIS_H

#include <stdio.h> 
#include <cjson/cJSON.h> 
#include "../abstract_syntax_tree.h"

void writeToFile(cJSON * json, const char * fileName);
cJSON * initializeArray();


void addArticleToArray(cJSON * articleArrayJson, Article * article);
void addArticleAndSubarticlesToArray(cJSON *articleArrayJson, Article *article);
// cJSON * createArticle(Article * article); // - now local

#endif