# ACADIA Metrics

#### projects created by month and year

	select 
		date_part('month', created_at) as month, 
		date_part('year', created_at) as year, 
		count(id) 
	from 
		projects 
	group 
		by date_part('year', created_at), date_part('month', created_at) 
	order by 
		date_part('year', created_at), date_part('month', created_at);
		

output as csv

	psql -d acadia_development -c "select concat(date_part('month', created_at), '/', date_part('year', created_at)) as month, count(id) from projects group by date_part('year', created_at), date_part('month', created_at) order by date_part('year', created_at);" -A -t -F',' > products_by_month.csv
	
