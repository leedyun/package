# frozen_string_literal: true

require 'rspec'

require 'simplecov'
require 'simplecov-cobertura'

SimpleCov.start do
  add_filter 'spec'
end

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::CoberturaFormatter,
]

require 'omniauth-multipassword'

Dir[File.expand_path('spec/support/**/*.rb')].sort.each {|f| require f }

RSpec.configure do |config|
  config.order = 'random'

  config.before do
    OmniAuth.config.logger = Logger.new(IO::NULL)
  end
end
