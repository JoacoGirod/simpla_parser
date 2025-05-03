#include "lexer_utils.h"

char *normalize_type(const char *type)
{
    if (!type)
        return strdup("UNKNOWN");

    char lower[64];
    int i = 0;
    for (; type[i] && i < 63; ++i)
        lower[i] = tolower((unsigned char)type[i]);
    lower[i] = '\0';

    if (strstr(lower, "cap"))
        return strdup("CAPITULO");
    if (strstr(lower, "tit"))
        return strdup("TITULO");
    if (strstr(lower, "sec"))
        return strdup("SECCION");
    if (strstr(lower, "parte"))
        return strdup("PARTE");
    if (strstr(lower, "disposiciones"))
        return strdup("DISPOSICIONES_TRANSITORIAS");

    return strdup("UNKNOWN");
}

int ordinal_word_to_int(const char *word)
{
    if (!word)
        return 0;
    char lower[32];
    int i = 0;
    for (; word[i] && i < 31; ++i)
        lower[i] = tolower((unsigned char)word[i]);
    lower[i] = '\0';

    if (strcmp(lower, "primero") == 0 || strcmp(lower, "primera") == 0)
        return 1;
    if (strcmp(lower, "segundo") == 0 || strcmp(lower, "segunda") == 0)
        return 2;
    if (strcmp(lower, "tercero") == 0 || strcmp(lower, "tercera") == 0)
        return 3;
    if (strcmp(lower, "cuarto") == 0 || strcmp(lower, "cuarta") == 0)
        return 4;
    if (strcmp(lower, "quinto") == 0 || strcmp(lower, "quinta") == 0)
        return 5;
    if (strcmp(lower, "sexto") == 0 || strcmp(lower, "sexta") == 0)
        return 6;
    if (strcmp(lower, "séptimo") == 0 || strcmp(lower, "séptima") == 0)
        return 7;
    if (strcmp(lower, "octavo") == 0 || strcmp(lower, "octava") == 0)
        return 8;
    if (strcmp(lower, "noveno") == 0 || strcmp(lower, "novena") == 0)
        return 9;
    if (strcmp(lower, "décimo") == 0 || strcmp(lower, "décima") == 0)
        return 10;
    if (strcmp(lower, "undécimo") == 0 || strcmp(lower, "undécima") == 0)
        return 11;
    if (strcmp(lower, "duodécimo") == 0 || strcmp(lower, "duodécima") == 0)
        return 12;
    if (strcmp(lower, "decimotercero") == 0 || strcmp(lower, "decimotercera") == 0)
        return 13;
    if (strcmp(lower, "decimocuarto") == 0 || strcmp(lower, "decimocuarta") == 0)
        return 14;
    if (strcmp(lower, "decimoquinto") == 0 || strcmp(lower, "decimoquinta") == 0)
        return 15;
    if (strcmp(lower, "decimosexto") == 0 || strcmp(lower, "decimosexta") == 0)
        return 16;
    if (strcmp(lower, "decimoséptimo") == 0 || strcmp(lower, "decimoséptima") == 0)
        return 17;
    return 0;
}

char *strdup_range(const char *start, const char *end)
{
    int len = end - start;
    char *out = malloc(len + 1);
    strncpy(out, start, len);
    out[len] = '\0';
    return out;
}

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
