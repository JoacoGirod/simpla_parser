#include "lexer_utils.h"

// Normalization mappings
const TypeMapping type_mappings[] = {
    {"cap", "CAPITULO"},
    {"tit", "TITULO"},
    {"sec", "SECCION"},
    {"parte", "PARTE"},
    {"disposiciones", "DISPOSICIONES_TRANSITORIAS"},
};
const size_t type_mappings_count = sizeof(type_mappings) / sizeof(type_mappings[0]);

// Ordinal mappings
const OrdinalMapping ordinal_mappings[] = {
    {"primero", 1},
    {"primera", 1},
    {"segundo", 2},
    {"segunda", 2},
    {"tercero", 3},
    {"tercera", 3},
    {"cuarto", 4},
    {"cuarta", 4},
    {"quinto", 5},
    {"quinta", 5},
    {"sexto", 6},
    {"sexta", 6},
    {"séptimo", 7},
    {"séptima", 7},
    {"octavo", 8},
    {"octava", 8},
    {"noveno", 9},
    {"novena", 9},
    {"décimo", 10},
    {"décima", 10},
    {"undécimo", 11},
    {"undécima", 11},
    {"duodécimo", 12},
    {"duodécima", 12},
    {"decimotercero", 13},
    {"decimotercera", 13},
    {"decimocuarto", 14},
    {"decimocuarta", 14},
    {"decimoquinto", 15},
    {"decimoquinta", 15},
    {"decimosexto", 16},
    {"decimosexta", 16},
    {"decimoséptimo", 17},
    {"decimoséptima", 17},
};
const size_t ordinal_mappings_count = sizeof(ordinal_mappings) / sizeof(ordinal_mappings[0]);

// Takes a Type String and normalizes it, the matching is made
char *normalize_type(const char *type)
{
    printf("type : <%s>\n", type);

    if (!type)
        return strdup("UNKNOWN");

    // Lowercase the Type
    char lower[TYPE_BUFFER_SIZE];
    int i = 0;
    for (; type[i] && i < (TYPE_BUFFER_SIZE - 1); ++i)
        lower[i] = tolower((unsigned char)type[i]);
    lower[i] = '\0';

    // Return correct mapping
    for (size_t j = 0; j < type_mappings_count; ++j)
        if (strstr(lower, type_mappings[j].keyword))
            return strdup(type_mappings[j].normalized);

    return strdup("UNKNOWN");
}

// Takes an Ordinal String and returns its numerical Ordinal
int ordinal_word_to_int(const char *word)
{
    if (!word)
        return 0;

    // Lowercase the Type
    char lower[ORDINAL_BUFFER_SIZE];
    int i = 0;
    for (; word[i] && i < (ORDINAL_BUFFER_SIZE - 1); ++i)
        lower[i] = tolower((unsigned char)word[i]);
    lower[i] = '\0';

    // Return correct mapping
    for (size_t j = 0; j < ordinal_mappings_count; ++j)
        if (strcmp(lower, ordinal_mappings[j].word) == 0)
            return ordinal_mappings[j].value;

    return 0;
}

// Duplicate section of a String
char *strdup_range(const char *start, const char *end)
{
    int len = end - start;
    char *out = malloc(len + 1);
    strncpy(out, start, len);
    out[len] = '\0';
    return out;
}

// Remove prefixing and suffixing whitespace
char *trim(const char *str)
{
    const char *end;
    while (isspace((unsigned char)*str))
        str++;
    if (*str == 0)
        return strdup("");

    end = str + strlen(str) - 1;
    while (end > str && isspace((unsigned char)*end))
        end--;

    int len = end - str + 1;
    char *out = (char *)malloc(len + 1);
    strncpy(out, str, len);
    out[len] = '\0';
    return out;
}
