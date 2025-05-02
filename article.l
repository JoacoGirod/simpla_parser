%{
#include <stdio.h>
#include <string.h>

#define MAX_LINE_LEN 1024
%}

%option noyywrap

%x ARTICLE_BODY

%%

^Artículo[ \t]+[0-9]+\.-[^\n]* {
    // Copy line into buffer
    char line[MAX_LINE_LEN];
    strncpy(line, yytext, MAX_LINE_LEN);

    // Extract article header up to first period
    char *dot = strstr(line, ".-");
    if (dot) {
        dot += 2; // Move past ".-"
        *dot = '\0'; // Terminate header
        printf("ARTICLE <%s>\n", line);

        // Body comes after header
        char *body = dot + 1;
        if (*body != '\0') {
            printf("BODY <%s>\n", body);
        }
    }

    BEGIN(ARTICLE_BODY);
}

<ARTICLE_BODY>^Artículo[ \t]+[0-9]+\.-[^\n]* {
    // Repeat same logic for new articles inside ARTICLE_BODY
    char line[MAX_LINE_LEN];
    strncpy(line, yytext, MAX_LINE_LEN);

    char *dot = strstr(line, ".-");
    if (dot) {
        dot += 2;
        *dot = '\0';
        printf("ARTICLE <%s>\n", line);

        char *body = dot + 1;
        if (*body != '\0') {
            printf("BODY <%s>\n", body);
        }
    }
}

<ARTICLE_BODY>^[^\n]+ {
    printf("  body: <%s>\n", yytext);
}

<ARTICLE_BODY>^\n {
    // Blank line: skip or use as separator
}

.|\n ; // Catch-all

%%

int main(void) {
    yylex();
    return 0;
}
