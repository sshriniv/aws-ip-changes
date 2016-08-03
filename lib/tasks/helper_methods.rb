class HelperMethods

	def self.poll_aws
		aws_ip_ranges_url = URI.parse('https://ip-ranges.amazonaws.com/ip-ranges.json')
	    request = Net::HTTP::Get.new(aws_ip_ranges_url.path)
	    response = Net::HTTP.get(aws_ip_ranges_url)
	    puts "Poll successfull!"

	    return response
	end
	

	def self.put_poll(poll_hash)
		dynamoDB = Aws::DynamoDB::Resource.new(region: 'us-west-2')

		#Update Poll table
		table = dynamoDB.table('polls')
	    table.put_item({
		    item:
		    {
			    "id" => SecureRandom.uuid,
			    "sync_token" => poll_hash[sync_token],
			    "create_date" => poll_hash[create_date],
			    "poll_datetime" => Time.now.strftime("%Y-%M-%d %H:%M:%S %Z")
		    }
	    })
	end


	def self.put_cidrs(cidr_hash)
		dynamoDB = Aws::DynamoDB::Resource.new(region: 'us-west-2')

		#Update Cidr table
		table = dynamoDB.table('cidrs')
			    table.put_item({
		    item:
		    {
		    	"id" => SecureRandom.uuid,
			    "sync_token" => cidr_hash[sync_token],
			    "prefixes" => cidr_hash[prefixes]
		    }
	    })
	end

end