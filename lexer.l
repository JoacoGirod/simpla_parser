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
ART       [Aa][Rr][Tt][ÍíiI][Cc][Uu][Ll][Oo]
ART_NUM   [0-9]+
ART_SEP   [.:.-]+
SUBART    [0-9]+{OPT_WS}{ART_SEP}

/* ----------- Rules Section ----------- */
%%
^{OPT_WS}CAPITULO{WS}{ORDINAL}\.?{WS}.*                   {
    yylval.str = trim(yytext);
    printf("LEXER: DIVISION(text=\"%s\")\n", yylval.str);  // Print token
    return DIVISION;
}
^{OPT_WS}TITULO{WS}{ORDINAL}{WS}.*                        {
    yylval.str = trim(yytext);
    printf("LEXER: DIVISION(text=\"%s\")\n", yylval.str);
    return DIVISION;
}
^{OPT_WS}SECCION{WS}{ORDINAL}{WS}.*                       {
    yylval.str = trim(yytext);
    printf("LEXER: DIVISION(text=\"%s\")\n", yylval.str);
    return DIVISION;
}
^{OPT_WS}PRIMERA{WS}PARTE{WS}.*                           {
    yylval.str = trim(yytext);
    printf("LEXER: DIVISION(text=\"%s\")\n", yylval.str);
    return DIVISION;
}
^{OPT_WS}SEGUNDA{WS}PARTE{WS}.*                           {
    yylval.str = trim(yytext);
    printf("LEXER: DIVISION(text=\"%s\")\n", yylval.str);
    return DIVISION;
}
^{OPT_WS}DISPOSICIONES{WS}TRANSITORIAS{OPT_WS}$           {
    yylval.str = trim(yytext);
    printf("LEXER: DIVISION(text=\"%s\")\n", yylval.str);
    return DIVISION;
}
^{OPT_WS}FIRMANTES{OPT_WS}$                               {
    yylval.str = trim(yytext);
    printf("LEXER: DIVISION(text=\"%s\")\n", yylval.str);
    return DIVISION;
}
^{OPT_WS}{ART}{WS}{ART_NUM}{OPT_WS}{ART_SEP}{WS}.*            {
    yylval.str = trim(yytext);
    printf("LEXER: ARTICLE(text=\"%s\")\n", yylval.str);
    return ARTICLE;
}
^{OPT_WS}{SUBART}{WS}.*                                   {
    yylval.str = trim(yytext);
    printf("LEXER: SUBARTICLE(text=\"%s\")\n", yylval.str);
    return SUBARTICLE;
}
.*                                                        {
    yylval.str = trim(yytext);
    printf("LEXER: BODY(text=\"%s\")\n", yylval.str);
    return BODY;
}
%%