# MySQL Notes

## Client

#### selecting a data set and exporting to CSV file

    SELECT 
    	id, 
    	name 
    INTO OUTFILE '/path/to/file.csv'
    	FIELDS TERMINATED BY ',' 
    	OPTIONALLY ENCLOSED BY '"'
    	LINES TERMINATED BY '\n'
    FROM 
    	locations
    
#### Getting the Size of the MySQL database

This actually returns the size of all of the databases on the system:

```
SELECT table_schema                                        "DB Name", 
   Round(Sum(data_length + index_length) / 1024 / 1024, 1) "DB Size in MB" 
FROM   information_schema.tables 
GROUP  BY table_schema; 
```

#### Show size of all tables in database sorted by size

```
SELECT table_name AS "Tables", 
round(((data_length + index_length) / 1024 / 1024), 2) "Size in MB" 
FROM information_schema.TABLES 
WHERE table_schema = "$DB_NAME"
ORDER BY (data_length + index_length) DESC;
```