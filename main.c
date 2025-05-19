
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "grammar_actions.h"
#include "./utils/json_utils.h"
#include "shared.h"

int yyparse(void);

// Provide a dummy error handler
void yyerror(const char *s)
{
    fprintf(stderr, "Parse error at line %d: %s (token: \'%s\')\n", yylineno, s, yytext);
}

CompilerState state;

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
