#ifndef ABSTRACT_SYNTAX_TREE_HEADER
#define ABSTRACT_SYNTAX_TREE_HEADER

typedef struct Body Body;

struct Body {
	const char * scentence;
	Body * next_body;
};

typedef struct Subarticle Subarticle;

struct Subarticle {
	const char * scentence;
	Body * body;
    Subarticle * next_subarticle;
};

#endif
