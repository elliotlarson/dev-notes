# MySQL Notes

## Selecting a data set and exporting to CSV file

```sql
SELECT
	id,
	name
INTO OUTFILE '/path/to/file.csv'
	FIELDS TERMINATED BY ','
	OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
FROM
	locations
```

## Getting the Size of the MySQL database

This actually returns the size of all of the databases on the system:

```sql
SELECT table_schema                                        "DB Name",
   Round(Sum(data_length + index_length) / 1024 / 1024, 1) "DB Size in MB"
FROM   information_schema.tables
GROUP  BY table_schema;
```

## Show size of all tables in database sorted by size

```sql
SELECT table_name AS "Tables",
round(((data_length + index_length) / 1024 / 1024), 2) "Size in MB"
FROM information_schema.TABLES
WHERE table_schema = "$DB_NAME"
ORDER BY (data_length + index_length) DESC;
```

## Config on Mac 

When loading a new database I get an error:

> ERROR 3167 (HY000) at line 17: The 'INFORMATION_SCHEMA.SESSION_VARIABLES' feature is disabled; see the documentation for 'show_compatibility_56'

You need to set the `show_compatibility_56 = ON`.

To do this on a Mac:

```bash
$ sudo vim /etc/my.cnf
```

Add this text:

```text
[mysqld]
show_compatibility_56 = ON
performance_schema
```

Then restart MySQL:

```bash
$ brew services restart mysql@5.7
```
