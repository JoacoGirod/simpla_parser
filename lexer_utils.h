#ifndef LEXER_UTILS_H
#define LEXER_UTILS_H

#include <ctype.h>
#include <stdlib.h>
#include <string.h>

typedef struct
{
    char *type;
    int ordinal;
    char *original_type_text;
    char *original_ordinal_text;
    char *body;
} DivisionInfo;

typedef struct
{
    float ordinal;
    char *original_ordinal_text;
    char *body;
} ArticleInfo;

char *normalize_type(const char *type);
int ordinal_word_to_int(const char *word);
char *strdup_range(const char *start, const char *end);
char *trim(const char *str);

#endif // LEXER_UTILS_H
