LEXER = lexer.l
PARSER = parser.y
EXEC = parser

LEX_C = lex.yy.c
BISON_C = parser.tab.c
BISON_H = parser.tab.h

CC = gcc
CFLAGS = -Wall -g

PKG_CONFIG = pkg-config
GLIB_CFLAGS = $(shell $(PKG_CONFIG) --cflags glib-2.0)
GLIB_LIBS = $(shell $(PKG_CONFIG) --libs glib-2.0)

all: $(EXEC)

$(EXEC): $(BISON_C) $(LEX_C)
	$(CC) $(CFLAGS) $(GLIB_CFLAGS) -o $(EXEC) $(BISON_C) $(LEX_C) grammar_actions.c lexer_utils.c ./utils/json_utils.c -lfl -lcjson $(GLIB_LIBS)

$(BISON_C) $(BISON_H): $(PARSER)
	bison -d $(PARSER)

$(LEX_C): $(LEXER) $(BISON_H)
	flex $(LEXER)

clean:
	rm -f $(EXEC) $(LEX_C) $(BISON_C) $(BISON_H)
	