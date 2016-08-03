
  
  namespace :aws do
    
    desc "One-time task to initialize poll and cidr tables. Populates poll and cidr table with first time poll value"
    task :init do
        response = poll_aws

        #Parse response
        sync_token = JSON.parse(response)["syncToken"]
        create_date = JSON.parse(response)["createDate"]
        prefixes = JSON.parse(response)["prefixes"]
        poll_id = SecureRandom.uuid

        #Update Poll table
        poll_hash = {"poll_id" => poll_id, "sync_token" => sync_token, "create_date" => create_date,"change" => false}
        put_poll(poll_hash)

	
        #Update cidrs table
        cidr_hash = {"sync_token" => sync_token, "prefixes" => prefixes}
        put_cidrs(cidr_hash)

        #Update last_change table
        last_change_hash = {"sync_token" => sync_token, "create_date" => create_date}
        put_last_change(last_change_hash)
    end





    desc "poll aws ip ranges web service to get a list of ip changes"
    task :poll do


        #Poll
        response = poll_aws
  
        #Parse response
        sync_token = JSON.parse(response)["syncToken"]
        create_date = JSON.parse(response)["createDate"]
        prefixes = JSON.parse(response)["prefixes"]
        poll_id = SecureRandom.uuid

        
        if sync_token != last_change
        	#Change since last poll
        	puts "* Change since last poll"
        	change = true

        	#Update poll table
        	poll_hash = {"poll_id" => poll_id, "sync_token" => sync_token, "create_date" => create_date, "change" => change}
            put_poll(poll_hash)

            #Update cidrs table
            cidr_hash = {"sync_token" => sync_token, "prefixes" => prefixes}
            put_cidrs(cidr_hash)

            #Update last_change table
            last_change_hash = {"sync_token" => sync_token, "create_date" => create_date}
            put_last_change(last_change_hash)

        else
        	#No change since last poll
        	puts "* No change since last poll"
        	change = false

            #Update poll table
        	poll_hash = {"poll_id" => poll_id, "sync_token" => sync_token, "create_date" => create_date, "change" => change}
            put_poll(poll_hash)
        end


    end



    def poll_aws
		aws_ip_ranges_url = URI.parse('https://ip-ranges.amazonaws.com/ip-ranges.json')
	    request = Net::HTTP::Get.new(aws_ip_ranges_url.path)
	    response = Net::HTTP.get(aws_ip_ranges_url)
	    puts "* Poll successfull!"

	    return response
	end
	
	def put_poll(poll_hash)
		dynamoDB = Aws::DynamoDB::Resource.new(region: 'us-west-2')

		#Update Poll table
		table = dynamoDB.table('polls')
	    table.put_item({
		    item:
		    {
			    "id" => poll_hash["poll_id"],
			    "sync_token" => poll_hash["sync_token"],
			    "create_date" => poll_hash["create_date"],
			    "poll_datetime" => Time.now.strftime("%Y-%M-%d %H:%M:%S %Z"),
			    "change" => poll_hash["change"]
		    }
	    })
	    puts "* Poll table updated"
	end


	def put_cidrs(cidr_hash)
		dynamoDB = Aws::DynamoDB::Resource.new(region: 'us-west-2')

		#Update Cidr table
		table = dynamoDB.table('cidrs')
		table.put_item({
		    item:
		    {
		    	"id" => SecureRandom.uuid,
			    "sync_token" => cidr_hash["sync_token"],
			    "prefixes" => cidr_hash["prefixes"]
		    }
	    })
	    puts "* Cidr table updated"
	end

	
	def put_last_change(last_change_hash)
	    dynamoDB = Aws::DynamoDB::Resource.new(region: 'us-west-2')

		#Update Cidr table
		table = dynamoDB.table('last_change')
	    table.put_item({
		    item:
		    {
		    	"id" => 1,
		    	"sync_token" => last_change_hash["sync_token"],
		    	"create_date" => last_change_hash["create_date"],
		    }
	    })
	    puts "* last_change table updated"
	end
	

	def last_change
	    dynamoDB = Aws::DynamoDB::Resource.new(region: 'us-west-2')
		table = dynamoDB.table('last_change')

		response = table.get_item({
            key: {"id" => 1},
            attributes_to_get: ["sync_token"],
            consistent_read: true
        })

        return response.item["sync_token"]
	end
	


	def get_last_changed_prefixes
		last_changed_sync_token = last_change["sync_token"]
	    dynamoDB = Aws::DynamoDB::Resource.new(region: 'us-west-2')
		table = dynamoDB.table('cidrs')

		response = table.get_item({
            key: {"sync_token" => last_changed_sync_token},
            attributes_to_get: ["prefixes"],
            consistent_read: true
        })

        return response.item["prefixes"]
	end

   
    #Returns Set of ip addresses for cidr
	def get_ip_addresses(cidr_string)
		cidr = NetAddr::CIDR.create(cidr_string)
		return cidr.range(0,nil).to_set
	end


	def get_ip_addresses_by_service(prefixes)
        ip_addresses_by_service = Hash.new {|hash,key| hash[key] = Set.new}

        prefixes.each do |prefix|
		  ip_addresses = get_ip_addresses(prefix["ip_prefix"])
    	  ip_addresses_by_service[prefix["service"]].merge(ip_addresses)
        end

        return ip_addresses_by_service
    end


  end

