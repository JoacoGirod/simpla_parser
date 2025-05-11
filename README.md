# Required Dependencies
```bash
sudo apt install libglib2.0-dev
```
```bash
sudo apt-get install libcjson-dev
```

# Execution
- Full Parsing
```bash
clear; make clean; make ; ./parser ./resources/documents/constitucion_nacional.txt ./output/parsed_constitucion_nacional.json
```

- Test Casing
```bash
clear; make clean; make ; ./parser ./resources/test/test_casing.txt ./output/casing_test
```
- Test Structure
```bash
clear; make clean; make ; ./parser ./resources/test/test_structure.txt ./output/structure_test
```

# Schema
- **Documents**
	- document_id
	- body
- **Division Types**
	- title // working more like an enum Titulo, Seccion, Capitulo, etc
- **Divisions**
	- id
	- ordinal
	- body
	- *fk_division_type*
	- *fk_division*  NULLABLE // for recursion
	- *fk_document*  NULLABLE
	- CONSTRAINT: both fk cannot be null
- **Articles**
	- id
	- ordinal
	- body
	- embedding
	- *fk_division*
	- CONSTRAINT either start_text or text have to be null
- **Subarticles**
	- id
	- ordinal
	- body
	- embedding
	- *fk_article*

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

DIVISION(type="PARTE", original_type_text="PARTE", ordinal=1, original_ordinal_text="PRIMERA", body="")

DIVISION(type="CAPITULO", original_type_text="Capítulo", ordinal=1,  original_ordinal_text="Primero", body="Declaraciones, derechos y garantías")

ARTICLE(ordinal=1, original_ordinal_text="1", body="La ...")

SUBARTICLE(ordinal=1, original_ordinal_text="1", body="El ...")

SUBARTICLE(ordinal=2, original_ordinal_text="2", body="Ella ...")

SUBARTICLE(ordinal=3, original_ordinal_text="3", body="Ella ...")
```

And lastly the parser, would check a very relaxed grammar on the lexer's output and generates SQL insertions, keep in mind the table `division_types` holds the following pairs [<1, "Parte">, <2, "Capitulo">, ...]
```sql
INSERT INTO Documents (title, body) VALUES ('Constitucion de la Nacion Argentina', 'PREAMBULO Nos ...'); -- Extract document_id
INSERT INTO Divisions (fk_document, fk_division, fk_division_type, original_type_text, ordinal, original_ordinal_text, body) VALUES (document_id, NULL, 1, 'PARTE', 1, 'Primero', ''); -- Extract division_id_1
INSERT INTO Divisions (fk_document, fk_division, fk_division_type, ordinal, original_ordinal_text, body) VALUES (NULL, division_id_1, 2, 'Capítulo', 1, 'Primero', 'Declaraciones, derechos y garantías'); -- Extract division_id_2
INSERT INTO Articles (fk_division, ordinal, body) VALUES (division_id_2, 1, 'La ...'); -- Extract article_id
INSERT INTO Subarticles (fk_article, ordinal, body) VALUES (article_id, 1, 'La ...');
```
