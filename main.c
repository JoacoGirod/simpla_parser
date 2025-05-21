
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "grammar_actions.h"
#include "./utils/json_utils.h"
#include "./utils/print_utils.h"
#include "shared.h"

int yyparse(void);

CompilerState state;

// Provide a dummy error handler
void yyerror(const char *s)
{
    fprintf(stderr, "Parse error at line %d: %s (token: \'%s\')\n", yylineno, s, yytext);
    printf("Assembled struct: \n");
    printFromDivision(state.current_division);
}

void writeConstitution(Division *division, const char *output_path)
{
    cJSON *articleArrayJson = initializeArray();

    Division *divisionIter = division;
    while (divisionIter != NULL)
    {
        Article *articleIter = divisionIter->article;
        while (articleIter != NULL)
        {
            addArticleToArray(articleArrayJson, articleIter, output_path);
            articleIter = articleIter->next_article;
        }
        divisionIter = divisionIter->next_division;
    }

    writeToFile(articleArrayJson, output_path);
}

void freeConstitution(Division *division)
{
    // Sospecho que nos puede traer problemas no liberar antes de armar la proxima
}

char* extract_province_name(const char* filename) {
    const char* de_pos = NULL;
    const char* search = filename;

    // Find the last "De_" occurrence
    while ((search = strstr(search, "De_")) != NULL) {
        de_pos = search;
        search += 3;
    }

    if (!de_pos) return NULL;

    de_pos += 3;  // Move past "De_"
    const char* end = strstr(de_pos, ".txt");
    if (!end) return NULL;

    size_t len = end - de_pos;
    char* raw = malloc(len + 1);
    if (!raw) return NULL;

    strncpy(raw, de_pos, len);
    raw[len] = '\0';

    // Convert underscores to spaces and lowercase first letter
    for (size_t i = 0; i < len; i++) {
        if (raw[i] == '_') {
            raw[i] = ' ';
        }
    }

    return raw;
}

int main(int argc, char **argv)
{
    if (argc != 3)
    {
        fprintf(stderr, "Usage: %s <input_file> <output_file>\n", argv[0]);
        return 1;
    }

    const char *input_path = argv[1];
    const char *output_path = argv[2];

    FILE *input_file = fopen(input_path, "r");
    if (!input_file)
    {
        perror("Error opening input file");
        return 1;
    }

    // Set yyin so the parser reads from the file
    extern FILE *yyin;
    yyin = input_file;

    // Run the parser
    yyparse();

    // Write and clean up
    writeConstitution(state.first_division, output_path);
    freeConstitution(state.first_division);

    fclose(input_file);
    return 0;
}
