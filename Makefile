# File: Makefile

LEXER = lexer.l
PARSER = parser.y
EXEC = parser

LEX_C = lex.yy.c
BISON_C = parser.tab.c
BISON_H = parser.tab.h

CC = gcc
CFLAGS = -Wall -g

all: $(EXEC)

$(EXEC): $(BISON_C) $(LEX_C)
	$(CC) $(CFLAGS) -o $(EXEC) $(BISON_C) $(LEX_C) grammar_actions.c -lfl

$(BISON_C) $(BISON_H): $(PARSER)
	bison -d $(PARSER)

$(LEX_C): $(LEXER) $(BISON_H)
	flex $(LEXER)

clean:
	rm -f $(EXEC) $(LEX_C) $(BISON_C) $(BISON_H)
