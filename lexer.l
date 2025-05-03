%option noyywrap
%option caseless

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

A (Á|á|A|a)
E (É|é|E|e)
I (Í|í|I|i)
O (Ó|ó|O|o)
U (Ú|ú|U|u)

LTR       [A-Za-zÁáÉéÍíÓóÚúÑñ]
WRD       [A-Za-zÁáÉéÍíÓóÚúÑñ]{2,}

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
^{OPT_WS}{DIV}{WS}{WRD}.*                      {
    yylval.str = trim(yytext);
    return DIVISION;
}

^{OPT_WS}{WRD}{WS}{PAR}.*                           {
    yylval.str = trim(yytext);
    return DIVISION;
}

^{OPT_WS}{DIV}{OPT_WS}$           {
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

^{WRD}\..*                                          {
    yylval.str = trim(yytext);
    return ARTICLE;
}

.*                                                        {
    yylval.str = trim(yytext);
    return BODY;
}
%%