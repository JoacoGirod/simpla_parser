
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
    
#include "grammar_actions.h"
#include "./utils/json_utils.h"
#include "shared.h"    

int yyparse(void);
    
// Provide a dummy error handler
void yyerror(const char* s) {
    fprintf(stderr, "Parse error: %s\n", s);
}
    
CompilerState state;

void writeConstitution(Division * division, const char * output_path) {
    cJSON * articleArrayJson = initializeArray();
    
    Division *divisionIter = division;
    while (divisionIter != NULL) {
        Article *articleIter = divisionIter->article;
        while (articleIter != NULL) {        
            addArticleToArray(articleArrayJson, articleIter);
            articleIter = articleIter->next_article;
        }
        divisionIter = divisionIter->next_division;
    }

    writeToFile(articleArrayJson, output_path);
}

void freeConstitution(Division * division) {
    // Sospecho que nos puede traer problemas no liberar antes de armar la proxima
} 

int main() {
    yyparse();

    writeConstitution(state.first_division, "constitucion-out.json");
    freeConstitution(state.first_division);

    return 1;
}