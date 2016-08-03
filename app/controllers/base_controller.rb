class BaseController < ApplicationController
	

	def dashboard
		@changes = changes
		@changes_by_service = changes_by_service
		@changes_for_services = changes_for_services
		@changes_by_service_and_region = changes_by_service_and_region
		@changes_for_services_and_regions = changes_for_services_and_regions
	end


    #request: http://localhost:3000/changes/2015-08-03/2016-08-03
    #params: from_date, to_date
    #computes: ip_address changes between above dates
    #returns: hash - {added: [], deleted: []}
	def changes
		@changes = "changes"
		@from_date = params[:from_date]
		@to_date = params[:to_date]

		return @changes
	end


    #request: http://localhost:3000/changes_by_service/2015-08-03/2016-08-03
    #params: from_date, to_date
    #computes: ip_address changes by service between above dates
    #returns: hash - {EC2: {added: [], deleted: []}, AMAZON: {added: [], deleted: []} }
	def changes_by_service
	    @changes_by_service = "changes_by_service"
	    @from_date = params[:from_date]
		@to_date = params[:to_date]

		return @changes_by_service
	end

    
    #request: http://localhost:3000/changes_for_services/2015-08-03/2016-08-03/EC2;AMAZON;COLUDFRONT/
	#params: from_date, to_date, service[]
    #computes: ip_address changes for an array of services between above dates
    #returns: hash - {EC2: {added: [], deleted: []}, AMAZON: {added: [], deleted: []} }
	def changes_for_services
        @changes_for_services = "changes_for_services"
        @from_date = params[:from_date]
		@to_date = params[:to_date]

        #services parm should be of format 'EC2-AMAZON-CLOUDFRONT' (services seperated by '-')
		#@services is an array of atrings
		@services = params[:services].split(';')

		return @changes_for_services
	end


    #request: http://localhost:3000/changes_by_service_and_region/2015-08-03/2016-08-03
	#params: from_date, to_date
    #computes: ip_address changes by service and region between above dates
    #returns: hash - {EC2: { 'us-east-1' : {added: [], deleted: []}, 'ap-northeast-1' : {added: [], deleted: []} }, AMAZON: { 'us-east-1' : {added: [], deleted: []}, 'ap-northeast-1' : {added: [], deleted: []} }}
	def changes_by_service_and_region
        @changes_by_service_and_region = "changes_by_service_and_region"
        @from_date = params[:from_date]
		@to_date = params[:to_date]

		return @changes_by_service_and_region
	end


    #request: http://localhost:3000/changes_for_services_and_regions/2015-08-03/2016-08-03/EC2;AMAZON;COLUDFRONT/us-east-1;ap-northeast-1
	#params: from_date, to_date, service[], region[]
    #computes: ip_address changes between above dates for an array of services and regions
    #returns: hash - {EC2: { 'us-east-1' : {added: [], deleted: []}, 'ap-northeast-1' : {added: [], deleted: []} }, AMAZON: { 'us-east-1' : {added: [], deleted: []}, 'ap-northeast-1' : {added: [], deleted: []} }}
	def changes_for_services_and_regions
        @changes_for_services_and_regions = "changes_for_services_and_regions"
        @from_date = params[:from_date]
		@to_date = params[:to_date]

        #services parm should be of format 'EC2-AMAZON-CLOUDFRONT' (services seperated by '-')
		#@services is an array of atrings
		@services = params[:services].split(';')
	    @regions = params[:regions].split(';')

		return @changes_for_services_and_regions
	end
end
