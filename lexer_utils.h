#ifndef LEXER_UTILS_H
#define LEXER_UTILS_H

#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#define BODY_BUFFER_SIZE 4400
#define TYPE_BUFFER_SIZE 64
#define ORDINAL_BUFFER_SIZE 64

typedef struct
{
    const char *keyword;
    const char *normalized;
} TypeMapping;

typedef struct
{
    const char *word;
    int value;
} OrdinalMapping;

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

// Declarations for external data
extern const TypeMapping type_mappings[];
extern const size_t type_mappings_count;

extern const OrdinalMapping ordinal_mappings[];
extern const size_t ordinal_mappings_count;

// Function declarations
char *normalize_type(const char *type);
int ordinal_word_to_int(const char *word);
char *strdup_range(const char *start, const char *end);
char *trim(const char *str);

#endif // LEXER_UTILS_H
