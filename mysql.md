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
    