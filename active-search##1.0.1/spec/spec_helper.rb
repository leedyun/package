require 'coveralls'
Coveralls.wear!
SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
require 'active_search'
require 'active_record'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3",
  :database => ":memory:")

ActiveRecord::Schema.define do
  self.verbose = false
  create_table :models, :force => true do |t|
    t.string :test
  end
  create_table :searchable_models, :force => true do |t|
    t.string :test
    t.string :banana
    t.integer :is_not_searchable_model_id
    t.integer :is_searchable_model_id
  end
  create_table :is_not_searchable_models, :force => true do |t|
    t.string :test
  end
  create_table :is_searchable_models, :force => true do |t|
    t.string :test
  end
  create_table :findable_models, :force => true do |t|
    t.string :test
  end
end
