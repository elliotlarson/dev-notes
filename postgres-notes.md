# Postgres Notes

## Utilities

#### Creating a database with `createdb`

```bash
$ createdb databasename
```

...or, with owner

```bash
$ createdb -O ownername databasename
```

#### Dropping a database with `dropdb`

```bash
$ dropdb databasename
```

## Permissions

#### Creating a user on the command line

```bash
$ createuser brandt
```

#### Creating a user in `psql`

This user can create and delete databases.

```bash
mydb=> create user brandt password 'thatsmarvelous';
```

#### Give the user the ability to create databases in `psql`

```bash
mydb=> alter user brandt createdb;
```

#### Making the user a superuser in `psql`

```bash
psql> ALTER USER myuser WITH SUPERUSER;
```

#### Change the role of a table:

```bash
$ psql mydb
psql> ALTER TABLE my_table OWNER TO newuserrole;
```

## Connecting to a database with `psql`

```bash
$ psql -U brandt -h mydb.host.com -p 60924 -d mydbname
```

## Doing a database dump

Dumping a compressed backup

```bash
$ pg_dump -v -Fc mydatabase > mydumpfile.dump
```

Dumping SQL backup

```bash
$ pg_dump mydatabase > mydumpfile.sql
```

Dump specific tables

```bash
$ pg_dump -t clients -t sites mydatabase > mydumpfile.sql
```

Dump only data (no table creates or drops)

```bash
$ pg_dump -a mydatabase > mydumpfile.sql
```

Dumping only the schema

```bash
$ pg_dump -s -d my_database -f bak.sql
```

Dumping a specific schema:

```bash
$ pg_dump -n my_schema -d my_database -f bak.sql
```

#### Loading database backup

Loading a non compressed backup:

```bash
$ psql -d mydb_production < db/production_bak.sql
```

Loading a compressed backup

* `-v` = verbose output
* `-e` = exit immediately on error
* `-1` = run in a transaction
* `-c` = clean or drop database objects (tables) before creating them

```bash
$ pg_restore -v -e -1 -f db/production_bak.bak -d mydb_production
```

## Psql Commands

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

#### Set the search path to a schema

```sql
SET search_path TO 'qualitymetrics-fss';
```

## Administration

### Showing long running postgres processes

https://medium.com/little-programming-joys/finding-and-killing-long-running-queries-on-postgres-7c4f0449e86d

```sql
SELECT pid, now() - pg_stat_activity.query_start AS duration, left(query, 80), state
FROM pg_stat_activity
WHERE now() - pg_stat_activity.query_start > interval '5 minutes';
```

### Kill a hung query

First find the PID of the process

```sql
SELECT pg_terminate_backend(<pid>);
```

### PSQL queries to increase the Postgres log level

```sql
ALTER SYSTEM SET log_min_messages = 'INFO';
ALTER SYSTEM SET log_statement = 'all';
SELECT pg_reload_conf();
```

## Files

### Asking the database where it keeps the log file:

This could be useful, however when I tried it the records didn't have a location for the log file on my system.

```sql
SELECT *
FROM pg_settings
WHERE category IN( 'Reporting and Logging / Where to Log' , 'File Locations')
ORDER BY category, name;
```

### Log File

Using the Postgres.app on the Mac: `~/Library/Application\ Support/Postgres/var-9.5/postgres-server.log`

Using Homebrew: `/usr/local/var/log/postgres.log`

### Config file

Using the Postgres.app on the Mac: `~/Library/Application\ Support/Postgres/var-9.5/postgresql.conf`

Using Homebrew: `/usr/local/var/postgres/postgresql.conf`

### Host based authentication file

Using the Postgres.app on the Mac: `~/Library/Application\ Support/Postgres/var-9.5/pg_hba.conf`

Using Homebrew: `/usr/local/var/postgres/pg_hba.conf`

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

Add to config file `/usr/local/var/postgres/postgres.conf`

```text
log_min_duration_statement = 1
log_duration = off
log_line_prefix = '%t [%p]: [%l-1] user=%u,db=%d,app=%a,client=%h '
log_statement = 'none'
```

Make sure you restart the server.  Run some queries and then generate the report with:

```bash
$ pgbadger /usr/local/var/log/postgres.log
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
