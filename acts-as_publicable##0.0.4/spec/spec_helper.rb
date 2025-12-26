def load_models!
    ActiveRecord::Base.descendants.each do |model|
        model.delete_all
        Object.class_eval { remove_const model.name if const_defined?(model.name) }
    end

    load File.dirname(__FILE__) + "/support/models.rb"
end

Bundler.setup
require "rails/all"
Bundler.require(:default)

require "rspec/rails"
require "acts_as_publicable"


ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => ":memory:"
load "schema.rb"

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
    config.before do
        load_models!
    end
end
