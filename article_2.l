%{
#include <stdio.h>
#include <stdlib.h>

int article_number;
int item_number;
%}

%option noyywrap

%x ARTICLE_BODY

%%

<INITIAL,ARTICLE_BODY>Artículo[ \t]+([0-9]+)\.[ \t]*(.*) {
    sscanf(yytext, "Artículo %d.", &article_number);
    printf("[ARTICLE_HEADER] number=%d, text=<%s>\n", article_number, yytext);
    BEGIN(ARTICLE_BODY);
    item_number = 1;
}

<ARTICLE_BODY>[0-9]+\.[ \t]+[^\n]+ {
    int parsed_number;
    sscanf(yytext, "%d.", &parsed_number);
    printf("[ARTICLE_ITEM] number=%d, text=<%s>\n", parsed_number, yytext);
}

<ARTICLE_BODY>[^\n]+ {
    printf("[BODY_TEXT] text=<%s>\n", yytext);
}

\n    ;

.     ;

%%

int main(void) {
    yylex();
    return 0;
}
