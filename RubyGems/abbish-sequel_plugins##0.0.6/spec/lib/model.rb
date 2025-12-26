require 'sequel'
require 'abbish_sequel_plugins'

Sequel::Model.db = Sequel.sqlite
Sequel::Model.db.create_table :test_table do
  primary_key :id
  String :table_field
  String :record_version
  Time :record_created_time
  Time :record_updated_time
  Time :record_deleted_time
  Integer :record_protected
  Integer :record_deleted
end

class Model < Sequel::Model(:test_table)
  plugin Abbish::Sequel::Plugins::Model::SuperRecord::Protection
  plugin Abbish::Sequel::Plugins::Model::SuperRecord::Timestamp
  plugin Abbish::Sequel::Plugins::Model::SuperRecord::Version
end