# SQL Notes

#### Inner Join

Select records from two tables if a record is present in both tables.

This pulls a collection of records where users have property records.

	SELECT 
		properties.*,
		users.*
	FROM
		users
		INNER JOIN properties
		ON properties.id = users.property_id;
		
#### Left Join

Select all records from the first table and records from second table if present.

This pulls a collection of all user records and property records when present.

	SELECT 
		properties.*,
		users.*
	FROM
		users
		LEFT JOIN properties
		ON properties.id = users.property_id;
		
