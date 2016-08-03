#Creates 'last_change' table

require 'aws-sdk'

	    dynamoDB = Aws::DynamoDB::Resource.new(region: 'us-west-2')

		#Update Cidr table
		table = dynamoDB.table('last_change')
	    table.put_item({
		    item:
		    {
		    	"id" => 1,
		    	"sync_token" => '1469801765'
		    }
	    })
	    puts "* last_change table updated"