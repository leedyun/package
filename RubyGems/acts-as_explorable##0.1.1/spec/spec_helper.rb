begin
  require 'byebug'
rescue LoadError
end
$LOAD_PATH << '.' unless $LOAD_PATH.include?('.')
$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
require 'logger'

require File.expand_path('../../lib/acts_as_explorable', __FILE__)
I18n.enforce_available_locales = true
require 'rails'
require 'rspec/its'
require 'sqlite3'
require 'factory_girl'
require 'database_cleaner'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.raise_errors_for_deprecations!
end

FactoryGirl.find_definitions
