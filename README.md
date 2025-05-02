# Examples
## First Version
Flex Alone, manual backtracking
```bash
flex article.l; gcc lex.yy.c -o article; ./article < example_1.txt
```
## Second Version
Flex Alone, tokenization, paving way for a bison post processing
```bash
flex article_2.l; gcc lex.yy.c -o article_2; ./article_2 < example_2.txt
```
