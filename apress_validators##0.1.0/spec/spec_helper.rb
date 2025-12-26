require 'bundler/setup'
require 'apress/validators'

require 'simplecov'
SimpleCov.start 'rails' do
  minimum_coverage 100
  add_filter 'lib'
end

require 'combustion'
Combustion.initialize! :active_record do
  config.i18n.enforce_available_locales = false
  config.i18n.default_locale = :ru
end

require 'rspec/rails'
RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.filter_run_including :focus => true
  config.run_all_when_everything_filtered = true
end
