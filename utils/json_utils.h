#ifndef JSON_UTLIS_H
#define JSON_UTLIS_H

#include <stdio.h> 
#include <cjson/cJSON.h> 
#include "../abstract_syntax_tree.h"

void writeToFile(cJSON * json, char * fileName);
cJSON * initializeArray();


cJSON * createArticle(Article * article);

#endif