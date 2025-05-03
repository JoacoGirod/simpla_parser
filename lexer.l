%option noyywrap
%option caseless

%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

typedef struct {
    char* type;
    int ordinal;
    char* original_type_text;
    char* original_ordinal_text;
    char* body;
} DivisionInfo;

typedef struct {
    float ordinal;
    char* original_ordinal_text;
    char* body;
} ArticleInfo;

char* normalize_type(const char* type) {
    if (!type) return strdup("UNKNOWN");

    char lower[64];
    int i = 0;
    for (; type[i] && i < 63; ++i)
        lower[i] = tolower((unsigned char)type[i]);
    lower[i] = '\0';

    if (strstr(lower, "cap")) return strdup("CAPITULO");
    if (strstr(lower, "tit")) return strdup("TITULO");
    if (strstr(lower, "sec")) return strdup("SECCION");
    if (strstr(lower, "parte")) return strdup("PARTE");
    if (strstr(lower, "disposiciones")) return strdup("DISPOSICIONES_TRANSITORIAS");

    return strdup("UNKNOWN");
}


int ordinal_word_to_int(const char* word) {
    if (!word) return 0;
    // Normalize case
    char lower[32];
    int i = 0;
    for (; word[i] && i < 31; ++i)
        lower[i] = tolower((unsigned char)word[i]);
    lower[i] = '\0';

    if (strcmp(lower, "primero") == 0 || strcmp(lower, "primera") == 0) return 1;
    if (strcmp(lower, "segundo") == 0 || strcmp(lower, "segunda") == 0) return 2;
    if (strcmp(lower, "tercero") == 0 || strcmp(lower, "tercera") == 0) return 3;
    if (strcmp(lower, "cuarto") == 0 || strcmp(lower, "cuarta") == 0) return 4;
    if (strcmp(lower, "quinto") == 0 || strcmp(lower, "quinta") == 0) return 5;
    if (strcmp(lower, "sexto") == 0 || strcmp(lower, "sexta") == 0) return 6;
    if (strcmp(lower, "séptimo") == 0 || strcmp(lower, "séptima") == 0) return 7;
    if (strcmp(lower, "octavo") == 0 || strcmp(lower, "octava") == 0) return 8;
    if (strcmp(lower, "noveno") == 0 || strcmp(lower, "novena") == 0) return 9;
    if (strcmp(lower, "décimo") == 0 || strcmp(lower, "décima") == 0) return 10;
    if (strcmp(lower, "undécimo") == 0 || strcmp(lower, "undécima") == 0) return 11;
    if (strcmp(lower, "duodécimo") == 0 || strcmp(lower, "duodécima") == 0) return 12;
    if (strcmp(lower, "decimotercero") == 0 || strcmp(lower, "decimotercera") == 0) return 13;
    if (strcmp(lower, "decimocuarto") == 0 || strcmp(lower, "decimocuarta") == 0) return 14;
    if (strcmp(lower, "decimoquinto") == 0 || strcmp(lower, "decimoquinta") == 0) return 15;
    if (strcmp(lower, "decimosexto") == 0 || strcmp(lower, "decimosexta") == 0) return 16;
    if (strcmp(lower, "decimoséptimo") == 0 || strcmp(lower, "decimoséptima") == 0) return 17;
    return 0;
}

char* strdup_range(const char* start, const char* end) {
    int len = end - start;
    char* out = malloc(len + 1);
    strncpy(out, start, len);
    out[len] = '\0';
    return out;
}

char* trim(const char* str) {
    const char* end;
    while (isspace((unsigned char)*str)) str++;
    if (*str == 0) return strdup("");

    end = str + strlen(str) - 1;
    while (end > str && isspace((unsigned char)*end)) end--;

    int len = end - str + 1;
    char* out = (char*)malloc(len + 1);
    strncpy(out, str, len);
    out[len] = '\0';
    return out;
}
%}

/* ----------- Regex Macros ----------- */
WS        [ \t]+
OPT_WS    [ \t]*

A (Á|á|A|a)
E (É|é|E|e)
I (Í|í|I|i)
O (Ó|ó|O|o)
U (Ú|ú|U|u)

LTR       [A-Za-zÁáÉéÍíÓóÚúÑñ]
WRD       [A-Za-zÁáÉéÍíÓóÚúÑñ]{2,}
ORDINAL_WRD primera|primero|segunda|segundo|tercera|tercero|cuarta|cuarto|quinta|quinto|sexta|sexto|s{E}ptima|s{E}ptimo|octava|octavo|novena|noveno|d{E}cima|d{E}cimo|und{E}cima|und{E}cimo|duod{E}cima|duod{E}cimo|decimotercera|decimotercero|decimocuarta|decimocuarto|decimoquinta|decimoquinto|decimosexta|decimosexto|decimos{E}ptima|decimos{E}ptimo


CAP       cap{I}tulo
TIT       t{I}tulo
SEC       secci{O}n
PAR       parte
DT        disposiciones{WS}transitorias

DIV       {CAP}|{TIT}|{SEC}|{PAR}|{DT}

ART       art{I}culo
ART_NUM   [º0-9]+
ART_SEP   [.:.-]+
SUBART    [0-9]+{OPT_WS}{ART_SEP}

/* ----------- Rules Section ----------- */
%%
^{OPT_WS}{ORDINAL_WRD}{WS}{DIV}{OPT_WS}(.*) {
    // printf("Matched ORDINAL DIVISION\n");

    DivisionInfo* div = malloc(sizeof(DivisionInfo));

    char ordinal[64] = {0};
    char type[64] = {0};
    char body[1024] = {0};

    // Extract fields from the matched line
    sscanf(yytext, "%63s %63s %[^\n]", ordinal, type, body);

    // printf("ordinal : <%s>\n", ordinal);
    // printf("type : <%s>\n", type);
    // printf("body : <%s>\n", body);

    div->original_ordinal_text = strdup(ordinal);
    div->original_type_text = strdup(type);
    div->ordinal = ordinal_word_to_int(ordinal);
    div->type = normalize_type(type);
    div->body = strdup(body);
    yylval.div = div;
    return DIVISION;
}

^{OPT_WS}{DIV}{WS}{ORDINAL_WRD}(.*) {
    // printf("Matched DIVISION ORDINAL\n");

    DivisionInfo* div = malloc(sizeof(DivisionInfo));

    char type[64] = {0};
    char ordinal[64] = {0};
    char body[1024] = {0};

    sscanf(yytext, "%63s %63s %[^\n]", type, ordinal, body);

    // printf("ordinal : <%s>\n", ordinal);
    // printf("type : <%s>\n", type);
    // printf("body : <%s>\n", body);

    div->original_ordinal_text = strdup(ordinal);
    div->original_type_text = strdup(type);
    div->ordinal = ordinal_word_to_int(ordinal);
    div->type = normalize_type(type);
    div->body = strdup(body);
    yylval.div = div;
    return DIVISION;
}

^{OPT_WS}{DIV}{OPT_WS}(.*) {
    // printf("Matched DIVISION\n");
    DivisionInfo* div = malloc(sizeof(DivisionInfo));

    char type[64] = {0};
    char body[1024] = {0};
    sscanf(yytext, "%63s %[^\n]", type, body);

    // printf("type : <%s>\n", type);
    // printf("body : <%s>\n", body);

    div->original_ordinal_text = strdup("");
    div->original_type_text = strdup(type);
    div->ordinal = 0;
    div->type = normalize_type(type);
    div->body = strdup(body);
    yylval.div = div;
    return DIVISION;
}

^{OPT_WS}{ART}{WS}([º0-9]+){OPT_WS}(bis)?{OPT_WS}{ART_SEP}{OPT_WS}(.*) {
    // printf("Matched ARTICLE\n");

    ArticleInfo* art = malloc(sizeof(ArticleInfo));

    char ordinal_buf[64] = {0};
    char* bis_ptr = NULL;
    sscanf(yytext, "%*[^0-9]%15[º0-9]", ordinal_buf);

    // printf("ordinal_buf : <%s>\n", ordinal_buf);

    bis_ptr = strstr(yytext, "bis");

    float ordinal = atof(ordinal_buf);
    if (bis_ptr) {
        ordinal += 0.5f;
    }

    art->ordinal = ordinal;
    art->original_ordinal_text = bis_ptr
        ? strdup_range(ordinal_buf, bis_ptr + 3) // include "bis"
        : strdup(ordinal_buf);

    // Skip to the first alphabetic character after the separator
    const char* body_start = strchr(yytext, '.');
    if (!body_start) body_start = strchr(yytext, '-');
    if (!body_start) body_start = strchr(yytext, ':');
    if (body_start) body_start++;
    while (*body_start && !isalpha((unsigned char)*body_start)) body_start++;

    art->body = strdup(body_start);
    yylval.article = art;
    return ARTICLE;
}


^{OPT_WS}([0-9]+){OPT_WS}{ART_SEP}{WS}(.*) {
    // printf("Matched SUBARTICLE\n");

    ArticleInfo* sub = malloc(sizeof(ArticleInfo));
    char ordinal_buf[64];

    sscanf(yytext, "%63[0-9]", ordinal_buf);

    // printf("ordinal_buf : <%s>\n", ordinal_buf);

    sub->ordinal = atof(ordinal_buf);
    sub->original_ordinal_text = strdup(ordinal_buf);

    const char* body_start = strchr(yytext, '.');
    if (!body_start) body_start = strchr(yytext, '-');
    if (body_start) body_start++;
    while (*body_start && isspace((unsigned char)*body_start)) body_start++;

    sub->body = strdup(body_start);
    yylval.article = sub;
    return SUBARTICLE;
}

^{ORDINAL_WRD}\.[ \t]*(.*)? {
    // printf("Matched ORDINAL\n");

    ArticleInfo* art = malloc(sizeof(ArticleInfo));
    char ordinal_buf[64] = {0};
    char body[1024] = {0};

    sscanf(yytext, "%63[^.]. %[^\n]", ordinal_buf, body);

    art->original_ordinal_text = strdup(trim(ordinal_buf));
    art->ordinal = ordinal_word_to_int(ordinal_buf); // Implement this function if not already
    art->body = strdup(trim(body));

    yylval.article = art;
    return ARTICLE;
}

.*                                                        {
    yylval.str = trim(yytext);
    return BODY;
}
%%