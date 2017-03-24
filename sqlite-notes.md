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

### Display query results with records on each line

If you're table is really long, it can be easier to read the output if each field is on its own line:

```bash
sqlite> .mode line
sqlite> select * from category limit 2;
           id = 1
         name = DETECTIVE FICTION
         game = 1
        round = 0
boardPosition = 0

           id = 2
         name = THE OLD TESTAMENT
         game = 2
        round = 0
boardPosition = 0
```

### Show what the current display settings are with `.show`

```bash
sqlite> .show
        echo: off
         eqp: off
     explain: auto
     headers: on
        mode: column
   nullvalue: ""
      output: stdout
colseparator: "|"
rowseparator: "\n"
       stats: off
       width:
```

### Executing a query directly from the shell

```bash
$ sqlite3 mydb.db -header -column "SELECT * FROM categories;"
```
