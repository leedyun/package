require "coveralls"
require "simplecov"

SimpleCov.start do
  formatter SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter,
  ]
  command_name "Unit Tests"
  add_filter "/test/"
  add_filter "/lib/example_data.rb"
end

Coveralls.noisy = true

require 'minitest/autorun'

# Autoload all lib/**/*.rb files so simplecov does not misses anything
Dir[File.expand_path("../../lib/**/*.rb", __FILE__)].each{|f| require f }

class ContributorsStats::ArrayLoggerExample
  attr_reader :data
  def info(msg)
    @data ||= []
    @data << msg
  end
end
