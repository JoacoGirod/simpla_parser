#include "print_utils.h"

void printArticles(Article * article) {
    Article * articleIter = article;

    while (articleIter != NULL) {
        printf("\tA - %.1f\n", articleIter->article->ordinal);
        articleIter = articleIter->next_article;
    }
}


void printFromDivision(Division * division) {
    Division * divisionIter = division;

    if (divisionIter == NULL) {
        printf("Empty division\n");
    }

    while (divisionIter != NULL) {
        printf("D%i: %s\n", divisionIter->division->ordinal, divisionIter->division->type);
        printArticles(divisionIter->article);
        divisionIter = divisionIter->next_division;
    }
}
