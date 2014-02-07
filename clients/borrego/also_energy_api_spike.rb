# http://savonrb.com/version2/client.html

client = Savon.client(wsdl: 'http://www.alsoenergy.com/WebAPI/WebAPI.svc?singleWsdl')

client.operations
# [:login, :logout, :get_site_hardware_list, :get_summary_hardware, :get_site_detail, :get_site_list, :get_bin_data, :get_summary_data, :get_gateway_config, :send_heartbeat, :send_command_result, :upload_raw_data, :upload_byte_data, :get_timestamp]

login_response = client.call(:login, message: {Username: 'SDCWAapi', Password: 'oneHOUSE1'})
session_id = login_response.body[:login_response][:login_result][:session_id]

site_list_response = client.call(:get_site_list, message: {SessionID: session_id})
sites = site_list_response.body[:get_site_list_response][:get_site_list_result][:items][:list_item]
# [{:id=>"28096", :name=>"SDCWA Escondido", :type=>"2"}, {:id=>"28097", :name=>"SDCWA Headquarters", :type=>"2"}, {:id=>"28099", :name=>"SDCWA Twin Oaks", :type=>"2"}]

# SDCWA Escondido
summary_hardware_response = client.call(:get_summary_hardware, message: {SessionID: session_id, SiteID: 28096})
summary_hardware = hardware_response.body[:get_summary_hardware_response][:get_summary_hardware_result][:hardware_list][:hardware_complete]
# {:device_code=>"SU", :device_id=>"0", :flags=>"0", :gateway_id=>nil, :hardware_id=>"-28096", :name=>nil, :site_id=>"28096", :field_list=>{:field_info=>[{:name=>"ProdKWH", :units=>nil}, {:name=>"Insolation", :units=>nil}]}}
site_hardware_response = client.call(:get_site_hardware_list, message: {SessionID: session_id, SiteID: 28096})
site_hardware = site_hardware_response.body[:get_site_hardware_list_response][:get_site_hardware_list_result][:hardware_list][:hardware_complete]
# [
#   {:device_code=>"GW", :device_id=>"201", :flags=>"1", :gateway_id=>"00-90-E8-3B-A3-0F", :hardware_id=>"14503", :name=>"Data Logger", :site_id=>"28096", :field_list=>nil},
#
#   {:device_code=>"PM", :device_id=>"153", :flags=>"1", :gateway_id=>"00-90-E8-3B-A3-0F", :hardware_id=>"14504", :name=>"Production Meter - Ion 8600", :site_id=>"28096", :field_list=>{:field_info=>[{:name=>"KWHdel", :units=>"Kilowatt hours"}, {:name=>"KWHrec", :units=>"Kilowatt hours"}, {:name=>"KW", :units=>"Kilowatts"}, {:name=>"PowerFactor", :units=>nil}, {:name=>"VacA", :units=>"Volts"}, {:name=>"VacB", :units=>"Volts"}, {:name=>"VacC", :units=>"Volts"}, {:name=>"IacA", :units=>"Amps"}, {:name=>"IacB", :units=>"Amps"}, {:name=>"IacC", :units=>"Amps"}, {:name=>"PFA", :units=>nil}, {:name=>"PFB", :units=>nil}, {:name=>"PFC", :units=>nil}, {:name=>"KWHnet", :units=>"Kilowatt hours"}]}},
#
#   {:device_code=>"CM", :device_id=>"158", :flags=>"1", :gateway_id=>"00-90-E8-3B-A3-0F", :hardware_id=>"14505", :name=>"Consumption Meter", :site_id=>"28096", :field_list=>{:field_info=>[{:name=>"KWHdel", :units=>"Kilowatt hours"}, {:name=>"KWHrec", :units=>"Kilowatt hours"}, {:name=>"KW", :units=>"Kilowatts"}, {:name=>"PowerFactor", :units=>nil}, {:name=>"VacA", :units=>"Volts"}, {:name=>"VacB", :units=>"Volts"}, {:name=>"VacC", :units=>"Volts"}, {:name=>"IacA", :units=>"Amps"}, {:name=>"IacB", :units=>"Amps"}, {:name=>"IacC", :units=>"Amps"}, {:name=>"PFA", :units=>nil}, {:name=>"PFB", :units=>nil}, {:name=>"PFC", :units=>nil}, {:name=>"KWHnet", :units=>"Kilowatt hours"}]}},
#
#   {:device_code=>"PV", :device_id=>"8", :flags=>"1", :gateway_id=>"00-90-E8-3B-A3-0F", :hardware_id=>"14506", :name=>"Satcon PGP 75kW", :site_id=>"28096", :field_list=>{:field_info=>[{:name=>"Vdc", :units=>"Volts"}, {:name=>"Idc", :units=>"Amps"}, {:name=>"Iac", :units=>"Amps"}, {:name=>"Vac", :units=>"Volts"}, {:name=>"KwDC", :units=>"Kilowatts"}, {:name=>"KwAC", :units=>"Kilowatts"}, {:name=>"KwhAC", :units=>"Kilowatt hours"}]}},
#
#   {:device_code=>"PV", :device_id=>"8", :flags=>"1", :gateway_id=>"00-90-E8-3B-A3-0F", :hardware_id=>"14507", :name=>"Satcon PGP 100kW", :site_id=>"28096", :field_list=>{:field_info=>[{:name=>"Vdc", :units=>"Volts"}, {:name=>"Idc", :units=>"Amps"}, {:name=>"Iac", :units=>"Amps"}, {:name=>"Vac", :units=>"Volts"}, {:name=>"KwDC", :units=>"Kilowatts"}, {:name=>"KwAC", :units=>"Kilowatts"}, {:name=>"KwhAC", :units=>"Kilowatt hours"}]}},
#
#   {:device_code=>"WS", :device_id=>"514", :flags=>"1", :gateway_id=>"00-90-E8-3B-A3-0F", :hardware_id=>"14508", :name=>"SunEdison Weather Station", :site_id=>"28096", :field_list=>{:field_info=>[{:name=>"Sun", :units=>"Watts/meter²"}, {:name=>"TempF", :units=>"Degrees Fahrenheit"}, {:name=>"Temp1", :units=>"Degrees Fahrenheit"}]}}
# ]

# SDCWA Headquarters
summary_hardware_response = client.call(:get_summary_hardware, message: {SessionID: session_id, SiteID: 28097})
summary_hardware = hardware_response.body[:get_summary_hardware_response][:get_summary_hardware_result][:hardware_list][:hardware_complete]
# {:device_code=>"SU", :device_id=>"0", :flags=>"0", :gateway_id=>nil, :hardware_id=>"-28097", :name=>nil, :site_id=>"28097", :field_list=>{:field_info=>[{:name=>"ProdKWH", :units=>nil}, {:name=>"Insolation", :units=>nil}]}}
summary_data_response = client.call(:get_summary_data, message: {SessionID: session_id, BinSize: 'BinDay', FromLocal: DateTime.new(2014, 1, 29, 0, 0, 0), ToLocal: DateTime.new(2014, 1, 29, 23, 59, 0), DataField: [{HID: 28097, FieldName: 'ProdKWH', Function: 'Integral'}]})

site_hardware_response = client.call(:get_site_hardware_list, message: {SessionID: session_id, SiteID: 28097})
site_hardware = site_hardware_response.body[:get_site_hardware_list_response][:get_site_hardware_list_result][:hardware_list][:hardware_complete]
# [
#   {:device_code=>"GW", :device_id=>"201", :flags=>"1", :gateway_id=>"00-90-E8-3B-A3-1F", :hardware_id=>"14509", :name=>"Data Logger", :site_id=>"28097", :field_list=>nil},
#
#   {:device_code=>"PM", :device_id=>"153", :flags=>"1", :gateway_id=>"00-90-E8-3B-A3-1F", :hardware_id=>"14510", :name=>"Production Meter", :site_id=>"28097", :field_list=>{:field_info=>[{:name=>"KWHdel", :units=>"Kilowatt hours"}, {:name=>"KWHrec", :units=>"Kilowatt hours"}, {:name=>"KW", :units=>"Kilowatts"}, {:name=>"PowerFactor", :units=>nil}, {:name=>"VacA", :units=>"Volts"}, {:name=>"VacB", :units=>"Volts"}, {:name=>"VacC", :units=>"Volts"}, {:name=>"IacA", :units=>"Amps"}, {:name=>"IacB", :units=>"Amps"}, {:name=>"IacC", :units=>"Amps"}, {:name=>"PFA", :units=>nil}, {:name=>"PFB", :units=>nil}, {:name=>"PFC", :units=>nil}, {:name=>"KWHnet", :units=>"Kilowatt hours"}]}},
#
#   {:device_code=>"CM", :device_id=>"158", :flags=>"1", :gateway_id=>"00-90-E8-3B-A3-1F", :hardware_id=>"14511", :name=>"Consumption Meter", :site_id=>"28097", :field_list=>{:field_info=>[{:name=>"KWHdel", :units=>"Kilowatt hours"}, {:name=>"KWHrec", :units=>"Kilowatt hours"}, {:name=>"KW", :units=>"Kilowatts"}, {:name=>"PowerFactor", :units=>nil}, {:name=>"VacA", :units=>"Volts"}, {:name=>"VacB", :units=>"Volts"}, {:name=>"VacC", :units=>"Volts"}, {:name=>"IacA", :units=>"Amps"}, {:name=>"IacB", :units=>"Amps"}, {:name=>"IacC", :units=>"Amps"}, {:name=>"PFA", :units=>nil}, {:name=>"PFB", :units=>nil}, {:name=>"PFC", :units=>nil}, {:name=>"KWHnet", :units=>"Kilowatt hours"}]}},
#
#   {:device_code=>"PV", :device_id=>"8", :flags=>"1", :gateway_id=>"00-90-E8-3B-A3-1F", :hardware_id=>"14512", :name=>"Satcon PGP 375", :site_id=>"28097", :field_list=>{:field_info=>[{:name=>"Vdc", :units=>"Volts"}, {:name=>"Idc", :units=>"Amps"}, {:name=>"Iac", :units=>"Amps"}, {:name=>"Vac", :units=>"Volts"}, {:name=>"KwDC", :units=>"Kilowatts"}, {:name=>"KwAC", :units=>"Kilowatts"}, {:name=>"KwhAC", :units=>"Kilowatt hours"}]}},
#
#   {:device_code=>"WS", :device_id=>"514", :flags=>"1", :gateway_id=>"00-90-E8-3B-A3-1F", :hardware_id=>"14513", :name=>"SunEdison Weather Station", :site_id=>"28097", :field_list=>{:field_info=>[{:name=>"Sun", :units=>"Watts/meter²"}, {:name=>"TempF", :units=>"Degrees Fahrenheit"}, {:name=>"Temp1", :units=>"Degrees Fahrenheit"}]}}
# ]

# SDCWA Twin Oaks
summary_hardware_response = client.call(:get_summary_hardware, message: {SessionID: session_id, SiteID: 28099})
summary_hardware = hardware_response.body[:get_summary_hardware_response][:get_summary_hardware_result][:hardware_list][:hardware_complete]
# {:device_code=>"SU", :device_id=>"0", :flags=>"0", :gateway_id=>nil, :hardware_id=>"-28099", :name=>nil, :site_id=>"28099", :field_list=>{:field_info=>{:name=>"ProdKWH", :units=>nil}}}
site_hardware_response = client.call(:get_site_hardware_list, message: {SessionID: session_id, SiteID: 28099})
site_hardware = site_hardware_response.body[:get_site_hardware_list_response][:get_site_hardware_list_result][:hardware_list][:hardware_complete]
# [
#   {:device_code=>"GW", :device_id=>"201", :flags=>"1", :gateway_id=>"00-90-E8-3B-88-C3", :hardware_id=>"14519", :name=>"Data Logger", :site_id=>"28099", :field_list=>nil},
#
#   {:device_code=>"PM", :device_id=>"153", :flags=>"1", :gateway_id=>"00-90-E8-3B-88-C3", :hardware_id=>"14520", :name=>"Production Meter - ION 8600 Meter", :site_id=>"28099", :field_list=>{:field_info=>[{:name=>"KWHdel", :units=>"Kilowatt hours"}, {:name=>"KWHrec", :units=>"Kilowatt hours"}, {:name=>"KW", :units=>"Kilowatts"}, {:name=>"PowerFactor", :units=>nil}, {:name=>"VacA", :units=>"Volts"}, {:name=>"VacB", :units=>"Volts"}, {:name=>"VacC", :units=>"Volts"}, {:name=>"IacA", :units=>"Amps"}, {:name=>"IacB", :units=>"Amps"}, {:name=>"IacC", :units=>"Amps"}, {:name=>"PFA", :units=>nil}, {:name=>"PFB", :units=>nil}, {:name=>"PFC", :units=>nil}, {:name=>"KWHnet", :units=>"Kilowatt hours"}]}},
#
#   {:device_code=>"PV", :device_id=>"134", :flags=>"1", :gateway_id=>"00-90-E8-3B-88-C3", :hardware_id=>"14521", :name=>"SMA SC500U - 1", :site_id=>"28099", :field_list=>{:field_info=>[{:name=>"Vdc", :units=>"Volts"}, {:name=>"Idc", :units=>"Amps"}, {:name=>"Vac", :units=>"Volts"}, {:name=>"Iac", :units=>"Amps"}, {:name=>"KwhAC", :units=>"Kilowatt hours"}, {:name=>"KwAC", :units=>"Kilowatts"}]}},
#
#   {:device_code=>"PV", :device_id=>"134", :flags=>"1", :gateway_id=>"00-90-E8-3B-88-C3", :hardware_id=>"14522", :name=>"SMA SC500U - 2", :site_id=>"28099", :field_list=>{:field_info=>[{:name=>"Vdc", :units=>"Volts"}, {:name=>"Idc", :units=>"Amps"}, {:name=>"Vac", :units=>"Volts"}, {:name=>"Iac", :units=>"Amps"}, {:name=>"KwhAC", :units=>"Kilowatt hours"}, {:name=>"KwAC", :units=>"Kilowatts"}]}}
# ]


# API
# ===
# [current_data_point]
# every 15 minutes get current data for:
# * solar_energy_production
# * net_electric_usage
# * gross_electric_usage
# * gasses
# * cars
# * homes
#
# [data_day]
# every day get data for:
# * gross_electric_usage
# * solar_production
# * net_electric_usage
# * so2
# * co2
# * nox

