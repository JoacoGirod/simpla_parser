#ifndef ABSTRACT_SYNTAX_TREE_HEADER
#define ABSTRACT_SYNTAX_TREE_HEADER

#include "lexer_utils.h"

typedef struct Body Body;

struct Body {
	const char * scentence;
	Body * next_body;
};

typedef struct Subarticle Subarticle;

struct Subarticle {
	ArticleInfo * subarticle;
	Body * body;
    Subarticle * next_subarticle;
};

typedef struct Article Article;

struct Article {
	ArticleInfo * article;
	Body * body;
    Subarticle * first_subarticle;
	Article * next_article;
};

typedef struct Division Division;

struct Division {
	DivisionInfo * division;
	Body * body;
    Article * article;
	Division * next_division;
};
#endif
