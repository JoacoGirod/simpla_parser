%option noyywrap

%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

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

ORDINAL   [A-Za-zÁáÉéÍíÓóÚúÑñ]+
ART       [Aa][Rr][Tt][ÍíiI].?[Cc][Uu][Ll][Oo]
ART_NUM   [0-9]+
ART_SEP   [.:.-]+
SUBART    [0-9]+{OPT_WS}{ART_SEP}

/* ----------- Rules Section ----------- */
%%
^{OPT_WS}CAPITULO{WS}{ORDINAL}\.?{WS}.*                   {
    yylval.str = trim(yytext);
    return DIVISION;
}
^{OPT_WS}TITULO{WS}{ORDINAL}{WS}.*                        {
    yylval.str = trim(yytext);
    return DIVISION;
}
^{OPT_WS}SECCION{WS}{ORDINAL}{WS}.*                       {
    yylval.str = trim(yytext);
    return DIVISION;
}
^{OPT_WS}PRIMERA{WS}PARTE{WS}.*                           {
    yylval.str = trim(yytext);
    return DIVISION;
}
^{OPT_WS}SEGUNDA{WS}PARTE{WS}.*                           {
    yylval.str = trim(yytext);
    return DIVISION;
}
^{OPT_WS}DISPOSICIONES{WS}TRANSITORIAS{OPT_WS}$           {
    yylval.str = trim(yytext);
    return DIVISION;
}
^{OPT_WS}FIRMANTES{OPT_WS}$                               {
    yylval.str = trim(yytext);
    return DIVISION;
}
^{OPT_WS}{ART}{WS}{ART_NUM}{OPT_WS}{ART_SEP}{WS}.*            {
    yylval.str = trim(yytext);
    return ARTICLE;
}
^{OPT_WS}{SUBART}{WS}.*                                   {
    yylval.str = trim(yytext);
    return SUBARTICLE;
}
.*                                                        {
    yylval.str = trim(yytext);
    return BODY;
}
%%