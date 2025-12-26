ActiveRecord::Migration.verbose = false
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Base.logger = Logger.new(File.join(File.dirname(__FILE__), '../debug.log'))
ActiveRecord::Base.logger.level = ENV['TRAVIS'] ? ::Logger::ERROR : ::Logger::DEBUG

ActiveRecord::Schema.define(version: 1) do
  create_table :players do |t|
    t.string :first_name
    t.string :last_name
    t.string :position, limit: 2
    t.string :city
    t.string :club

    t.timestamps null: false
  end
end

class ActsAsExplorable::TestModelBase < ActiveRecord::Base
  self.table_name = :players
end

class Player < ActsAsExplorable::TestModelBase
  extend ActsAsExplorable
  explorable in: [:first_name, :last_name, :position, :city, :club],
             sort: [:first_name, :last_name, :position, :city, :club, :created_at],
             position: %w(GK MF FW)
end

class ArgumentsPlayer < ActsAsExplorable::TestModelBase
  extend ActsAsExplorable
  explorable in: [:first_name, :last_name, :position, :city, :club],
             sort: [:first_name, :last_name, :position, :city, :club, :created_at],
             position: %w(GK MF FW)
end

class BlockPlayer < ActsAsExplorable::TestModelBase
  extend ActsAsExplorable
  explorable do |config|
    config.filters = {
      in: [:first_name, :last_name, :position, :city, :club],
      sort: [:first_name, :last_name, :position, :city, :club, :created_at],
      position: %w(GK MF FW)
    }
  end
end

class BlockPlayer < ActsAsExplorable::TestModelBase
  extend ActsAsExplorable
  explorable in: [:first_name, :last_name, :position, :city, :club],
             sort: [:first_name, :last_name, :position, :city, :club, :created_at],
             position: %w(GK MF FW)

  explorable do |_config|

  end
end

class Explorable < ActsAsExplorable::TestModelBase
  extend ActsAsExplorable
  explorable
end

class NotExplorable < ActsAsExplorable::TestModelBase
end
