# Postgres Notes

## Utilities

#### Creating a database with `createdb`

```bash
$ createdb -O ownername databasename
```

#### Dropping a database with `dropdb`

```bash
$ dropdb databasename
```

## Permissions

#### Creating a user

This user can create and delete databases.

```bash
mydb=> create user brandt password 'thatsmarvelous';
mydb=> alter user brandt createdb;
```

#### Making the user a superuser

```bash
psql> ALTER USER myuser WITH SUPERUSER;
```

#### Change the role of a table:

```bash
$ psql mydb
psql> ALTER TABLE my_table OWNER TO newuserrole;
```
## Doing a database dump

Dumping a compressed backup:

```bash
$ pg_dump -Fc mydatabase > mydumpfile.bak
```

You can also dump specific tables:

```bash
$ pg_dump -t clients -t sites mydatabase > mydumpfile.sql
```

You can dump only data (no table creates or drops):

```bash
$ pg_dump -a mydatabase > mydumpfile.sql
```

Dumping only the schema:

```bash
$ pg_dump -s my_database > my_database_schema.sql
```

#### Loading database backup

Loading a non compressed backup:

```bash
$ psql -d mydb_production < db/production_bak.sql
```
Loading a compressed backup:

```bash
$ pg_restore -j8 -f db/production_bak.bak -d mydb_production
```

## Psql Commands

#### List databases

```bash
mydb=> \l
```

#### List users

```bash
mydb=> \du
```

#### Describe a table

```bash
mydb=> \d table_name
```

#### Return select results in expanded format

```bash
mydb=> \x
```

#### Connect to database

```bash
mydb=> \c
```

#### Turn pager setting off for session

```bash
mydb=> \pset pager off
```

#### Listing schemas

```bash
mydb=> \dn
```

#### Listing schemas and tables

```bash
mydb=> \dl *.*
```

## Queries

#### Renaming a table

```sql
ALTER TABLE my_table RENAME TO new_table_name;
```

#### Getting database size:

For the whole database:

```sql
SELECT datname, pg_size_pretty(pg_database_size(datname))
FROM pg_database
WHERE datname = 'ra_sam_development'
ORDER BY pg_database_size(datname) DESC;
```

Getting amounts for individual tables:

```sql
SELECT
  table_name as "table",
  pg_size_pretty(pg_relation_size(table_name)) as "size"
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY pg_relation_size(table_name) DESC;
```

Get the number of records in a table:

```sql
SELECT
	relname AS "table",
	to_char(n_live_tup, 'FM9,999,999,999,999') AS "count"
FROM pg_stat_user_tables
ORDER BY n_live_tup DESC;
```

## Files

Using the Postgres.app on the Mac, assuming version `9.5`.

#### Logfile

`~/Library/Application\ Support/Postgres/var-9.5/postgres-server.log`

#### Watch the log:

```bash
$ less +F ~/Library/Application\ Support/Postgres/var-9.5/postgres-server.log
```

#### Config file

`~/Library/Application\ Support/Postgres/var-9.5/postgresql.conf`

Edit the file

```bash
$ vi ~/Library/Application\ Support/Postgres/var-9.5/postgresql.conf
```

**Setting the slow query log:**

Set the `log_statement` value to `all`.

Set the `log_min_duration_statement` statement to a number of milliseconds, say `250`.  

Queries that last longer than that get logged to the log file:

## Setting up pgbadger for log analysis

[pgbadger](https://github.com/dalibo/pgbadger) will analyze the log file and spit out a report with interesting information about postgres, like a list of the slowest queries.

**Install:**

```bash
$ brew install pgbadger
```

**Config file settings:**

```text
log_min_duration_statement = 1
log_duration = off
log_line_prefix = '%t [%p]: [%l-1] user=%u,db=%d,app=%a,client=%h '
log_statement = 'none'
```

Make sure you restart the server.  Run some queries and then generate the report with:

```bash
$ pgbadger ~/Library/Application\ Support/Postgres/var-9.5/postgres-server.log
```

The report will be an html file named `out.html`.


## PostgreSQL's explain analyze made readable

You can use the [explain.depesz.com](http://explain.depesz.com) to break down the results of an `EXPLAIN ANALYZE` query in a more human readable fashion.


## Connecting through a tunnel

Create the SSH tunnel:

```bash
$ ssh -nNT -L 3333:ra-sam.cdko7wofihzp.us-west-2.rds.amazonaws.com:5432 deploy@w1.rpm
```

```bash
$ psql -h localhost -p 3333 -U postgres -W ra_sam
```
