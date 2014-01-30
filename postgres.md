# Postgres Notes

## psql command

#### loading database backup locally

	$ psql -d wpbinc_production < db/production_bak.sql
	
## pg_dump commands
	
#### doing a database dump

	$ pg_dump mydatabase > mydumpfile.sql
	
#### dump specific tables	

	$ pg_dump -t clients -t sites mydatabase > mydumpfile.sql
	
#### dump only data

	$ pg_dump -a mydatabase > mydumpfile.sql
	
	
