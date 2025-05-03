# What am i to do?
- Increase information retrieved by the lexer
- Define a proper and flexible grammar
- Attempt to produce some useful output?

# Objective
From this raw input:
```
PREAMBULO Nos...

PRIMERA PARTE

Capítulo Primero

Declaraciones, derechos y garantías

Artículo 1º.- La ...

1. El
2. Ella
3. Ellos

```

The lexer should return:
```
BODY(text="PREAMBULO Nos...)

DIVISION(type="CAPITULO", ordinal=1, original_type_text="Capítulo", original_ordinal_text="Primero", body="Declaraciones, derechos y garantías")

ARTICLE(ordinal=1, original_ordinal_text="1", body="La ...")

SUBARTICLE(ordinal=1, original_ordinal_text="1", body="El ...")

SUBARTICLE(ordinal=2, original_ordinal_text="2", body="Ella ...")

SUBARTICLE(ordinal=3, original_ordinal_text="3", body="Ella ...")
```

And lastly the parser, would check a very relaxed grammar on the lexer's output and generates SQL insertions, keep in mind the table `division_types` holds the following pairs <1, "Capitulo", >
```sql
INSERT INTO Documents (title, body) VALUES ("Constitucion de la Nacion Argentina", "PREAMBULO Nos ..."); -- Extract document_id
INSERT INTO Division  ()
        print(f"INSERT INTO Divisions (id, division_ordinal, division_ordinal_text, title, start_text, fk_type, fk_divisions, fk_document) "
```


# Executing
- Test Casing
```bash
clear; make ; ./parser < ./resources/test/test_casing.txt
```
- Test Structure
```bash
clear; make ; ./parser < ./resources/test/test_structure.txt
```
- Full Parsing
```bash
clear; make ; ./parser < ./resources/documents/constitucion_nacional.txt
```