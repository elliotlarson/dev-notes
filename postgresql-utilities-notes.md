# Postgresql PSQL Notes

## Connecting to a database with `psql`

This is the command line interface to the database

```bash
$ psql -U brandt -h mydb.host.com -p 60924 -d mydbname
```

### Psql Commands

* `\l` = list databases
* `\d` = list tables
* `\d table` = describe table
* `\du` = list users
* `\x` = toggle expanded format of output
* `\x auto` = psql figures out what the best format is for output
* `\c` = Connect to database
* `\pset pager off` = turning pager setting off
* `\dn` = Listing schemas
* `\dl *.*` = Listing schemas and tables

## Creating a database with `createdb`

```bash
$ createdb databasename
```

...or, with owner

```bash
$ createdb -O ownername databasename
```

## Dropping a database with `dropdb`

```bash
$ dropdb databasename
```

## Creating a user on the command line

```bash
$ createuser brandt
```

## Doing a database dump

* `-v` = verbose output
* `-e` = exit immediately on error
* `-c` = output clean or drop database objects (tables) before creating them
* `-O` = do not dump ownership commands on database objects
* `-x` = do not dump revoke or grant commands
* `-a` = only dump data
* `-j<n>` = dump with n number of jobs (use one for each core on the machine)
* `-s` = dump only the schema of the database
* `-t<table-name>` = dump specific tables (you can pass multiple `-t` flags)
* `-n<schema-name>` = only dump the specified namespace (schema)
* `-T<table-name>` = exclude specific tables (you can pass multiple `-T` flags)
* `-F<format>` = `c` standard postgres compression format, `p` plain text SQL format
* `-f <filename>` = the file to dump the data to

```bash
$ pg_dump -v -e -c -O -x databasename -f databasename.dumps
```

### Loading database backup

Loading a non compressed backup:

```bash
$ psql -d mydb_production < db/production_bak.sql
```

Loading a compressed backup

* `-v` = verbose output
* `-e` = exit immediately on error
* `-1` = run in a transaction
* `-c` = clean or drop database objects (tables) before creating them
* `-C` = create the database before loading (if -c is also specified the database will be dropped and recreated)
* `-O` = do not load ownership commands on database objects
* `-x` = do not load revoke or grant commands
* `-a` = only load data
* `-j<n>` = load with n number of jobs (use one for each core on the machine you're dumping from)
* `-s` = restore only the schema of the database
* `-t<table-name>` = restore specific tables (you can pass multiple `-t` flags)
* `-T<table-name>` = exclude specific tables (you can pass multiple `-T` flags)
* `-n<schema-name>` = only restore the specified namespace (schema)

```bash
$ pg_restore -j8 -x -O -v -e -1 -d mydb_production database.dump
```
