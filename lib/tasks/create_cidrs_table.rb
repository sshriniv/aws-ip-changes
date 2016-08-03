#Creates 'polls' table

require 'aws-sdk'

attribute_defs = [
  { attribute_name: 'sync_token', attribute_type: 'S' },
]
p attribute_defs


key_schema = [
  { attribute_name: 'sync_token', key_type: 'HASH' },
]
p key_schema


index_schema = [
  { attribute_name: 'sync_token', key_type: 'HASH'  }
]
p index_schema


global_indexes = [{
  index_name:             'syncTokenIndex',
  key_schema:             index_schema,
  projection:             { projection_type: 'ALL' },
  provisioned_throughput: { read_capacity_units: 5, write_capacity_units: 10 }
}]
p global_indexes


request = {
  attribute_definitions:    attribute_defs,
  table_name:               'cidrs',
  key_schema:               key_schema,
  global_secondary_indexes: global_indexes,
  provisioned_throughput:   { read_capacity_units: 5, write_capacity_units: 10 }
}
p request


dynamodb_client = Aws::DynamoDB::Client.new(region: 'us-west-2')
p dynamodb_client


dynamodb_client.create_table(request)
p dynamodb_client


dynamodb_client.wait_until(:table_exists, table_name: 'cidrs')