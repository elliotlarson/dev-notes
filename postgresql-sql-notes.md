# Postgresql SQL Notes

## Problem on Mac OS

After installing a new OS update, I started getting this error when trying to connect to postgres:

```bash
$ psql
# psql: could not connect to server: No such file or directory
# 	Is the server running locally and accepting
# 	connections on Unix domain socket "/tmp/.s.PGSQL.5432"?
```

After some Google action, I found a solution that worked:

Search for the `postmaster.pid` file and remove it:

```bash
$ sudo find / -name postmaster.pid
# /usr/local/var/postgresql@11/postmaster.pid
$ rm -rf /usr/local/var/postgresql@11/postmaster.pid
```

Then start postgres:

```bash
$ brew services start postgresql@11
```

## Creating a database

```sql
CREATE DATABASE mydb;
```

## Creating a user

This user can create and delete databases.

```sql
CREATE USER brandt PASSWORD 'thatsmarvelous';
```

or with role

```sql
CREATE ROLE brandt WITH PASSWORD 'thatsmarvelous';
```

## Change owner of a database

```sql
ALTER DATABASE biglebowski OWNER TO brandt;
```

## Give the user the ability to create databases

```sql
ALTER USER brandt CREATEDB;
```

## Making the user a superuser

```sql
ALTER USER myuser WITH SUPERUSER;
```

## Change the role of a table

```sql
ALTER TABLE my_table OWNER TO newuserrole;
```

## Renaming a table

```sql
ALTER TABLE my_table RENAME TO new_table_name;
```

## Set the search path to a schema

```sql
SET search_path TO 'qualitymetrics-fss';
```
