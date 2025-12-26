require 'active_record'
require 'ar_lightning'

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
ActiveRecord::Migrator.up "db/migrate"

ActiveRecord::Migration.create_table :items, :id => false do |t|
  t.string :field_1
  t.string :field_2
  t.integer :field_3
end

class Item < ActiveRecord::Base
end

RSpec.configure do |config|
  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
