# IronRidge Distributor Map Notes

#### Pivotal Tracker Story

https://www.pivotaltracker.com/s/projects/885958/stories/65323318

#### Getting CSV of Distributors out of the database

	select 'distributor', 'address', 'line2', 'city', 'state', 'zipcode', 'region', 'phone', 'fax', 'email' union select d.name, l.address, l.line_2, l.city, l.state, l.zipcode, l.region, l.phone, l.fax, l.email into outfile '/Users/Elliot/Desktop/distributor_locations.csv' fields terminated by ',' optionally enclosed by '"' lines terminated by '\n' from distributor_locations as l join distributors as d on l.distributor_id = d.id;
	

#### Files from the old system that were removed

**commit:** 25fc1b459af0f00f9b373129cecba9d2557447df

    app/assets/javascripts/_map.coffee.erb                    | 223 -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    app/assets/javascripts/distributor_map.coffee             |   2 --
    app/assets/javascripts/lib/map_circle_overlay.js          |  89 -----------------------------------------------------------------------------------------
    app/assets/stylesheets/_map.scss                          | 105 ---------------------------------------------------------------------------------------------------------
    app/assets/stylesheets/screen.scss                        |   1 -
    app/assets/stylesheets/website.scss                       |   1 -
    app/assets/stylesheets/website_configurator.scss          |   1 -
    app/controllers/distributors_controller.rb                |  87 ---------------------------------------------------------------------------------------
    app/helpers/distributors_helper.rb                        |  25 -------------------------
    app/mailers/distributor_mailer.rb                         |  12 ------------
    app/models/distributor.rb                                 | 119 -----------------------------------------------------------------------------------------------------------------------
    app/views/distributor_mailer/distributor_status.html.haml |   8 --------
    app/views/distributor_mailer/distributor_status.text.haml |   9 ---------
    app/views/distributors/_filter.html.haml                  |  36 ------------------------------------
    app/views/distributors/_form.html.haml                    |   2 --
    app/views/distributors/_salesforce_form.html.erb          |  73 -------------------------------------------------------------------------
    app/views/distributors/_subnav.html.haml                  |   5 -----
    app/views/distributors/_table.html.haml                   |  22 ----------------------
    app/views/distributors/index.html.haml                    |  50 --------------------------------------------------
    app/views/distributors/new.html.haml                      |  19 -------------------
    app/views/distributors/show.html.haml                     |  43 -------------------------------------------
    app/views/distributors/submitted.html.haml                |   8 --------
    db/migrate/20120821192058_clean_up_distributors.rb        |  53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
    db/schema.rb                                              |  23 +----------------------
    spec/factories/distributors.rb                            |  12 ------------
    spec/helpers/distributors_helper_spec.rb                  |  15 ---------------
    spec/models/distributor_spec.rb                           |   6 +-----


#### API for zipcode search service object

	DistributorLocationSearch.call(options)
	
	# options = zipcode, array of location types, array of product types
	
	# returns = list of distributor location records ordered by closest to farthest away