# Postgres Notes

## Backups

#### Loading database backup 

```bash
$ psql -d mydb_production < db/production_bak.sql
```
	
## Doing a database dump

```bash
$ pg_dump mydatabase > mydumpfile.sql
```
	
You can also dump specific tables:

```bash
$ pg_dump -t clients -t sites mydatabase > mydumpfile.sql
```
	
You can dump only data (no table creates or drops):

```bash
$ pg_dump -a mydatabase > mydumpfile.sql
```

## Psql Commands

### List databases

```bash
mydb=> \l
```

### List users

```bash
mydb=> \du
```

### Connect to database

```bash
mydb=> \c
```

### Turn pager setting off for session

```bash
mydb=> \pset pager off
```

### Creating a user

This user can create and delete databases.

```bash
mydb=> create user brandt password 'thatsmarvelous';
mydb=> alter user brandt createdb;
```

## Files

Using the Postgres.app on the Mac, assuming version `9.4`.

### Logfile 

`~/Library/Application Support/Postgres/var-9.4/postgres-server.log`

#### Watch the log:

```bash
$ less +F ~/Library/Application\ Support/Postgres/var-9.4/postgres-server.log
```

#### Log all queries in log file

Set the `log_statement` value to `all` in the config file.

```bash
log_statement = 'all'
```

### Config file 

`~/Library/Application Support/Postgres/var-9.4/postgresql.conf`

Edit the file

```bash
$ vi ~/Library/Application\ Support/Postgres/var-9.4/postgresql.conf
```