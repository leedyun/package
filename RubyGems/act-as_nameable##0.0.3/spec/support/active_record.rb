ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: 'act_as_nameable_spec.sqlite3'

ActiveRecord::Migration.create_table :test_records do |t|
  t.timestamps
end unless ActiveRecord::Base.connection.table_exists? :test_records

RSpec.configure do |config|
  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
