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
	

#### date and time formatting

http://www.postgresql.org/docs/8.1/static/functions-formatting.html

	select to_char(created_at, 'YYYY-MM-DD HH:MM AM') from projects;
	
	
## SQL

#### Create a CSV backup of a table

    COPY accounts TO '/Users/Elliot/website_account_signups.csv' DELIMITER ',' CSV HEADER;
