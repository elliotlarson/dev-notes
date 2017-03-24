# SQLite Notes

## CLI

### Create a new database and/or start a CLI session for DB

```bash
$ sqlite3 mydb.db
```

### Exit a CLI session

```bash
sqlite> .quit
```

or 

```bash
sqlite> .exit
```

### Load data into a database

```bash
$ sqlite3 mydb.db < dump.sql
```

### Create a database dump

This will create a dump file in the directory you started the CLI in.

```bash
$ sqlite mydb.db
sqlite> .output my_dump.sql
sqlite> .dump
```

### Create a table dump

```bash
sqlite> .output categories.sql
sqlite> .dump categories
```

### Get a list of tables

```bash
sqlite> .tables
```

### Get the schema for a database

```bash
sqlite> .schema
```

### Get the schema for a table

```bash
sqlite> .schema category
```

### Formatting query output

By default output of queries looks like:

```bash
sqlite> select * from category limit 10;
1|DETECTIVE FICTION|1|0|0
2|THE OLD TESTAMENT|2|0|0
3|ASIAN HISTORY|4|0|0
4|RIVER SOURCES|5|0|0
5|WORLD RELIGION|3|0|0
```

You can change to a more readable format with `.mode column` and `.headers on`

```bash
sqlite> .mode column
sqlite> .headers on
sqlite> select * from category limit 10;
id          name               game        round       boardPosition
----------  -----------------  ----------  ----------  -------------
1           DETECTIVE FICTION  1           0           0
2           THE OLD TESTAMENT  2           0           0
3           ASIAN HISTORY      4           0           0
4           RIVER SOURCES      5           0           0
5           WORLD RELIGION     3           0           0
6           SEAN SONG          2           0           1
7           ANIMATED MOVIES    1           0           1
8           NEW YORK CITY      6           0           0
9           AFRICAN WILDLIFE   7           0           0
10          LITTLE RED RIDING  8           0           0
```
