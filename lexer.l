%option noyywrap
%option caseless

%{
#include "parser.tab.h"
#include "lexer_utils.h"
%}

/* ----------- Regex Macros ----------- */
WS        [ \t]+
OPT_WS    [ \t]*
endline   [\n]

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
"PREÁMBULO" {
    return PREAMBULO;
}

^{OPT_WS}{ORDINAL_WRD}{WS}{DIV}{OPT_WS}(.*) {

    char ordinal[ORDINAL_BUFFER_SIZE] = {0};
    char type[TYPE_BUFFER_SIZE] = {0};
    char body[BODY_BUFFER_SIZE] = {0};
    sscanf(yytext, "%63s %63s %[^\n]", ordinal, type, body);

    DivisionInfo* div = malloc(sizeof(DivisionInfo));
    div->original_ordinal_text = strdup(ordinal);
    div->original_type_text = strdup(type);
    div->ordinal = ordinal_word_to_int(ordinal);
    div->type = normalize_type(type);
    div->body = strdup(body);

    yylval.div = div;
    return DIVISION;
}

^{OPT_WS}{DIV}{WS}{ORDINAL_WRD}(.*) {

    char type[64] = {0};
    char ordinal[64] = {0};
    char body[1024] = {0};
    sscanf(yytext, "%63s %63s %[^\n]", type, ordinal, body);

    DivisionInfo* div = malloc(sizeof(DivisionInfo));
    div->original_ordinal_text = strdup(ordinal);
    div->original_type_text = strdup(type);
    div->ordinal = ordinal_word_to_int(ordinal);
    div->type = normalize_type(type);
    div->body = strdup(body);

    yylval.div = div;
    return DIVISION;
}

^{OPT_WS}{DIV}{OPT_WS}(.*) {

    char type[64] = {0};
    char body[1024] = {0};
    sscanf(yytext, "%63s %[^\n]", type, body);

    DivisionInfo* div = malloc(sizeof(DivisionInfo));
    div->original_ordinal_text = strdup("");
    div->original_type_text = strdup(type);
    div->ordinal = 0;
    div->type = normalize_type(type);
    div->body = strdup(body);

    yylval.div = div;
    return DIVISION;
}

^{OPT_WS}{ART}{WS}([º0-9]+){OPT_WS}(bis)?{OPT_WS}{ART_SEP}{OPT_WS}(.*) {

    char ordinal_buf[64] = {0};
    sscanf(yytext, "%*[^0-9]%15[º0-9]", ordinal_buf);

    const char* ordinal_start = yytext;
    const char* bis_ptr = strstr(yytext, "bis"); // This may produce a false positive
    float ordinal = atof(ordinal_buf);
    if (bis_ptr)
        ordinal += 0.5f;

    ArticleInfo* art = malloc(sizeof(ArticleInfo));
    if (bis_ptr) {
        art->original_ordinal_text = strdup_range(ordinal_start, bis_ptr + 3);  // include "bis"
    } else {
        // Up to first space or separator
        const char* end = ordinal_start + strcspn(ordinal_start, " .:-");
        art->original_ordinal_text = strdup_range(ordinal_start, end);
    }

    // Find the start of the article body (after the separator)
    const char* body_start = strchr(yytext, '.');
    if (!body_start) body_start = strchr(yytext, '-');
    if (!body_start) body_start = strchr(yytext, ':');
    if (body_start) body_start++;
    while (*body_start && !isalpha((unsigned char)*body_start)) body_start++;

    art->ordinal = ordinal;
    art->body = strdup(body_start);
    yylval.article = art;

    return ARTICLE;
}

^{OPT_WS}([0-9]+){OPT_WS}{ART_SEP}{WS}(.*) {

    char ordinal_buf[64];
    sscanf(yytext, "%63[0-9]", ordinal_buf);


    ArticleInfo* sub = malloc(sizeof(ArticleInfo));
    sub->ordinal = atof(ordinal_buf);
    sub->original_ordinal_text = strdup(ordinal_buf);

    // Skip separator
    const char* body_start = strchr(yytext, '.');
    if (!body_start) body_start = strchr(yytext, '-');
    if (body_start) body_start++;
    while (*body_start && isspace((unsigned char)*body_start)) body_start++;

    sub->body = strdup(body_start);

    yylval.article = sub;
    return SUBARTICLE;
}

^{ORDINAL_WRD}\.[ \t]*(.*)? {

    char ordinal_buf[64] = {0};
    char body[1024] = {0};
    sscanf(yytext, "%63[^.]. %[^\n]", ordinal_buf, body);

    ArticleInfo* art = malloc(sizeof(ArticleInfo));
    art->original_ordinal_text = strdup(trim(ordinal_buf));
    art->ordinal = ordinal_word_to_int(ordinal_buf);
    art->body = strdup(trim(body));

    yylval.article = art;
    return ARTICLE;
}

{endline} {
    // ignore
}

.*                                                        {
    yylval.str = trim(yytext);
    return BODY;
}
%%