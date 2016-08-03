#Creates 'polls' table

require 'aws-sdk'

table_name = 'polls'

attribute_defs = [
  { attribute_name: 'id', attribute_type: 'S' },
  { attribute_name: 'poll_datetime', attribute_type: 'S' },
  { attribute_name: 'sync_token',  attribute_type: 'S' },
]
p attribute_defs


key_schema = [
  { attribute_name: 'id', key_type: 'HASH' }
]
p key_schema


index_schema = [
  { attribute_name: 'poll_datetime', key_type: 'HASH'  },
  { attribute_name: 'sync_token',  key_type: 'RANGE' }
]
p index_schema


global_indexes = [{
  index_name:             'polldatetimesynctokenIndex',
  key_schema:             index_schema,
  projection:             { projection_type: 'ALL' },
  provisioned_throughput: { read_capacity_units: 5, write_capacity_units: 10 }
}]
p global_indexes


request = {
  attribute_definitions:    attribute_defs,
  table_name:               table_name,
  key_schema:               key_schema,
  global_secondary_indexes: global_indexes,
  provisioned_throughput:   { read_capacity_units: 5, write_capacity_units: 10 }
}
p request


dynamodb_client = Aws::DynamoDB::Client.new(region: 'us-west-2')
p dynamodb_client


dynamodb_client.create_table(request)
p dynamodb_client


dynamodb_client.wait_until(:table_exists, table_name: 'polls')