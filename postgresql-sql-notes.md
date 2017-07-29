# Postgresql SQL Notes

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
